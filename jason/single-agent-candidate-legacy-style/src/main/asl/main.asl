// Pipeline: start > !banner > !classified > !deliberated > !accepted_candidate | !rejected_candidate > !print_trace
/**
 * Single Agent Candidate (Legacy Style) - Generative Layer demonstration (Jason).
 *
 * Demonstrates the migrated approach to candidate generation, using
 * agent-scoped bindings and v2 commands.
 */

// Requires: GL ontology beliefs (gl_status, gl_candidate_type, gl_verdict_type, ...)
//   See: https://github.com/generativelayers/examples/tree/main/jason/shared

// DOMAIN MODEL
classified(Item, Label, Conf) :- accepted(_) & classified(Item, Label, Conf).
has_candidate(Cid)            :- Cid \== "".
no_candidate(Cid)             :- Cid == "".

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !banner;
      gl.bind("agent_a", "groq", "llama-3.3-70b-versatile", "", Bid);
      +binding(Bid);
      !classified("apple");
      !shutdown.

// ACHIEVEMENT: clean exit (actions only)
+!shutdown
   <- .stopMAS.

// ACHIEVEMENT: display banner
+!banner
   :  gl.see(Providers)
   <- .println("=== Generative Layer Single Agent Candidate Demo (Legacy Style) ===");
      .println("");
      .println("[Layer] Available providers: ", Providers).

// DECOMPOSITION: classify = invoke + deliberate
+!classified(FoodItem)
   :  binding(Bid)
   <- .concat("Classify the food item '", FoodItem,
              "'. What category does it belong to? (e.g. fruit, vegetable, grain, dairy, meat). Return label (the category) and confidence (0 to 1).",
              Prompt);
      gl.call(Bid, "classify_food", "llm.answer", "ANSWER", Prompt, "label,confidence", "", Rid);
      !deliberated(Rid).

// DECOMPOSITION: handle deliberation based on outcome
+!deliberated(Rid)
   :  gl.candidate(Rid, Cid) & gl.decide(Cid, "ADMISSIBLE")
   <- !accepted_candidate(Rid, Cid);
      !print_trace(Rid).

+!deliberated(Rid)
   :  gl.candidate(Rid, Cid)
   <- !rejected_candidate(Cid, Rid);
      !print_trace(Rid).

// ACHIEVEMENT: accept (actions only)
+!accepted_candidate(Rid, Cid)
   :  gl.get(Cid, "label", Label) & gl.get(Cid, "confidence", Confidence)
   <- .println("");
      .println("[AGENT] Candidate is valid and admissible.");
      .println("[AGENT]   label      = ", Label);
      .println("[AGENT]   confidence = ", Confidence);
      gl.accept(Cid, "admissible output", _);
      +accepted(Cid);
      +classified("food", Label, Confidence);
      .println("[AGENT] Candidate ACCEPTED. Belief adopted.").

// ACHIEVEMENT: reject (actions only) - candidate exists
+!rejected_candidate(Cid, Rid)
   :  has_candidate(Cid) & gl.decide(Cid, Outcome)
   <- gl.reject(Cid, "failed validation/deliberation", _);
      +rejected(Cid, Outcome);
      .println("");
      .println("[AGENT] Candidate REJECTED.");
      .println("[AGENT]   outcome = ", Outcome).

// ACHIEVEMENT: reject (actions only) - no candidate
+!rejected_candidate(Cid, Rid)
   :  no_candidate(Cid) & gl.result(Rid, Outcome)
   <- +rejected("", Outcome);
      .println("");
      .println("[AGENT] Invocation failed, no candidate.");
      .println("[AGENT]   outcome = ", Outcome).

// ACHIEVEMENT: print trace (actions only)
+!print_trace(Rid)
   :  gl.explain(Rid, Trace)
   <- .println("");
      .println("[TRACE] traceId = ", Trace);
      .println("=== Demo Complete ===").

// RECOVERY
-!classified(FoodItem)
   :  not accepted(_)
   <- .println("[AGENT] Classification FAILED for ", FoodItem).

-!deliberated(Rid)
   :  not accepted(_)
   <- .println("[AGENT] Deliberation FAILED for ", Rid).
