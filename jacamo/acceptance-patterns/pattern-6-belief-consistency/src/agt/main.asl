// Pipeline: start > !banner > !classified > !consistent > !belief_checked | !rejected_candidate
/**
 * Pattern 6: Belief Consistency - JaCaMo
 *
 * Compare the LLM candidate with existing beliefs. Confirm matches,
 * reject contradictions, adopt new facts only when no prior belief exists.
 */

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
   <- !artifact_ready;
      !banner;
      bind("agent1", "groq", "llama-3.3-70b-versatile", "", Bid);
      +binding(Bid);
      !classified("apple");
      !shutdown.

// ACHIEVEMENT: create and focus the GL artifact
+!artifact_ready
   <- makeArtifact("gl", "gl.jacamo.GL", [], GlId);
      focus(GlId).

// ACHIEVEMENT: clean exit
+!shutdown
   <- .stopMAS.

// ACHIEVEMENT: display banner
+!banner
   <- see(Providers);
      .println("=== Pattern 6: Belief Consistency ===");
      .println("");
      .println("[Layer] Available providers: ", Providers).

// DECOMPOSITION: classify = call + deliberate
+!classified(Item)
   :  binding(Bid)
   <- .concat("Classify: ", Item, ". Return only a label field.", Prompt);
      call(Bid, "classify", "llm.answer", "ANSWER", Prompt, "label", "", Rid);
      !consistent(Rid, Item).

// SERENDIPITY: already checked
+!consistent(Rid, Item)
   :  consistent(Cid) & candidate(Rid, Cid)
   <- .println("[AGENT] Already checked: ", Rid).

// DECOMPOSITION: handle deliberation
+!consistent(Rid, Item)
   <- candidate(Rid, Cid);
      !consistent_candidate(Rid, Item, Cid).

+!consistent_candidate(Rid, Item, Cid)
   :  has_candidate(Cid)
   <- decide(Cid, Admissibility);
      !consistent_decision(Rid, Item, Cid, Admissibility).

+!consistent_candidate(Rid, Item, Cid)
   :  no_candidate(Cid)
   <- result(Rid, Outcome);
      !consistent_decision(Rid, Item, Cid, Outcome).

// DECOMPOSITION: route decision
+!consistent_decision(Rid, Item, Cid, "ADMISSIBLE")
   <- get(Cid, "label", Label);
      !belief_checked(Rid, Cid, Item, Label).

+!consistent_decision(Rid, Item, Cid, Outcome)
   <- !rejected_candidate(Cid, Rid, Outcome).

// ACHIEVEMENT: match belief > confirm
+!belief_checked(Rid, Cid, Item, Label)
   :  category(Item, Label)
   <- accept(Cid, "matches existing belief", _);
      +confirmed(Cid);
      .println("Matches belief - CONFIRMED");
      !print_trace(Rid);
      .println("=== Demo Complete ===").

// ACHIEVEMENT: contradicts belief > reject
+!belief_checked(Rid, Cid, Item, Label)
   :  category(Item, Existing) & Existing \== Label
   <- .concat("contradicts belief: ", Existing, Reason);
      reject(Cid, Reason, _);
      +rejected(Cid);
      .println("Contradicts belief - REJECTED (existing=", Existing, ", output=", Label, ")");
      !print_trace(Rid);
      .println("=== Demo Complete ===").

// ACHIEVEMENT: no prior belief > adopt as new knowledge
+!belief_checked(Rid, Cid, Item, Label)
   :  not category(Item, _)
   <- .concat("no prior belief: ", Label, Reason);
      accept(Cid, Reason, _);
      +category(Item, Label);
      +adopted_new(Cid);
      .println("No prior belief - NEW KNOWLEDGE ADOPTED");
      !print_trace(Rid);
      .println("=== Demo Complete ===").

// ACHIEVEMENT: reject (actions only) - candidate exists
+!rejected_candidate(Cid, Rid, Outcome)
   :  has_candidate(Cid)
   <- reject(Cid, "failed validation", _);
      +rejected(Cid);
      .println("Invalid output - REJECTED");
      !print_trace(Rid).

// ACHIEVEMENT: reject (actions only) - no candidate
+!rejected_candidate(Cid, Rid, Outcome)
   :  no_candidate(Cid)
   <- +rejected("");
      .println("Invocation failed - REJECTED (outcome = ", Outcome, ")");
      !print_trace(Rid).

// ACHIEVEMENT: print trace
+!print_trace(Rid)
   <- explain(Rid, Trace);
      .println("");
      .println("[TRACE] ", Trace).

// RECOVERY
-!consistent(Rid, Item)
   :  not confirmed(_) & not rejected(_) & not adopted_new(_)
   <- .println("Consistency check FAILED for ", Rid).
