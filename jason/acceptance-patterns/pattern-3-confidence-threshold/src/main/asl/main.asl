// Pipeline: start > !banner > !classified > !assessed > !assess_confidence | !rejected_candidate
/**
 * Pattern 3: Confidence Tier - Jason
 *
 * Use a categorical confidence tier: high accepts, low rejects,
 * and medium/unknown escalates.
 */

// Requires: GL ontology beliefs (gl_status, gl_candidate_type, gl_verdict_type, ...)
//   See: https://github.com/generativelayers/examples/tree/main/jason/shared

// DOMAIN MODEL
assessed(Cid) :- accepted(Cid).
assessed(Cid) :- rejected(Cid).
assessed(Cid) :- escalated(Cid).
has_candidate(Cid) :- Cid \== "".
no_candidate(Cid)  :- Cid == "".

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !banner;
      gl.bind("agent1", "groq", "llama-3.3-70b-versatile", "", Bid);
      +binding(Bid);
      !classified("apple");
      !shutdown.

// ACHIEVEMENT: clean exit
+!shutdown
   <- .stopMAS.

// ACHIEVEMENT: display banner
+!banner
   :  gl.see(Providers)
   <- .println("=== Pattern 3: Confidence Tier ===");
      .println("");
      .println("[Layer] Available providers: ", Providers).

// DECOMPOSITION: classify = call + deliberate/assess
+!classified(Item)
   :  binding(Bid)
   <- .concat("Classify: ", Item, ". Return label and confidence_tier: high, medium, or low.", Prompt);
      gl.call(Bid, "classify", "llm.answer", "ANSWER", Prompt, "label,confidence_tier", "", Rid);
      !assessed(Rid).

// SERENDIPITY: already assessed
+!assessed(Rid)
   :  gl.candidate(Rid, Cid) & assessed(Cid)
   <- .println("[AGENT] Already assessed: ", Rid).

// DECOMPOSITION: admissible > check confidence tier
+!assessed(Rid)
   :  gl.candidate(Rid, Cid) & gl.decide(Cid, "ADMISSIBLE") & gl.get(Cid, "confidence_tier", Tier)
   <- !assess_confidence(Rid, Cid, Tier);
      !print_trace(Rid).

// DECOMPOSITION: not admissible > reject
+!assessed(Rid)
   :  gl.candidate(Rid, Cid)
   <- !rejected_candidate(Cid, Rid);
      !print_trace(Rid).

// ACHIEVEMENT: high confidence > accept
+!assess_confidence(Rid, Cid, "high")
   :  gl.get(Cid, "label", Label)
   <- gl.accept(Cid, "high confidence", _);
      +accepted(Cid);
      +confidence_tier(Cid, "high");
      .println("High confidence - ACCEPTED");
      .println("  label = ", Label).

// ACHIEVEMENT: low confidence > reject
+!assess_confidence(Rid, Cid, "low")
   <- gl.reject(Cid, "low confidence", _);
      +rejected(Cid);
      +confidence_tier(Cid, "low");
      .println("Low confidence - REJECTED").

// ACHIEVEMENT: medium/other > escalate
+!assess_confidence(Rid, Cid, Tier)
   <- +escalated(Cid);
      +confidence_tier(Cid, Tier);
      .println("Confidence tier '", Tier, "' - ESCALATING").

// ACHIEVEMENT: reject (actions only) - candidate exists
+!rejected_candidate(Cid, Rid)
   :  has_candidate(Cid)
   <- gl.reject(Cid, "failed validation", _);
      +rejected(Cid);
      .println("Invalid output - REJECTED").

// ACHIEVEMENT: reject (actions only) - no candidate
+!rejected_candidate(Cid, Rid)
   :  no_candidate(Cid) & gl.result(Rid, Outcome)
   <- +rejected("");
      .println("Invocation failed, no candidate - REJECTED (outcome = ", Outcome, ")").

// ACHIEVEMENT: print trace
+!print_trace(Rid)
   :  gl.explain(Rid, Trace)
   <- .println("");
      .println("[TRACE] ", Trace).

// RECOVERY
-!assessed(Rid)
   :  not accepted(_) & not rejected(_) & not escalated(_)
   <- .println("Assessment FAILED for ", Rid).
