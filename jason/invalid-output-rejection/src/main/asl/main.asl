// Pipeline: start > !banner > !try_classify(attempt 1 & 2) > !deliberated > !accepted_candidate | !rejected_candidate
/**
 * Invalid Output Rejection - Jason
 *
 * Demonstrates the Generative Layer's ability to reject candidates
 * that fail validation (e.g. missing required fields or incorrect schema),
 * failing closed without adopting unvalidated beliefs.
 */

// Requires: GL ontology beliefs (gl_status, gl_candidate_type, gl_verdict_type, ...)
//   See: https://github.com/generativelayers/examples/tree/main/jason/shared

// DOMAIN MODEL
has_candidate(Cid) :- Cid \== "".
no_candidate(Cid)  :- Cid == "".

attempt(0).

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !banner;
      gl.bind("agent_a", "groq", "llama-3.3-70b-versatile", "", Bid);
      +binding(Bid);
      !try_classify(
          "Classify 'banana' as food. Return label, confidence, and category.",
          "label,confidence,category", 1
      );
      !try_classify(
          "Classify 'banana' as food. Return label and confidence.",
          "label,confidence", 2
      );
      !demo_complete;
      !shutdown.

// ACHIEVEMENT: clean exit (actions only)
+!shutdown
   <- .stopMAS.

// ACHIEVEMENT: display banner
+!banner
   <- .println("=== Generative Layer Invalid Output Rejection Demo ===");
      .println("").

// ACHIEVEMENT: display demo complete
+!demo_complete
   <- .println("");
      .println("=== Demo Complete ===").

// DECOMPOSITION: classify = log attempt > call > deliberate
+!try_classify(Prompt, RequiredCsv, AttemptNum)
   :  binding(Bid)
   <- !log_attempt(AttemptNum, RequiredCsv);
      gl.call(Bid, "classify_food", "llm.answer", "ANSWER", Prompt, RequiredCsv, "", Rid);
      !deliberated(Rid, AttemptNum).

// ACHIEVEMENT: log attempt
+!log_attempt(AttemptNum, RequiredCsv)
   <- .println("[ATTEMPT ", AttemptNum, "] Invoking gl...");
      .println("[ATTEMPT ", AttemptNum, "]   required = ", RequiredCsv).

// DECOMPOSITION: handle deliberation based on outcome
+!deliberated(Rid, AttemptNum)
   :  gl.candidate(Rid, Cid) & gl.decide(Cid, "ADMISSIBLE")
   <- !accepted_candidate(Rid, Cid, AttemptNum).

+!deliberated(Rid, AttemptNum)
   :  gl.candidate(Rid, Cid)
   <- !rejected_candidate(Cid, Rid, AttemptNum).

// ACHIEVEMENT: accept (actions only)
+!accepted_candidate(Rid, Cid, AttemptNum)
   :  gl.decide(Cid, Admissibility) &
      gl.get(Cid, "label", Label) &
      gl.get(Cid, "confidence", Confidence)
   <- .println("[ATTEMPT ", AttemptNum, "]   outcome  = ", Admissibility);
      .println("[ATTEMPT ", AttemptNum, "]   valid    = true");
      gl.accept(Cid, "admissible output", _);
      +accepted(Cid);
      .concat("attempt_", AttemptNum, AttemptStr);
      +classification(Label, Confidence, AttemptStr);
      -+attempt(AttemptNum);
      .println("[ATTEMPT ", AttemptNum, "]   ACCEPTED");
      .println("[ATTEMPT ", AttemptNum, "]     label      = ", Label);
      .println("[ATTEMPT ", AttemptNum, "]     confidence = ", Confidence);
      .println("").

// ACHIEVEMENT: reject (actions only) - candidate exists
+!rejected_candidate(Cid, Rid, AttemptNum)
   :  has_candidate(Cid) & gl.decide(Cid, Admissibility)
   <- .println("[ATTEMPT ", AttemptNum, "]   outcome  = ", Admissibility);
      .println("[ATTEMPT ", AttemptNum, "]   valid    = false");
      gl.reject(Cid, "failed validation/deliberation", _);
      +rejected(Cid, Admissibility);
      -+attempt(AttemptNum);
      .println("[ATTEMPT ", AttemptNum, "]   REJECTED: ", Admissibility);
      .println("[ATTEMPT ", AttemptNum, "]   No beliefs adopted. Fail-closed.");
      .println("").

// ACHIEVEMENT: reject (actions only) - no candidate
+!rejected_candidate(Cid, Rid, AttemptNum)
   :  no_candidate(Cid) & gl.result(Rid, Outcome)
   <- .println("[ATTEMPT ", AttemptNum, "]   outcome  = ", Outcome);
      .println("[ATTEMPT ", AttemptNum, "]   valid    = false");
      +rejected("", Outcome);
      -+attempt(AttemptNum);
      .println("[ATTEMPT ", AttemptNum, "]   REJECTED: ", Outcome);
      .println("[ATTEMPT ", AttemptNum, "]   No beliefs adopted. Fail-closed.");
      .println("").

// RECOVERY
-!try_classify(Prompt, RequiredCsv, AttemptNum)
   :  attempt(0)
   <- .println("[ATTEMPT ", AttemptNum, "] Classification FAILED").

-!deliberated(Rid, AttemptNum)
   :  attempt(0)
   <- .println("[ATTEMPT ", AttemptNum, "] Deliberation FAILED").
