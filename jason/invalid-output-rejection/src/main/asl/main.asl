/**
 * Invalid Output Rejection — Generative Layer demonstration (Jason).
 *
 * Shows how the Generative Layer framework handles invalid/malformed
 * generative output.
 *
 * Key thesis point: fail-closed by default.
 * Invalid output never reaches the agent's belief base.
 *
 * Provider is configurable via GL_PROVIDER / GL_MODEL env vars.
 */

!start.

+!start
   <- .println("=== Generative Layer Invalid Output Rejection Demo ===");
      .println("");

      // Configure provider from environment (default: fake)
      gl.actions.use_provider;

      // Attempt 1 — invoke with strict required fields (missing 'category' will trigger validation failure)
      !tryClassify(
          "Classify 'banana' as food. Return label, confidence, and category.",
          "label,confidence,category",
          1
      );

      // Attempt 2 — invoke with relaxed required fields (success!)
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

      gl.actions.invoke(
          "agent_b",                  // agentId
          "classify_food",            // goalId
          "llm.answer",               // bodyId
          "ANSWER",                   // affordance type
          Prompt,
          RequiredCsv,                // required fields for validation
          ResultId                    // output: bound result ID
      );
      !deliberate_result(ResultId, AttemptNum).

// Deliberation using context-guarded plans instead of procedural checks:
+!deliberate_result(ResultId, AttemptNum)
   :  gl.actions.valid(ResultId, true)
   <- gl.actions.outcome(ResultId, Outcome);
      .println("[ATTEMPT ", AttemptNum, "]   outcome  = ", Outcome);
      .println("[ATTEMPT ", AttemptNum, "]   valid    = true");

      gl.actions.candidate(ResultId, CandidateId);
      gl.actions.field(ResultId, "label", Label);
      gl.actions.field(ResultId, "confidence", Confidence);

      gl.actions.accept(CandidateId);
      +candidate_accepted(CandidateId);
      +classification(Label, Confidence, AttemptNum);

      .println("[ATTEMPT ", AttemptNum, "]   ACCEPTED");
      .println("[ATTEMPT ", AttemptNum, "]     label      = ", Label);
      .println("[ATTEMPT ", AttemptNum, "]     confidence = ", Confidence);
      .println("").

+!deliberate_result(ResultId, AttemptNum)
   :  gl.actions.valid(ResultId, false)
   <- gl.actions.outcome(ResultId, Outcome);
      .println("[ATTEMPT ", AttemptNum, "]   outcome  = ", Outcome);
      .println("[ATTEMPT ", AttemptNum, "]   valid    = false");

      gl.actions.candidate(ResultId, CandidateId);
      if (CandidateId == "") {
          .println("[ATTEMPT ", AttemptNum, "]   FAILED — No candidate created.");
      } else {
          gl.actions.reject(CandidateId);
          +candidate_rejected(CandidateId, Outcome);
          .println("[ATTEMPT ", AttemptNum, "]   REJECTED — ", Outcome);
          .println("[ATTEMPT ", AttemptNum, "]   No beliefs adopted. Fail-closed.");
      };
      .println("").
