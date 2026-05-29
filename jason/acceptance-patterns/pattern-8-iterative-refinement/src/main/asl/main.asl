/**
 * Pattern 8: Iterative Refinement — Jason
 *
 * Three-step pipeline: Draft → Critique → Refine → Accept.
 * Each step goes through the governance pipeline.
 * Only the final refined version is accepted.
 */

!start.

+!start
   <- .println("=== Pattern 8: Iterative Refinement ===");
      // gl.configure("model", "gemini-2.0-flash");
      // gl.use_provider("gemini");
      gl.configure("model", "llama-3.3-70b-versatile");
      gl.use_provider("groq");
      // Step 1: Generate a draft
      gl.ask("agent1", "draft", "Write a 3-sentence summary of photosynthesis", DraftRid);
      !critique(DraftRid).

// Step 2: Critique the draft
+!critique(DraftRid)
   :  gl.valid(DraftRid, true)
   <- .println("Draft generated (valid) -> requesting critique");
      gl.ask("agent1", "critique", "Critique the summary of photosynthesis", CritiqueRid);
      !refine(CritiqueRid).

+!critique(DraftRid)
   :  gl.valid(DraftRid, false)
   <- .println("Draft invalid -> ABORTED");
      .stopMAS.

// Step 3: Refine based on critique
+!refine(CritiqueRid)
   :  gl.valid(CritiqueRid, true)
   <- .println("Critique received (valid) -> refining");
      gl.ask("agent1", "refine", "Improve the summary based on feedback", FinalRid);
      !accept_final(FinalRid).

+!refine(CritiqueRid)
   :  gl.valid(CritiqueRid, false)
   <- .println("Critique invalid -> ABORTED");
      .stopMAS.

// Step 4: Accept the refined version
+!accept_final(FinalRid)
   :  gl.valid(FinalRid, true)
   <- gl.candidate(FinalRid, Cid);
      gl.accept(Cid);
      .println("Draft -> Critique -> Refine pipeline complete -> ACCEPTED");
      .stopMAS.

+!accept_final(FinalRid)
   :  gl.valid(FinalRid, false)
   <- .println("Final refinement invalid -> ABORTED");
      .stopMAS.
