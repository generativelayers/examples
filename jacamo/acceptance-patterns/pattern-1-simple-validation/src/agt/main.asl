// Pipeline: start > !artifact_ready > !banner > !setup > !classified > !deliberated > !accepted_candidate | !rejected_candidate > !print_trace
/**
 * Pattern 1: Simple Validation - JaCaMo
 *
 * The simplest governance pattern: accept valid output, reject invalid.
 * Demonstrates the fundamental decide() context-guard branching.
 */

// DOMAIN MODEL
validated(Cid) :- accepted(Cid).
validated(Cid) :- rejected(Cid).
has_candidate(Cid) :- Cid \== "".
no_candidate(Cid)  :- Cid == "".

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

// ACHIEVEMENT: display banner
+!banner
   <- see(Providers);
      .println("=== Pattern 1: Simple Validation ===");
      .println("");
      .println("[Layer] Available providers: ", Providers).

// ACHIEVEMENT: setup (actions only)
+!setup
   <- bind("agent1", "groq", "llama-3.3-70b-versatile", "", Bid);
      +binding(Bid).

// DECOMPOSITION: classify = call + deliberate
+!classified(FoodItem)
   :  binding(Bid)
   <- .concat("Classify the food item '", FoodItem, "'. Return label and confidence.", Prompt);
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
      .println("[AGENT] Candidate is ADMISSIBLE.");
      .println("[AGENT]   label      = ", Label);
      .println("[AGENT]   confidence = ", Confidence);
      accept(Cid, "valid classification", _);
      +accepted(Cid);
      +classified("food", Label, Confidence);
      .println("[AGENT] Candidate ACCEPTED. Belief adopted.").

// ACHIEVEMENT: reject (actions only) - candidate exists
+!rejected_candidate(Cid, Rid, Outcome)
   :  has_candidate(Cid)
   <- reject(Cid, "failed validation", _);
      +rejected(Cid);
      explain(Rid, Trace);
      .println("");
      .println("[AGENT] Candidate REJECTED.");
      .println("[AGENT]   reason = ", Trace).

// ACHIEVEMENT: reject (actions only) - no candidate
+!rejected_candidate(Cid, Rid, Outcome)
   :  no_candidate(Cid)
   <- +rejected("");
      .println("");
      .println("[AGENT] Invocation failed, no candidate.");
      .println("[AGENT]   outcome = ", Outcome).

// ACHIEVEMENT: print trace
+!print_trace(Rid)
   <- explain(Rid, Trace);
      .println("");
      .println("[TRACE] ", Trace);
      .println("=== Demo Complete ===").

// RECOVERY
-!classified(FoodItem)
   :  not accepted(_)
   <- .println("[AGENT] Classification FAILED for ", FoodItem).

-!deliberated(Rid)
   :  not accepted(_)
   <- .println("[AGENT] Deliberation FAILED for ", Rid).
