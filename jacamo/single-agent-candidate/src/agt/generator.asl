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

      // Step 2 — Invoke the generative resource (same args as ASTRA/Jason)
      invoke("generator", "classify_food", "llm.answer", "ANSWER",
             "Classify 'mango' as a food type. Return label and confidence.",
             "label,confidence", ResultId);

      outcome(ResultId, Outcome);
      valid(ResultId, IsValid);

      .println("[Generator] resultId  = ", ResultId);
      .println("[Generator] outcome   = ", Outcome);
      .println("[Generator] valid     = ", IsValid);

      // Step 3 — Get the candidate handle
      candidate(ResultId, CandidateId);

      // Step 4 — Agent deliberation: inspect, then accept or reject
      if (IsValid == true) {
          field(ResultId, "label", Label);
          field(ResultId, "confidence", Confidence);

          .println("[Generator] Candidate valid. Requesting assessment...");
          .println("[Generator]   label      = ", Label);
          .println("[Generator]   confidence = ", Confidence);

          // Accept → creates gl_accepted observable property
          // The Assessor perceives +gl_accepted(...) via artifact sensing
          // (instead of ACL messages used in Jason/ASTRA examples)
          accept(CandidateId);

          .println("[Generator] Candidate ACCEPTED. Assessor perceives via artifact.");
      } else {
          // Invalid — reject immediately
          if (CandidateId \== "") {
              reject(CandidateId);
          };
          .println("[Generator] Candidate invalid. REJECTED immediately.");
      }.

// The Generator also perceives its own acceptance
+gl_accepted(CandidateId, Fields)
   <- .println("[Generator] Observed gl_accepted: ", CandidateId, " -> ", Fields).
