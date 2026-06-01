// Pipeline: start → !configured → !refined → !critiqued → !improved → !accepted_final → ?refined
/**
 * Pattern 8: Iterative Refinement — Jason
 *
 * Three-step pipeline: Draft → Critique → Refine → Accept.
 * Each step goes through the governance pipeline.
 * Only the final refined version is accepted.
 */

// Requires: GL ontology beliefs (gl_status, gl_candidate_type, gl_verdict_type, ...)
//   See: https://github.com/generativelayers/examples/tree/main/jason/shared

// setting("model", "gpt-oss-120b"). setting("provider", "cerebras").
setting("model", "gemini-2.5-flash"). setting("provider", "gemini").

// DOMAIN MODEL
refined(Rid) :- accepted_final(true).

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !configured(true);
      gl.ask("agent1", "draft", "Write a 3-sentence summary of photosynthesis", Rid);
      !refined(Rid).

// ACHIEVEMENT: setup (actions only)
+!configured(true)
   :  setting("model", M) & setting("provider", P)
   <- gl.configure("model", M);
      gl.use_provider(P).

// SERENDIPITY
+!refined(Rid)
   :  refined(Rid)
   <- .println("Already refined: ", Rid).

// DECOMPOSITION: refine = critique + improve + accept
+!refined(Rid)
   :  gl.valid(Rid, true)
   <- !critiqued(Rid);
      !improved(Rid);
      !accepted_final(Rid);
      ?refined(Rid).

// ACHIEVEMENT: invalid draft
+!refined(Rid)
   <- -+pipeline_step("draft_failed");
      .println("Draft invalid → ABORTED").

// ACHIEVEMENT: critique
+!critiqued(DraftRid)
   :  gl.valid(DraftRid, true)
   <- -+pipeline_step("critiquing");
      gl.ask("agent1", "critique", "Critique the summary of photosynthesis", CritiqueRid);
      +critiqued(CritiqueRid);
      .println("Draft → critique requested").

// SERENDIPITY
+!critiqued(Rid)
   :  critiqued(Rid)
   <- .println("Already critiqued").

// ACHIEVEMENT: improve
+!improved(Rid)
   :  critiqued(CritiqueRid) & gl.valid(CritiqueRid, true)
   <- -+pipeline_step("refining");
      gl.ask("agent1", "refine", "Improve the summary based on feedback", FinalRid);
      +improved(FinalRid);
      .println("Critique → refinement requested").

// SERENDIPITY
+!improved(Rid)
   :  improved(Rid)
   <- .println("Already improved").

// ACHIEVEMENT: accept final
+!accepted_final(Rid)
   :  improved(FinalRid) & gl.valid(FinalRid, true)
   <- gl.candidate(FinalRid, Cid);
      gl.accept(Cid);
      +accepted_final(true);
      -+pipeline_step("accepted");
      .println("Draft → Critique → Refine → ACCEPTED").

// RECOVERY at each level
-!refined(Rid)
   <- -+pipeline_step("failed");
      .println("Refinement pipeline FAILED for ", Rid).

-!critiqued(Rid)
   <- -+pipeline_step("critique_failed");
      .println("Critique FAILED → pipeline aborted").

-!improved(Rid)
   <- -+pipeline_step("refine_failed");
      .println("Refinement FAILED → pipeline aborted").
