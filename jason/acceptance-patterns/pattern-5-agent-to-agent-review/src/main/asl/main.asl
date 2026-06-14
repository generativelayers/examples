// Pipeline: start > !banner > !setup > !classified > !reviewed > !submit_for_review > .wait(reviewed) > +review_approved | +review_rejected
/**
 * Pattern 5: Agent-to-Agent Review - Jason (Main agent)
 *
 * Generates LLM output, sends the label to a peer reviewer
 * agent via messaging. Accepts/rejects based on reviewer's verdict.
 */

// Requires: GL ontology beliefs (gl_status, gl_candidate_type, gl_verdict_type, ...)
//   See: https://github.com/generativelayers/examples/tree/main/jason/shared

// DOMAIN MODEL
reviewed(Cid) :- peer_approved(Cid).
reviewed(Cid) :- peer_rejected(Cid).
has_candidate(Cid) :- Cid \== "".
no_candidate(Cid)  :- Cid == "".

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !banner;
      !setup;
      !classified("tomato");
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
   :  gl.see(Providers)
   <- .println("=== Pattern 5: Agent-to-Agent Review ===");
      .println("");
      .println("[Layer] Available providers: ", Providers).

// DECOMPOSITION: classify = call + review
+!classified(Item)
   :  binding(Bid)
   <- .concat("Classify: ", Item, ". Return only a label field.", Prompt);
      gl.call(Bid, "classify", "llm.answer", "ANSWER", Prompt, "label", "", Rid);
      !reviewed(Rid).

// SERENDIPITY: already reviewed
+!reviewed(Rid)
   :  gl.candidate(Rid, Cid) & reviewed(Cid)
   <- .println("[Runner] Already reviewed: ", Rid).

// DECOMPOSITION: admissible > send to reviewer and wait
+!reviewed(Rid)
   :  gl.candidate(Rid, Cid) & gl.decide(Cid, "ADMISSIBLE") & gl.get(Cid, "label", Label)
   <- !submit_for_review(Rid, Cid, Label);
      .wait(reviewed(Cid), 30000).

// DECOMPOSITION: not admissible > reject
+!reviewed(Rid)
   :  gl.candidate(Rid, Cid)
   <- !rejected_candidate(Cid, Rid).

// ACHIEVEMENT: send request to reviewer
+!submit_for_review(Rid, Cid, Label)
   <- .println("[Runner] Sending '", Label, "' to reviewer...");
      .send(reviewer, achieve, review_request(Label, Cid)).

// ACHIEVEMENT: reject primary (candidate exists)
+!rejected_candidate(Cid, Rid)
   :  has_candidate(Cid)
   <- gl.reject(Cid, "failed validation", _);
      +peer_rejected(Cid);
      .println("Invalid output - REJECTED");
      !print_trace(Rid).

// ACHIEVEMENT: reject primary (no candidate)
+!rejected_candidate(Cid, Rid)
   :  no_candidate(Cid)
   <- +peer_rejected("");
      .println("Invocation failed - REJECTED");
      !print_trace(Rid).

// REACTIVE: peer approved
+review_approved(Cid)[source(Sender)]
   <- +peer_approved(Cid);
      gl.accept(Cid, "peer approved", _);
      .println("[Runner] Peer approved - ACCEPTED");
      .println("");
      gl.explain(Cid, Trace);
      .println("[TRACE] ", Trace);
      .println("=== Demo Complete ===").

// REACTIVE: peer rejected
+review_rejected(Cid, Reason)[source(Sender)]
   <- +peer_rejected(Cid);
      gl.reject(Cid, Reason, _);
      .println("[Runner] Peer rejected: ", Reason, " - REJECTED");
      .println("");
      gl.explain(Cid, Trace);
      .println("[TRACE] ", Trace);
      .println("=== Demo Complete ===").

// ACHIEVEMENT: print trace
+!print_trace(Rid)
   :  gl.explain(Rid, Trace)
   <- .println("");
      .println("[TRACE] ", Trace).

// RECOVERY - candidate exists
-!reviewed(Rid)
   :  gl.candidate(Rid, Cid) & has_candidate(Cid)
   <- .println("[Runner] Review TIMED OUT or FAILED > REJECTED");
      gl.reject(Cid, "review timed out/failed", _);
      +peer_rejected(Cid);
      !print_trace(Rid).

// RECOVERY - no candidate
-!reviewed(Rid)
   <- .println("[Runner] Review FAILED for ", Rid).
