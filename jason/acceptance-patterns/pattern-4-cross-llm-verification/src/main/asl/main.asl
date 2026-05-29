/**
 * Pattern 4: Cross-LLM Verification — Jason
 *
 * Asks a second LLM to verify the first LLM's output.
 * Accepts only if both providers return valid results.
 */

!start.

+!start
   <- .println("=== Pattern 4: Cross-LLM Verification ===");
      gl.use_provider;
      gl.ask("agent1", "classify", "Classify: apple", Rid);
      !verify(Rid).

+!verify(Rid)
   :  gl.valid(Rid, true)
   <- gl.field(Rid, "label", Label);
      gl.candidate(Rid, Cid);
      gl.ask("agent1", "verify", "Is this correct? apple = ", Vrid);
      !compare(Cid, Vrid).

+!compare(Cid, Vrid)
   :  gl.valid(Vrid, true)
   <- gl.accept(Cid);
      .println("Both providers agreed -> ACCEPTED");
      .stopMAS.

+!compare(Cid, Vrid)
   :  gl.valid(Vrid, false)
   <- gl.reject(Cid);
      .println("Second provider invalid -> REJECTED");
      .stopMAS.
