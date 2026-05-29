/**
 * Invalid Output Rejection β€” Generative Layer demonstration (Jason).
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
      gl.configure("model", "llama-3.3-70b-versatile");

      gl.use_provider("groq");

      // Attempt 1 β€” invoke with strict required fields (missing 'category' will trigger validation failure)
      !tryClassify(
          "Classify 'banana' as food. Return label, confidence, and category.",
          "label,confidence,category",
          1
      );

      // Attempt 2 β€” invoke with relaxed required fields (success!)
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

      gl.invoke(
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
   :  gl.valid(ResultId, true)
   <- gl.outcome(ResultId, Outcome);
      .println("[ATTEMPT ", AttemptNum, "]   outcome  = ", Outcome);
      .println("[ATTEMPT ", AttemptNum, "]   valid    = true");

      gl.candidate(ResultId, CandidateId);
      gl.field(ResultId, "label", Label);
      gl.field(ResultId, "confidence", Confidence);

      gl.accept(CandidateId);
      +candidate_accepted(CandidateId);
      +classification(Label, Confidence, AttemptNum);

      .println("[ATTEMPT ", AttemptNum, "]   ACCEPTED");
      .println("[ATTEMPT ", AttemptNum, "]     label      = ", Label);
      .println("[ATTEMPT ", AttemptNum, "]     confidence = ", Confidence);
      .println("").

+!deliberate_result(ResultId, AttemptNum)
   :  gl.valid(ResultId, false)
   <- gl.outcome(ResultId, Outcome);
      .println("[ATTEMPT ", AttemptNum, "]   outcome  = ", Outcome);
      .println("[ATTEMPT ", AttemptNum, "]   valid    = false");

      gl.candidate(ResultId, CandidateId);
      if (CandidateId == "") {
          .println("[ATTEMPT ", AttemptNum, "]   FAILED β€” No candidate created.");
      } else {
          gl.reject(CandidateId);
          +candidate_rejected(CandidateId, Outcome);
          .println("[ATTEMPT ", AttemptNum, "]   REJECTED β€” ", Outcome);
          .println("[ATTEMPT ", AttemptNum, "]   No beliefs adopted. Fail-closed.");
      };
      .println("").
