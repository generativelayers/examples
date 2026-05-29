/**
 * Pattern 8: Iterative Refinement — JaCaMo
 *
 * Three-step pipeline: Draft → Critique → Refine → Accept.
 * Each step goes through the governance pipeline.
 * Only the final refined version is accepted.
 */

!start.

+!start
   <- .println("=== Pattern 8: Iterative Refinement ===");
      makeArtifact("gl", "gl.adapter.jacamo.JaCaMoAdapter", [], GlId);
      focus(GlId);
      use_provider;
      // Step 1: Generate a draft
      ask("agent1", "draft", "Write a 3-sentence summary of photosynthesis", DraftRid);
      valid(DraftRid, DraftValid);
      !critique(DraftRid, DraftValid).

// Step 2: Critique the draft
+!critique(DraftRid, true)
   <- .println("Draft generated (valid) -> requesting critique");
      ask("agent1", "critique", "Critique the summary of photosynthesis", CritiqueRid);
      valid(CritiqueRid, CritiqueValid);
      !refine(CritiqueRid, CritiqueValid).

+!critique(DraftRid, false)
   <- .println("Draft invalid -> ABORTED");
      .stopMAS.

// Step 3: Refine based on critique
+!refine(CritiqueRid, true)
   <- .println("Critique received (valid) -> refining");
      ask("agent1", "refine", "Improve the summary based on feedback", FinalRid);
      valid(FinalRid, FinalValid);
      !accept_final(FinalRid, FinalValid).

+!refine(CritiqueRid, false)
   <- .println("Critique invalid -> ABORTED");
      .stopMAS.

// Step 4: Accept the refined version
+!accept_final(FinalRid, true)
   <- candidate(FinalRid, Cid);
      accept(Cid);
      .println("Draft -> Critique -> Refine pipeline complete -> ACCEPTED");
      .stopMAS.

+!accept_final(FinalRid, false)
   <- .println("Final refinement invalid -> ABORTED");
      .stopMAS.
