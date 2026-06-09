// Pipeline: start → !banner → !configured → !try_classify(strict) → !try_classify(relaxed) → !demo_complete
/**
 * Invalid Output Rejection — Generative Layer demonstration (Jason).
 *
 * Shows how the Generative Layer framework handles invalid/malformed
 * generative output.
 *
 * Key thesis point: fail-closed by default.
 * Invalid output never reaches the agent's belief base.
 */

// Requires: GL ontology beliefs (gl_status, gl_candidate_type, gl_verdict_type, ...)
//   See: https://github.com/generativelayers/examples/tree/main/jason/shared

// setting("model", "gpt-oss-120b"). setting("provider", "cerebras").
setting("model", "gpt-oss-120b"). setting("provider", "cerebras").
attempt(0).

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !banner;
      !configured(true);
      !try_classify(
          "Classify 'banana' as food. Return label, confidence, and category.",
          "label,confidence,category", 1
      );
      !try_classify(
          "Classify 'banana' as food. Return label and confidence.",
          "label,confidence", 2
      );
      !demo_complete.

// ACHIEVEMENT: display banner (actions only)
+!banner
   <- .println("=== Generative Layer Invalid Output Rejection Demo ===");
      .println("").

// ACHIEVEMENT: display demo complete (actions only)
+!demo_complete
   <- .println("");
      .println("=== Demo Complete ===").

// ACHIEVEMENT: setup (actions only)
+!configured(true)
   :  setting("model", M) & setting("provider", P)
   <- gl.configure("model", M);
      gl.use_provider(P).

// DECOMPOSITION: classify = log attempt → invoke → deliberate
+!try_classify(Prompt, RequiredCsv, AttemptNum)
   <- !log_attempt(AttemptNum, RequiredCsv);
      gl.invoke("agent_a", "classify_food", "llm.answer", "ANSWER",
               Prompt, RequiredCsv, Rid);
      !deliberated(Rid, AttemptNum).

// ACHIEVEMENT: log attempt (actions only)
+!log_attempt(AttemptNum, RequiredCsv)
   <- .println("[ATTEMPT ", AttemptNum, "] Invoking gl...");
      .println("[ATTEMPT ", AttemptNum, "]   required = ", RequiredCsv).

// ACHIEVEMENT: valid → accept
+!deliberated(Rid, AttemptNum)
   :  gl.valid(Rid, true)
   <- gl.outcome(Rid, Outcome);
      .println("[ATTEMPT ", AttemptNum, "]   outcome  = ", Outcome);
      .println("[ATTEMPT ", AttemptNum, "]   valid    = true");
      gl.candidate(Rid, Cid);
      gl.accept(Cid);
      +accepted(Cid);
      gl.field(Rid, "label", Label);
      gl.field(Rid, "confidence", Confidence);
      +classification(Label, Confidence, AttemptNum);
      -+attempt(AttemptNum);
      .println("[ATTEMPT ", AttemptNum, "]   ACCEPTED");
      .println("[ATTEMPT ", AttemptNum, "]     label      = ", Label);
      .println("[ATTEMPT ", AttemptNum, "]     confidence = ", Confidence);
      .println("").

// ACHIEVEMENT: invalid → reject (fail-closed)
+!deliberated(Rid, AttemptNum)
   :  gl.valid(Rid, false)
   <- gl.outcome(Rid, Outcome);
      .println("[ATTEMPT ", AttemptNum, "]   outcome  = ", Outcome);
      .println("[ATTEMPT ", AttemptNum, "]   valid    = false");
      gl.candidate(Rid, Cid);
      gl.reject(Cid);
      +rejected(Cid, Outcome);
      -+attempt(AttemptNum);
      .println("[ATTEMPT ", AttemptNum, "]   REJECTED — ", Outcome);
      .println("[ATTEMPT ", AttemptNum, "]   No beliefs adopted. Fail-closed.");
      .println("").

// RECOVERY
-!try_classify(Prompt, RequiredCsv, AttemptNum)
   <- .println("[ATTEMPT ", AttemptNum, "] Classification FAILED").

-!deliberated(Rid, AttemptNum)
   <- .println("[ATTEMPT ", AttemptNum, "] Deliberation FAILED").
