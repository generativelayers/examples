/**
 * Pattern 5: Agent-to-Agent Review — JaCaMo (Main agent)
 *
 * Generates LLM output, sends the label to a peer reviewer
 * agent via BDI messaging. Accepts/rejects based on reviewer's verdict.
 */

!start.

+!start
   <- .println("=== Pattern 5: Agent-to-Agent Review ===");
      makeArtifact("gl", "gl.adapter.jacamo.JaCaMoAdapter", [], GlId);
      focus(GlId);
      use_provider;
      ask("agent1", "classify", "Classify: tomato", Rid);
      valid(Rid, IsValid);
      !request_review(Rid, IsValid).

+!request_review(Rid, true)
   <- field(Rid, "label", Label);
      candidate(Rid, Cid);
      +pending(Rid, Cid);
      .println("Sending '", Label, "' to reviewer agent...");
      .send(reviewer, achieve, review(Label, Rid)).

+!request_review(Rid, false)
   <- .println("Invalid output -> SKIPPED");
      .stopMAS.

+approved(Rid)
   :  pending(Rid, Cid)
   <- -pending(Rid, Cid);
      accept(Cid);
      .println("Peer approved -> ACCEPTED");
      .stopMAS.

+disapproved(Rid, Reason)
   :  pending(Rid, Cid)
   <- -pending(Rid, Cid);
      reject(Cid);
      .println("Peer rejected: ", Reason, " -> REJECTED");
      .stopMAS.
