/**
 * Generator Agent — produces a candidate via Generative Layer invocation.
 *
 * After generating and validating, the Generator sends
 * the candidateId, label, and confidence to the Assessor agent via
 * KQML messages, then waits for an assessment verdict
 * before deciding to accept or reject.
 *
 * Provider is configurable via GL_PROVIDER / GL_MODEL env vars.
 */

!start.

+!start
   <- .println("[Generator] Starting candidate generation...");
      gl.actions.use_provider;
      !generate_candidate("mango").

+!generate_candidate(FoodItem)
   <- gl.actions.invoke(
          "generator", "classify_food", "llm.answer", "ANSWER",
          "Classify 'mango' as a food type. Return label and confidence.",
          "label,confidence",
          ResultId
      );
      .println("[Generator] resultId  = ", ResultId);
      !process_generation(ResultId).

+!process_generation(ResultId)
   :  gl.actions.valid(ResultId, true)
   <- gl.actions.candidate(ResultId, CandidateId);
      gl.actions.field(ResultId, "label", Label);
      gl.actions.field(ResultId, "confidence", Confidence);

      .println("[Generator] Candidate valid. Requesting assessment...");
      .println("[Generator]   label      = ", Label);
      .println("[Generator]   confidence = ", Confidence);

      // Step 2 — Send candidate to Assessor for peer review
      .send(assessor, achieve, review(CandidateId, ResultId, Label, Confidence));

      // Step 3 — Wait for assessment verdict
      .println("[Generator] Waiting for assessor verdict...").

+!process_generation(ResultId)
   :  gl.actions.valid(ResultId, false)
   <- gl.actions.candidate(ResultId, CandidateId);
      if (CandidateId \== "") {
          gl.actions.reject(CandidateId);
          +candidate_rejected(CandidateId);
      };
      .println("[Generator] Candidate invalid. REJECTED immediately.").

// Step 4 — Handle assessment response: ACCEPT
+verdict(CandidateId, "ACCEPT", Explanation)[source(Sender)]
   <- .println("[Generator] Assessment from ", Sender, ": ACCEPT");
      .println("[Generator]   reason: ", Explanation);

      // Agent decides to accept based on peer endorsement
      gl.actions.accept(CandidateId);
      +candidate_accepted(CandidateId);
      +assessment_received(CandidateId, "ACCEPT");

      .println("[Generator] Candidate ACCEPTED after peer assessment.").

// Step 4 — Handle assessment response: REJECT
+verdict(CandidateId, "REJECT", Explanation)[source(Sender)]
   <- .println("[Generator] Assessment from ", Sender, ": REJECT");
      .println("[Generator]   reason: ", Explanation);

      // Agent decides to reject based on peer contest
      gl.actions.reject(CandidateId);
      +candidate_rejected(CandidateId);
      +assessment_received(CandidateId, "REJECT");

      .println("[Generator] Candidate REJECTED after peer assessment.").
