// Pipeline: start > !banner > !setup > !classified > !inspected > !known_category
/**
 * Pattern 2: Content Inspection - JaCaMo
 *
 * After validation, inspects the LLM output against the agent's
 * own knowledge base. Accepts only if the label is a known category.
 */

known("fruit"). known("vegetable"). known("grain").

// DOMAIN MODEL
inspected(Cid) :- accepted(Cid).
inspected(Cid) :- rejected(Cid).
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
      .println("=== Pattern 2: Content Inspection ===");
      .println("").

// ACHIEVEMENT: setup
+!setup
   <- bind("agent1", "groq", "llama-3.3-70b-versatile", "", Bid);
      +binding(Bid).

// DECOMPOSITION: classify = call + inspect
+!classified(Item)
   :  binding(Bid)
   <- .concat("Classify: ", Item, ". Return label and confidence.", Prompt);
      .concat("category(", Item, ", fruit)", Context);
      call(Bid, "classify", "llm.answer", "ANSWER", Prompt, "label,confidence", Context, Rid);
      !inspected(Rid).

// SERENDIPITY: already inspected
+!inspected(Rid)
   :  accepted(Cid) & candidate(Rid, Cid)
   <- .println("Already inspected: ", Rid).

// DECOMPOSITION: handle deliberation
+!inspected(Rid)
   <- candidate(Rid, Cid);
      !inspected_candidate(Rid, Cid).

+!inspected_candidate(Rid, Cid)
   :  has_candidate(Cid)
   <- decide(Cid, Admissibility);
      !inspected_decision(Rid, Cid, Admissibility).

+!inspected_candidate(Rid, Cid)
   :  no_candidate(Cid)
   <- result(Rid, Outcome);
      !inspected_decision(Rid, Cid, Outcome).

// DECOMPOSITION: route decision
+!inspected_decision(Rid, Cid, "ADMISSIBLE")
   <- get(Cid, "label", Label);
      !known_category(Rid, Cid, Label).

+!inspected_decision(Rid, Cid, Outcome)
   <- !rejected_candidate(Cid, Rid, Outcome);
      !print_trace(Rid).

// ACHIEVEMENT: known category > accept
+!known_category(Rid, Cid, Label)
   :  known(Label)
   <- get(Cid, "confidence", Confidence);
      .concat("known category: ", Label, Reason);
      accept(Cid, Reason, _);
      +accepted(Cid);
      .println("Known category '", Label, "' - ACCEPTED");
      .println("  confidence = ", Confidence);
      .println("");
      !print_trace(Rid).

// ACHIEVEMENT: unknown category > reject
+!known_category(Rid, Cid, Label)
   :  not known(Label)
   <- .concat("unknown category: ", Label, Reason);
      reject(Cid, Reason, _);
      +rejected(Cid);
      .println("Unknown category '", Label, "' - REJECTED");
      .println("");
      !print_trace(Rid).

// ACHIEVEMENT: reject (actions only) - candidate exists
+!rejected_candidate(Cid, Rid, Outcome)
   :  has_candidate(Cid)
   <- reject(Cid, "output not admissible", _);
      +rejected(Cid);
      .println("Invalid output - REJECTED").

// ACHIEVEMENT: reject (actions only) - no candidate
+!rejected_candidate(Cid, Rid, Outcome)
   :  no_candidate(Cid)
   <- +rejected("");
      .println("Invocation failed, no candidate - REJECTED (outcome = ", Outcome, ")").

// ACHIEVEMENT: print trace
+!print_trace(Rid)
   <- explain(Rid, Trace);
      .println("");
      .println("[TRACE] ", Trace);
      .println("=== Demo Complete ===").

// RECOVERY
-!inspected(Rid)
   :  not accepted(_) & not rejected(_)
   <- .println("Inspection FAILED for ", Rid).
