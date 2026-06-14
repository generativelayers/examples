// Pipeline: start > !artifact_ready > !banner > !setup > !classified > !deliberated > !accepted_candidate | !rejected_candidate > !print_trace
/**
 * Single Agent Candidate - Generative Layer demonstration (JaCaMo).
 *
 * Shows the fundamental Generative Layer flow using CArtAgO artifacts:
 *   artifact_ready > setup > classify > deliberate > accept/reject > trace
 */

// DOMAIN MODEL
classified(Item, Label, Conf) :- accepted(_) & classified(Item, Label, Conf).
has_candidate(Cid)            :- Cid \== "".
no_candidate(Cid)             :- Cid == "".

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !artifact_ready;
      !banner;
      !setup;
      !classified("apple");
      .stopMAS.

// ACHIEVEMENT: create and focus the GL artifact
+!artifact_ready
   <- makeArtifact("gl", "gl.jacamo.GL", [], GlId);
      focus(GlId).

// ACHIEVEMENT: display banner (actions only)
+!banner
   <- see(Providers);
      .println("=== Generative Layer Single Agent Candidate Demo (JaCaMo) ===");
      .println("");
      .println("[Layer] Available providers: ", Providers).

// ACHIEVEMENT: setup (actions only)
+!setup
   <- bind("agent_a", "groq", "llama-3.3-70b-versatile", "", Bid);
      +binding(Bid).

// DECOMPOSITION: classify = call + deliberate
+!classified(FoodItem)
   :  binding(Bid)
   <- .concat("Classify the food item '", FoodItem,
              "'. What category does it belong to? (e.g. fruit, vegetable, grain, dairy, meat). Return label (the category) and confidence (0 to 1).",
              Prompt);
      call(Bid, "classify_food", "llm.answer", "ANSWER", Prompt, "label,confidence", "", Rid);
      !deliberated(Rid).

// DECOMPOSITION: handle deliberation based on outcome
+!deliberated(Rid)
   <- candidate(Rid, Cid);
      !deliberated_candidate(Rid, Cid).

+!deliberated_candidate(Rid, Cid)
   :  has_candidate(Cid)
   <- decide(Cid, Admissibility);
      !deliberated_decision(Rid, Cid, Admissibility).

+!deliberated_candidate(Rid, Cid)
   :  no_candidate(Cid)
   <- result(Rid, Outcome);
      !deliberated_decision(Rid, Cid, Outcome).

// DECOMPOSITION: route decision
+!deliberated_decision(Rid, Cid, "ADMISSIBLE")
   <- !accepted_candidate(Rid, Cid);
      !print_trace(Rid).

+!deliberated_decision(Rid, Cid, Outcome)
   <- !rejected_candidate(Cid, Rid, Outcome);
      !print_trace(Rid).

// ACHIEVEMENT: accept (actions only)
+!accepted_candidate(Rid, Cid)
   <- get(Cid, "label", Label);
      get(Cid, "confidence", Confidence);
      .println("");
      .println("[AGENT] Candidate is valid and admissible.");
      .println("[AGENT]   label      = ", Label);
      .println("[AGENT]   confidence = ", Confidence);
      accept(Cid, "admissible output", _);
      +accepted(Cid);
      +classified("food", Label, Confidence);
      .println("[AGENT] Candidate ACCEPTED. Belief adopted.").

// ACHIEVEMENT: reject (actions only) - candidate exists
+!rejected_candidate(Cid, Rid, Outcome)
   :  has_candidate(Cid)
   <- reject(Cid, "failed validation/deliberation", _);
      +rejected(Cid, Outcome);
      .println("");
      .println("[AGENT] Candidate REJECTED.");
      .println("[AGENT]   outcome = ", Outcome).

// ACHIEVEMENT: reject (actions only) - no candidate
+!rejected_candidate(Cid, Rid, Outcome)
   :  no_candidate(Cid)
   <- +rejected("", Outcome);
      .println("");
      .println("[AGENT] Invocation failed, no candidate.");
      .println("[AGENT]   outcome = ", Outcome).

// ACHIEVEMENT: print trace (actions only)
+!print_trace(Rid)
   <- explain(Rid, Trace);
      .println("");
      .println("[TRACE] traceId = ", Trace);
      .println("=== Demo Complete ===").

// RECOVERY
-!classified(FoodItem)
   :  not accepted(_)
   <- .println("[AGENT] Classification FAILED for ", FoodItem).

-!deliberated(Rid)
   :  not accepted(_)
   <- .println("[AGENT] Deliberation FAILED for ", Rid).
