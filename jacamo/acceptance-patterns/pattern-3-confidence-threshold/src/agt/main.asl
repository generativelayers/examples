// Pipeline: start > !banner > !setup > !classified > !assessed > !assess_confidence | !rejected_candidate
/**
 * Pattern 3: Confidence Tier - JaCaMo
 *
 * Use a categorical confidence tier: high accepts, low rejects,
 * and medium/unknown escalates.
 */

// DOMAIN MODEL
assessed(Cid) :- accepted(Cid).
assessed(Cid) :- rejected(Cid).
assessed(Cid) :- escalated(Cid).
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
      .println("=== Pattern 3: Confidence Tier ===");
      .println("").

// ACHIEVEMENT: setup
+!setup
   <- bind("agent1", "groq", "llama-3.3-70b-versatile", "", Bid);
      +binding(Bid).

// DECOMPOSITION: classify = call + deliberate/assess
+!classified(Item)
   :  binding(Bid)
   <- .concat("Classify: ", Item, ". Return label and confidence_tier: high, medium, or low.", Prompt);
      call(Bid, "classify", "llm.answer", "ANSWER", Prompt, "label,confidence_tier", "", Rid);
      !assessed(Rid).

// SERENDIPITY: already assessed
+!assessed(Rid)
   :  accepted(Cid) & candidate(Rid, Cid)
   <- .println("Already assessed: ", Rid).

// DECOMPOSITION: handle deliberation
+!assessed(Rid)
   <- candidate(Rid, Cid);
      !assessed_candidate(Rid, Cid).

+!assessed_candidate(Rid, Cid)
   :  has_candidate(Cid)
   <- decide(Cid, Admissibility);
      !assessed_decision(Rid, Cid, Admissibility).

+!assessed_candidate(Rid, Cid)
   :  no_candidate(Cid)
   <- result(Rid, Outcome);
      !assessed_decision(Rid, Cid, Outcome).

// DECOMPOSITION: route decision
+!assessed_decision(Rid, Cid, "ADMISSIBLE")
   <- get(Cid, "confidence_tier", Tier);
      !assess_confidence(Rid, Cid, Tier);
      !print_trace(Rid).

+!assessed_decision(Rid, Cid, Outcome)
   <- !rejected_candidate(Cid, Rid, Outcome);
      !print_trace(Rid).

// ACHIEVEMENT: high confidence > accept
+!assess_confidence(Rid, Cid, "high")
   <- get(Cid, "label", Label);
      accept(Cid, "high confidence", _);
      +accepted(Cid);
      +confidence_tier(Cid, "high");
      .println("High confidence - ACCEPTED");
      .println("  label = ", Label).

// ACHIEVEMENT: low confidence > reject
+!assess_confidence(Rid, Cid, "low")
   <- reject(Cid, "low confidence", _);
      +rejected(Cid);
      +confidence_tier(Cid, "low");
      .println("Low confidence - REJECTED").

// ACHIEVEMENT: medium/other > escalate
+!assess_confidence(Rid, Cid, Tier)
   <- +escalated(Cid);
      +confidence_tier(Cid, Tier);
      .println("Confidence tier '", Tier, "' - ESCALATING").

// ACHIEVEMENT: reject (actions only) - candidate exists
+!rejected_candidate(Cid, Rid, Outcome)
   :  has_candidate(Cid)
   <- reject(Cid, "failed validation", _);
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
      .println("[TRACE] ", Trace).

// RECOVERY
-!assessed(Rid)
   :  not accepted(_) & not rejected(_) & not escalated(_)
   <- .println("Assessment FAILED for ", Rid).
