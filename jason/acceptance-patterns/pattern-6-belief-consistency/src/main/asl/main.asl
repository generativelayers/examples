// Pipeline: start > !banner > !classified > !consistent > !belief_checked | !rejected_candidate
/**
 * Pattern 6: Belief Consistency - Jason
 *
 * Compare the LLM candidate with existing beliefs. Confirm matches,
 * reject contradictions, adopt new facts only when no prior belief exists.
 */

// Requires: GL ontology beliefs (gl_status, gl_candidate_type, gl_verdict_type, ...)
//   See: https://github.com/generativelayers/examples/tree/main/jason/shared

category("apple", "fruit"). category("carrot", "vegetable").

// DOMAIN MODEL
consistent(Cid) :- confirmed(Cid).
consistent(Cid) :- rejected(Cid).
consistent(Cid) :- adopted_new(Cid).
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
   <- .println("=== Pattern 6: Belief Consistency ===");
      .println("");
      .println("[Layer] Available providers: ", Providers).

// DECOMPOSITION: classify = call + deliberate
+!classified(Item)
   :  binding(Bid)
   <- .concat("Classify: ", Item, ". Return only a label field.", Prompt);
      gl.call(Bid, "classify", "llm.answer", "ANSWER", Prompt, "label", "", Rid);
      !consistent(Rid, Item).

// SERENDIPITY: already checked
+!consistent(Rid, Item)
   :  gl.candidate(Rid, Cid) & consistent(Cid)
   <- .println("[AGENT] Already checked: ", Rid).

// DECOMPOSITION: admissible > check belief consistency
+!consistent(Rid, Item)
   :  gl.candidate(Rid, Cid) & gl.decide(Cid, "ADMISSIBLE") & gl.get(Cid, "label", Label)
   <- !belief_checked(Rid, Cid, Item, Label).

// DECOMPOSITION: not admissible > reject
+!consistent(Rid, Item)
   :  gl.candidate(Rid, Cid)
   <- !rejected_candidate(Cid, Rid).

// ACHIEVEMENT: match belief > confirm
+!belief_checked(Rid, Cid, Item, Label)
   :  category(Item, Label)
   <- gl.accept(Cid, "matches existing belief", _);
      +confirmed(Cid);
      .println("Matches belief - CONFIRMED");
      !print_trace(Rid);
      .println("=== Demo Complete ===").

// ACHIEVEMENT: contradicts belief > reject
+!belief_checked(Rid, Cid, Item, Label)
   :  category(Item, Existing) & Existing \== Label
   <- .concat("contradicts belief: ", Existing, Reason);
      gl.reject(Cid, Reason, _);
      +rejected(Cid);
      .println("Contradicts belief - REJECTED (existing=", Existing, ", output=", Label, ")");
      !print_trace(Rid);
      .println("=== Demo Complete ===").

// ACHIEVEMENT: no prior belief > adopt as new knowledge
+!belief_checked(Rid, Cid, Item, Label)
   :  not category(Item, _)
   <- .concat("no prior belief: ", Label, Reason);
      gl.accept(Cid, Reason, _);
      +category(Item, Label);
      +adopted_new(Cid);
      .println("No prior belief - NEW KNOWLEDGE ADOPTED");
      !print_trace(Rid);
      .println("=== Demo Complete ===").

// ACHIEVEMENT: reject (actions only) - candidate exists
+!rejected_candidate(Cid, Rid)
   :  has_candidate(Cid)
   <- gl.reject(Cid, "failed validation", _);
      +rejected(Cid);
      .println("Invalid output - REJECTED");
      !print_trace(Rid).

// ACHIEVEMENT: reject (actions only) - no candidate
+!rejected_candidate(Cid, Rid)
   :  no_candidate(Cid) & gl.result(Rid, Outcome)
   <- +rejected("");
      .println("Invocation failed - REJECTED (outcome = ", Outcome, ")");
      !print_trace(Rid).

// ACHIEVEMENT: print trace
+!print_trace(Rid)
   :  gl.explain(Rid, Trace)
   <- .println("");
      .println("[TRACE] ", Trace).

// RECOVERY
-!consistent(Rid, Item)
   :  not confirmed(_) & not rejected(_) & not adopted_new(_)
   <- .println("Consistency check FAILED for ", Rid).
