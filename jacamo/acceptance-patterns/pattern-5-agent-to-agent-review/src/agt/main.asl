// Pipeline: start → !artifact_ready → !configured → !reviewed → send(reviewer) → wait → ?reviewed
/**
 * Pattern 5: Agent-to-Agent Review — JaCaMo (Main agent)
 *
 * Generates LLM output, sends the label to a peer reviewer
 * agent via messaging. Accepts/rejects based on reviewer's verdict.
 */

// setting("model", "gpt-oss-120b"). setting("provider", "cerebras").
setting("model", "gpt-oss-120b"). setting("provider", "cerebras").
review_timeout(30000).

// DOMAIN MODEL
reviewed(Cid) :- peer_approved(Cid).

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !artifact_ready;
      !configured(true);
      ask("agent1", "classify", "Classify: tomato", Rid);
      !reviewed(Rid).

// ACHIEVEMENT: create and focus the GL artifact
+!artifact_ready
   <- makeArtifact("gl", "gl.jacamo.GL", [], GlId);
      focus(GlId).

// ACHIEVEMENT: setup (actions only)
+!configured(true)
   :  setting("model", M) & setting("provider", P)
   <- configure("model", M);
      use_provider(P).

// SERENDIPITY
+!reviewed(Rid)
   :  reviewed(Rid)
   <- .println("[Runner] Already reviewed: ", Rid).

// DECOMPOSITION: bind validity → branch
+!reviewed(Rid)
   <- valid(Rid, IsValid);
      !reviewed_branch(Rid, IsValid).

// ACHIEVEMENT: valid → send to reviewer, wait with timeout
+!reviewed_branch(Rid, true)
   :  review_timeout(Timeout)
   <- field(Rid, "label", Label);
      candidate(Rid, Cid);
      .println("[Runner] Sending '", Label, "' to reviewer...");
      .send(reviewer, achieve, review_request(Label, Cid));
      .wait({+peer_approved(Cid)}, Timeout);
      if (not peer_approved(Cid)) {
          .println("[Runner] Review TIMED OUT → REJECTED");
          reject(Cid);
      };
      ?reviewed(Cid).

// ACHIEVEMENT: invalid
+!reviewed_branch(Rid, false)
   <- .println("[Runner] Invalid output → SKIPPED").

// REACTIVE: peer approved
+review_approved(Cid)
   <- +peer_approved(Cid);
      accept(Cid);
      .println("[Runner] Peer approved → ACCEPTED").

// REACTIVE: peer rejected
+review_rejected(Cid, Reason)
   <- reject(Cid);
      .println("[Runner] Peer rejected: ", Reason, " → REJECTED").

// RECOVERY
-!reviewed(Rid)
   <- .println("[Runner] Review FAILED for ", Rid).
