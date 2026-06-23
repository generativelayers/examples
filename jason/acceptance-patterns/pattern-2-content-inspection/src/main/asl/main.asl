// Pipeline: start > !banner > !setup > !classified > !inspected > !known_category
/**
 * Pattern 2: Content Inspection - Jason
 *
 * After validation, inspects the LLM output against the agent's
 * own knowledge base. Records acceptance only if the label is a known category.
 */

// Requires: GL ontology beliefs (gl_status, gl_candidate_type, gl_verdict_type, ...)
//   See: https://github.com/generativelayers/examples/tree/main/jason/shared

known("fruit"). known("vegetable"). known("grain").

// DOMAIN MODEL
inspected(Cid) :- accepted(Cid).
inspected(Cid) :- rejected(Cid).
has_candidate(Cid) :- Cid \== "".
no_candidate(Cid)  :- Cid == "".

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !banner;
      !setup;
      !classified("apple");
      !shutdown.

// ACHIEVEMENT: setup binding
+!setup
   <- gl.bind("agent1", "groq", "llama-3.3-70b-versatile", "", Bid);
      +binding(Bid);
      ?binding(Bid).

// ACHIEVEMENT: clean exit
+!shutdown
   <- .stopMAS.

// ACHIEVEMENT: display banner
+!banner
   <- .println("=== Pattern 2: Content Inspection ===");
      .println("").

// DECOMPOSITION: classify = call + inspect
+!classified(Item)
   :  binding(Bid)
   <- .concat("Classify: ", Item, ". Return label and confidence.", Prompt);
      .concat("category(", Item, ", fruit)", Context);
      gl.call(Bid, "classify", "llm.answer", "ANSWER", Prompt, "label,confidence", Context, Rid);
      !inspected(Rid).

// SERENDIPITY: already inspected
+!inspected(Rid)
   :  gl.candidate(Rid, Cid) & inspected(Cid)
   <- .println("Already inspected: ", Rid).

// DECOMPOSITION: admissible > check content against knowledge base
+!inspected(Rid)
   :  gl.candidate(Rid, Cid) & gl.decide(Cid, "ADMISSIBLE") & gl.get(Cid, "label", Label)
   <- !known_category(Rid, Cid, Label).

// DECOMPOSITION: not admissible > reject
+!inspected(Rid)
   :  gl.candidate(Rid, Cid)
   <- !rejected_candidate(Cid, Rid);
      !print_trace(Rid).

// ACHIEVEMENT: known category > accept
+!known_category(Rid, Cid, Label)
   :  known(Label) & gl.get(Cid, "confidence", Confidence)
   <- .concat("known category: ", Label, Reason);
      gl.accept(Cid, Reason, _);
      +accepted(Cid);
      .println("Known category '", Label, "' - ACCEPTED");
      .println("  confidence = ", Confidence);
      .println("");
      !print_trace(Rid).

// ACHIEVEMENT: unknown category > reject
+!known_category(Rid, Cid, Label)
   :  not known(Label)
   <- .concat("unknown category: ", Label, Reason);
      gl.reject(Cid, Reason, _);
      +rejected(Cid);
      .println("Unknown category '", Label, "' - REJECTED");
      .println("");
      !print_trace(Rid).

// ACHIEVEMENT: reject (actions only) - candidate exists
+!rejected_candidate(Cid, Rid)
   :  has_candidate(Cid)
   <- gl.reject(Cid, "output not admissible", _);
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
      .println("[TRACE] ", Trace);
      .println("=== Demo Complete ===").

// RECOVERY
-!inspected(Rid)
   :  not accepted(_) & not rejected(_)
   <- .println("Inspection FAILED for ", Rid).