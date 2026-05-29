/**
 * Invalid Output Rejection — Generative Layer demonstration (Jason).
 *
 * Shows how the Generative Layer framework handles invalid/malformed
 * generative output. The agent:
 *   1. Requests structured output with required fields
 *   2. Receives a result that fails validation (missing fields)
 *   3. Rejects the candidate — no belief pollution occurs
 *   4. Retries with a corrective/relaxed prompt
 *
 * Key thesis point: fail-closed by default.
 * Invalid output never reaches the agent's belief base.
 */

!start.

+!start
   <- .println("=== Generative Layer Invalid Output Rejection Demo ===");
      .println("");

      gl.adapters.jason.actions.use_provider("fake");

      // Attempt 1 — invoke with strict required fields
      // The fake provider will return output missing the 'category' field
      !tryClassify(
          "Classify 'banana' as food. Return label, confidence, and category.",
          "label,confidence,category",
          1
      );

      // Attempt 2 — invoke with relaxed required fields
      !tryClassify(
          "Classify 'banana' as food. Return label and confidence.",
          "label,confidence",
          2
      );

      .println("");
      .println("=== Demo Complete ===").

+!tryClassify(Prompt, RequiredCsv, AttemptNum)
   <- .println("[ATTEMPT ", AttemptNum, "] Invoking gl...");
      .println("[ATTEMPT ", AttemptNum, "]   required = ", RequiredCsv);

      gl.adapters.jason.actions.invoke(
          "agent_b",                  // agentId
          "classify_food",            // goalId
          "llm.answer",               // bodyId
          "ANSWER",                   // affordance type
          Prompt,
          RequiredCsv,                // required fields for validation
          ResultId                    // output: bound result ID
      );

      gl.adapters.jason.actions.outcome(ResultId, Outcome);
      .println("[ATTEMPT ", AttemptNum, "]   outcome  = ", Outcome);

      gl.adapters.jason.actions.valid(ResultId, IsValid);
      .println("[ATTEMPT ", AttemptNum, "]   valid    = ", IsValid);

      gl.adapters.jason.actions.candidate(ResultId, CandidateId);

      if (IsValid == true) {
          gl.adapters.jason.actions.field(ResultId, "label", Label);
          gl.adapters.jason.actions.field(ResultId, "confidence", Confidence);

          gl.adapters.jason.actions.accept(CandidateId);
          +candidate_accepted(CandidateId);
          +classification(Label, Confidence, AttemptNum);

          .println("[ATTEMPT ", AttemptNum, "]   ACCEPTED");
          .println("[ATTEMPT ", AttemptNum, "]     label      = ", Label);
          .println("[ATTEMPT ", AttemptNum, "]     confidence = ", Confidence);
      } else {
          // If candidateId is empty (e.g. provider failed), don't call reject
          if (CandidateId == "") {
              .println("[ATTEMPT ", AttemptNum, "]   FAILED — No candidate created.");
          } else {
              gl.adapters.jason.actions.reject(CandidateId);
              +candidate_rejected(CandidateId, Outcome);
              .println("[ATTEMPT ", AttemptNum, "]   REJECTED — ", Outcome);
              .println("[ATTEMPT ", AttemptNum, "]   No beliefs adopted. Fail-closed.");
          };
      };
      .println("").
