/**
 * Generator Agent — produces a candidate via the shared JaCaMo GL artifact.
 *
 * Uses CArtAgO artifact operations instead of internal actions.
 * When the Generator accepts a candidate, the observable property
 * gl_accepted(CandidateId, FieldsCsv) is perceived by ALL agents
 * focused on the artifact — no ACL messages needed.
 *
 * Same GL flow as ASTRA/Jason two-agent-assessment examples:
 *   use_provider → invoke → valid → field → accept/reject + assess
 *
 * Provider is configurable via GL_PROVIDER / GL_MODEL env vars.
 */

!start.

+!start
   <- .println("[Generator] Starting candidate generation...");

      // Create the shared GL artifact — other agents will focus on it
      makeArtifact("gl", "gl.adapter.jacamo.JaCaMoAdapter", [], GlId);
      focus(GlId);

      // Tell the assessor to focus on the same artifact
      .send(assessor, achieve, focus_gl);

      .wait(500);  // wait for assessor to focus

      // Step 1 — Configure provider from environment (default: fake)
      use_provider;
      !generate_candidate("mango").

+!generate_candidate(FoodItem)
   <- // Step 2 — Invoke the generative resource (same args as ASTRA/Jason)
      invoke("generator", "classify_food", "llm.answer", "ANSWER",
             "Classify 'mango' as a food type. Return label and confidence.",
             "label,confidence", ResultId);
      .println("[Generator] resultId  = ", ResultId);
      !process_generation(ResultId).

// Step 3 — deliberate based on validation results using BDI context-guards:
+!process_generation(ResultId)
   :  valid(ResultId, true)
   <- outcome(ResultId, Outcome);
      .println("[Generator] outcome   = ", Outcome);
      .println("[Generator] valid     = true");
      candidate(ResultId, CandidateId);

      field(ResultId, "label", Label);
      field(ResultId, "confidence", Confidence);

      .println("[Generator] Candidate valid. Requesting assessment...");
      .println("[Generator]   label      = ", Label);
      .println("[Generator]   confidence = ", Confidence);

      // Accept → creates gl_accepted observable property perceived by peer Assessor
      accept(CandidateId);
      .println("[Generator] Candidate ACCEPTED. Assessor perceives via artifact.").

+!process_generation(ResultId)
   :  valid(ResultId, false)
   <- outcome(ResultId, Outcome);
      .println("[Generator] outcome   = ", Outcome);
      .println("[Generator] valid     = false");
      candidate(ResultId, CandidateId);

      if (CandidateId \== "") {
          reject(CandidateId);
      };
      .println("[Generator] Candidate invalid. REJECTED immediately.").

// The Generator also perceives its own acceptance
+gl_accepted(CandidateId, Fields)
   <- .println("[Generator] Observed gl_accepted: ", CandidateId, " -> ", Fields).
