// Pipeline: start → !configured → !reviewed → send(reviewer) → wait → ?reviewed
/**
 * Pattern 5: Agent-to-Agent Review — Jason (Main agent)
 *
 * Generates LLM output, sends the label to a peer reviewer
 * agent via messaging. Accepts/rejects based on reviewer's verdict.
 */

// Requires: GL ontology beliefs (gl_status, gl_candidate_type, gl_verdict_type, ...)
//   See: https://github.com/generativelayers/examples/tree/main/jason/shared

// setting("model", "gpt-oss-120b"). setting("provider", "cerebras").
setting("model", "gpt-oss-120b"). setting("provider", "cerebras").
review_timeout(30000).

// DOMAIN MODEL
reviewed(Cid) :- peer_approved(Cid).

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !configured(true);
      gl.ask("agent1", "classify", "Classify: tomato", Rid);
      !reviewed(Rid).

// ACHIEVEMENT: setup (actions only)
+!configured(true)
   :  setting("model", M) & setting("provider", P)
   <- gl.configure("model", M);
      gl.use_provider(P).

// SERENDIPITY
+!reviewed(Rid)
   :  reviewed(Rid)
   <- .println("[Runner] Already reviewed: ", Rid).

// ACHIEVEMENT: valid → send to reviewer, wait with timeout
+!reviewed(Rid)
   :  gl.valid(Rid, true) & review_timeout(Timeout)
   <- gl.field(Rid, "label", Label);
      gl.candidate(Rid, Cid);
      .println("[Runner] Sending '", Label, "' to reviewer...");
      .send(reviewer, achieve, review_request(Label, Cid));
      .wait({+peer_approved(Cid)}, Timeout);
      if (not peer_approved(Cid)) {
          .println("[Runner] Review TIMED OUT → REJECTED");
          gl.reject(Cid);
      };
      ?reviewed(Cid).

// ACHIEVEMENT: invalid
+!reviewed(Rid)
   <- .println("[Runner] Invalid output → SKIPPED").

// REACTIVE: peer approved
+review_approved(Cid)
   <- +peer_approved(Cid);
      gl.accept(Cid);
      .println("[Runner] Peer approved → ACCEPTED").

// REACTIVE: peer rejected
+review_rejected(Cid, Reason)
   <- gl.reject(Cid);
      .println("[Runner] Peer rejected: ", Reason, " → REJECTED").

// RECOVERY
-!reviewed(Rid)
   <- .println("[Runner] Review FAILED for ", Rid).
