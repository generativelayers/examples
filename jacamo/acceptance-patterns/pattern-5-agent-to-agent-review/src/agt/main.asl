// Pipeline: start > !banner > !setup > !classified > !reviewed > !submit_for_review > .wait(reviewed) > +review_approved | +review_rejected
/**
 * Pattern 5: Agent-to-Agent Review - JaCaMo (Main agent)
 *
 * Generates LLM output, sends the label to a peer reviewer
 * agent via messaging. Accepts/rejects based on reviewer's verdict.
 */

// DOMAIN MODEL
reviewed(Cid) :- peer_approved(Cid).
reviewed(Cid) :- peer_rejected(Cid).
has_candidate(Cid) :- Cid \== "".
no_candidate(Cid)  :- Cid == "".

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !artifact_ready;
      !banner;
      !setup;
      !classified("tomato");
      .stopMAS.

// ACHIEVEMENT: create and focus the GL artifact
+!artifact_ready
   <- makeArtifact("gl", "gl.jacamo.GL", [], GlId);
      focus(GlId).

// ACHIEVEMENT: display banner
+!banner
   <- see(Providers);
      .println("=== Pattern 5: Agent-to-Agent Review ===");
      .println("").

// ACHIEVEMENT: setup
+!setup
   <- bind("agent1", "groq", "llama-3.3-70b-versatile", "", Bid);
      +binding(Bid).

// DECOMPOSITION: classify = call + review
+!classified(Item)
   :  binding(Bid)
   <- .concat("Classify: ", Item, ". Return only a label field.", Prompt);
      call(Bid, "classify", "llm.answer", "ANSWER", Prompt, "label", "", Rid);
      !reviewed(Rid).

// SERENDIPITY: already reviewed
+!reviewed(Rid)
   :  accepted(Cid) & candidate(Rid, Cid)
   <- .println("[Runner] Already reviewed: ", Rid).

// DECOMPOSITION: handle deliberation
+!reviewed(Rid)
   <- candidate(Rid, Cid);
      !reviewed_candidate(Rid, Cid).

+!reviewed_candidate(Rid, Cid)
   :  has_candidate(Cid)
   <- decide(Cid, Admissibility);
      !reviewed_decision(Rid, Cid, Admissibility).

+!reviewed_candidate(Rid, Cid)
   :  no_candidate(Cid)
   <- result(Rid, Outcome);
      !reviewed_decision(Rid, Cid, Outcome).

// DECOMPOSITION: route decision
+!reviewed_decision(Rid, Cid, "ADMISSIBLE")
   <- get(Cid, "label", Label);
      !submit_for_review(Rid, Cid, Label);
      .wait(reviewed(Cid), 30000).

+!reviewed_decision(Rid, Cid, Outcome)
   <- !rejected_candidate(Cid, Rid, Outcome).

// ACHIEVEMENT: send request to reviewer
+!submit_for_review(Rid, Cid, Label)
   <- .println("[Runner] Sending '", Label, "' to reviewer...");
      .send(reviewer, achieve, review_request(Label, Cid)).

// ACHIEVEMENT: reject primary (candidate exists)
+!rejected_candidate(Cid, Rid, Outcome)
   :  has_candidate(Cid)
   <- reject(Cid, "failed validation", _);
      +peer_rejected(Cid);
      .println("Invalid output - REJECTED");
      !print_trace(Rid).

// ACHIEVEMENT: reject primary (no candidate)
+!rejected_candidate(Cid, Rid, Outcome)
   :  no_candidate(Cid)
   <- +peer_rejected("");
      .println("Invocation failed - REJECTED");
      !print_trace(Rid).

// REACTIVE: peer approved
+review_approved(Cid)[source(Sender)]
   <- +peer_approved(Cid);
      accept(Cid, "peer approved", _);
      .println("[Runner] Peer approved - ACCEPTED");
      .println("");
      explain(Cid, Trace);
      .println("[TRACE] ", Trace);
      .println("=== Demo Complete ===").

// REACTIVE: peer rejected
+review_rejected(Cid, Reason)[source(Sender)]
   <- +peer_rejected(Cid);
      reject(Cid, Reason, _);
      .println("[Runner] Peer rejected: ", Reason, " - REJECTED");
      .println("");
      explain(Cid, Trace);
      .println("[TRACE] ", Trace);
      .println("=== Demo Complete ===").

// ACHIEVEMENT: print trace
+!print_trace(Rid)
   <- explain(Rid, Trace);
      .println("");
      .println("[TRACE] ", Trace).

// RECOVERY - candidate exists (timed out or failed)
-!reviewed(Rid)
   :  candidate(Rid, Cid) & has_candidate(Cid)
   <- .println("[Runner] Review TIMED OUT or FAILED > REJECTED");
      reject(Cid, "review timed out/failed", _);
      +peer_rejected(Cid);
      !print_trace(Rid).

// RECOVERY - no candidate
-!reviewed(Rid)
   <- .println("[Runner] Review FAILED for ", Rid).
