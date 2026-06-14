// Pipeline: start > !banner > !classified > !deliberated > !accepted_candidate | !rejected_candidate > !print_trace
/**
 * Pattern 1: Simple Validation - Jason
 *
 * The simplest governance pattern: accept valid output, reject invalid.
 * Demonstrates the fundamental decide() context-guard branching.
 */

// Requires: GL ontology beliefs (gl_status, gl_candidate_type, gl_verdict_type, ...)
//   See: https://github.com/generativelayers/examples/tree/main/jason/shared

// DOMAIN MODEL
validated(Cid) :- accepted(Cid).
validated(Cid) :- rejected(Cid).
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
   <- .println("=== Pattern 1: Simple Validation ===");
      .println("");
      .println("[Layer] Available providers: ", Providers).

// DECOMPOSITION: classify = call + deliberate
+!classified(FoodItem)
   :  binding(Bid)
   <- .concat("Classify the food item '", FoodItem, "'. Return label and confidence.", Prompt);
      gl.call(Bid, "classify_food", "llm.answer", "ANSWER", Prompt, "label,confidence", "", Rid);
      !deliberated(Rid).

// SERENDIPITY: already deliberated
+!deliberated(Rid)
   :  gl.candidate(Rid, Cid) & validated(Cid)
   <- .println("[AGENT] Already deliberated: ", Rid).

// DECOMPOSITION: admissible > accept + trace
+!deliberated(Rid)
   :  gl.candidate(Rid, Cid) & gl.decide(Cid, "ADMISSIBLE")
   <- !accepted_candidate(Rid, Cid);
      !print_trace(Rid).

// DECOMPOSITION: not admissible > reject + trace
+!deliberated(Rid)
   :  gl.candidate(Rid, Cid)
   <- !rejected_candidate(Cid, Rid);
      !print_trace(Rid).

// ACHIEVEMENT: accept (actions only)
+!accepted_candidate(Rid, Cid)
   :  gl.get(Cid, "label", Label) & gl.get(Cid, "confidence", Confidence)
   <- .println("");
      .println("[AGENT] Candidate is ADMISSIBLE.");
      .println("[AGENT]   label      = ", Label);
      .println("[AGENT]   confidence = ", Confidence);
      gl.accept(Cid, "valid classification", _);
      +accepted(Cid);
      +classified("food", Label, Confidence);
      .println("[AGENT] Candidate ACCEPTED. Belief adopted.").

// ACHIEVEMENT: reject (actions only) - candidate exists
+!rejected_candidate(Cid, Rid)
   :  has_candidate(Cid) & gl.explain(Rid, Trace) & gl.decide(Cid, Admissibility)
   <- gl.reject(Cid, "failed validation", _);
      +rejected(Cid);
      .println("");
      .println("[AGENT] Candidate REJECTED.");
      .println("[AGENT]   reason = ", Trace).

// ACHIEVEMENT: reject (actions only) - no candidate
+!rejected_candidate(Cid, Rid)
   :  no_candidate(Cid) & gl.result(Rid, Outcome)
   <- +rejected("");
      .println("");
      .println("[AGENT] Invocation failed, no candidate.");
      .println("[AGENT]   outcome = ", Outcome).

// ACHIEVEMENT: print trace
+!print_trace(Rid)
   :  gl.explain(Rid, Trace)
   <- .println("");
      .println("[TRACE] ", Trace);
      .println("=== Demo Complete ===").

// RECOVERY
-!classified(FoodItem)
   :  not accepted(_)
   <- .println("[AGENT] Classification FAILED for ", FoodItem).

-!deliberated(Rid)
   :  not accepted(_)
   <- .println("[AGENT] Deliberation FAILED for ", Rid).
