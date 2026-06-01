// Pipeline: start → !configured → !assessed → !assess_confidence(high|low|medium) → ?assessed
/**
 * Pattern 3: Confidence Threshold — Jason
 *
 * Extracts the confidence field and makes a tiered decision:
 * high → accept, low → reject + fail, otherwise → escalate.
 */

// Requires: GL ontology beliefs (gl_status, gl_candidate_type, gl_verdict_type, ...)
//   See: https://github.com/generativelayers/examples/tree/main/jason/shared

// setting("model", "gpt-oss-120b"). setting("provider", "cerebras").
setting("model", "gemini-2.5-flash"). setting("provider", "gemini").
threshold("high", "1.0"). threshold("low", "0.0").

// DOMAIN MODEL
assessed(Rid) :- confidence_tier(Rid, _).

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !configured(true);
      gl.invoke("agent1", "classify", "llm.answer", "ANSWER",
               "Classify: apple", "label,confidence", Rid);
      !assessed(Rid).

// ACHIEVEMENT: setup (actions only)
+!configured(true)
   :  setting("model", M) & setting("provider", P)
   <- gl.configure("model", M);
      gl.use_provider(P).

// SERENDIPITY
+!assessed(Rid)
   :  assessed(Rid)
   <- .println("Already assessed: ", Rid).

// DECOMPOSITION: valid → extract confidence, delegate to tier assessment
+!assessed(Rid)
   :  gl.valid(Rid, true)
   <- gl.candidate(Rid, Cid);
      gl.field(Rid, "confidence", Conf);
      !assess_confidence(Rid, Cid, Conf).

// ACHIEVEMENT: invalid output
+!assessed(Rid)
   <- .println("Invalid output → REJECTED").

// ACHIEVEMENT: high confidence → accept
+!assess_confidence(Rid, Cid, Conf)
   :  threshold("high", Conf)
   <- gl.accept(Cid);
      +accepted(Rid);
      +confidence_tier(Rid, "high");
      ?assessed(Rid);
      .println("High confidence (", Conf, ") → ACCEPTED").

// ACHIEVEMENT: low confidence → reject, fail
+!assess_confidence(Rid, Cid, Conf)
   :  threshold("low", Conf)
   <- gl.reject(Cid);
      +confidence_tier(Rid, "low");
      ?assessed(Rid);
      .println("Low confidence (", Conf, ") → REJECTED");
      .fail.

// ACHIEVEMENT: medium confidence → escalate (catch-all valid)
+!assess_confidence(Rid, Cid, Conf)
   <- +confidence_tier(Rid, "medium");
      ?assessed(Rid);
      .println("Medium confidence → ESCALATING").

// RECOVERY
-!assessed(Rid)
   <- .println("Assessment FAILED for ", Rid).
