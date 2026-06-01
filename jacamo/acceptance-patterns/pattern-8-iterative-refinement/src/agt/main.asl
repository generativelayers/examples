// Pipeline: start → !artifact_ready → !configured → !refined → !critiqued → !improved → !accepted_final → ?refined
/**
 * Pattern 8: Iterative Refinement — JaCaMo
 *
 * Three-step pipeline: Draft → Critique → Refine → Accept.
 * Each step goes through the governance pipeline.
 * Only the final refined version is accepted.
 */

// setting("model", "gpt-oss-120b"). setting("provider", "cerebras").
setting("model", "gemini-2.5-flash"). setting("provider", "gemini").

// DOMAIN MODEL
refined(Rid) :- accepted_final(true).

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !artifact_ready;
      !configured(true);
      ask("agent1", "draft", "Write a 3-sentence summary of photosynthesis", Rid);
      !refined(Rid).

// ACHIEVEMENT: create and focus the GL artifact
+!artifact_ready
   <- makeArtifact("gl", "gl.adapter.jacamo.JaCaMoAdapter", [], GlId);
      focus(GlId).

// ACHIEVEMENT: setup (actions only)
+!configured(true)
   :  setting("model", M) & setting("provider", P)
   <- configure("model", M);
      use_provider(P).

// SERENDIPITY
+!refined(Rid)
   :  refined(Rid)
   <- .println("Already refined: ", Rid).

// DECOMPOSITION: bind validity → branch
+!refined(Rid)
   <- valid(Rid, IsValid);
      !refined_branch(Rid, IsValid).

// DECOMPOSITION: valid → critique + improve + accept
+!refined_branch(Rid, true)
   <- !critiqued(Rid);
      !improved(Rid);
      !accepted_final(Rid);
      ?refined(Rid).

// ACHIEVEMENT: invalid draft
+!refined_branch(Rid, false)
   <- -+pipeline_step("draft_failed");
      .println("Draft invalid → ABORTED").

// ACHIEVEMENT: critique
+!critiqued(DraftRid)
   <- -+pipeline_step("critiquing");
      ask("agent1", "critique", "Critique the summary of photosynthesis", CritiqueRid);
      valid(CritiqueRid, CValid);
      if (CValid) {
          +critiqued(CritiqueRid);
          .println("Draft → critique requested");
      } else {
          .println("Critique invalid → ABORTED");
          .fail;
      }.

// SERENDIPITY
+!critiqued(Rid)
   :  critiqued(Rid)
   <- .println("Already critiqued").

// ACHIEVEMENT: improve
+!improved(Rid)
   :  critiqued(CritiqueRid)
   <- -+pipeline_step("refining");
      ask("agent1", "refine", "Improve the summary based on feedback", FinalRid);
      valid(FinalRid, FValid);
      if (FValid) {
          +improved(FinalRid);
          .println("Critique → refinement requested");
      } else {
          .println("Refinement invalid → ABORTED");
          .fail;
      }.

// SERENDIPITY
+!improved(Rid)
   :  improved(Rid)
   <- .println("Already improved").

// ACHIEVEMENT: accept final
+!accepted_final(Rid)
   :  improved(FinalRid)
   <- candidate(FinalRid, Cid);
      accept(Cid);
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
