/**
 * Pattern 5: Agent-to-Agent Review — Jason (Main agent)
 *
 * Generates LLM output, sends the label to a peer reviewer
 * agent via BDI messaging. Accepts/rejects based on reviewer's verdict.
 */

!start.

+!start
   <- .println("=== Pattern 5: Agent-to-Agent Review ===");
      gl.configure("model", "gpt-oss-120b");
      gl.use_provider("cerebras");
      gl.ask("agent1", "classify", "Classify: tomato", Rid);
      !request_review(Rid).

+!request_review(Rid)
   :  gl.valid(Rid, true)
   <- gl.field(Rid, "label", Label);
      gl.candidate(Rid, Cid);
      +pending(Rid, Cid);
      .println("Sending '", Label, "' to reviewer agent...");
      .send(reviewer, achieve, review(Label, Rid)).

+!request_review(Rid)
   :  gl.valid(Rid, false)
   <- .println("Invalid output -> SKIPPED");
      .stopMAS.

+approved(Rid)
   :  pending(Rid, Cid)
   <- -pending(Rid, Cid);
      gl.accept(Cid);
      .println("Peer approved -> ACCEPTED");
      .stopMAS.

+disapproved(Rid, Reason)
   :  pending(Rid, Cid)
   <- -pending(Rid, Cid);
      gl.reject(Cid);
      .println("Peer rejected: ", Reason, " -> REJECTED");
      .stopMAS.
