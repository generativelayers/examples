/**
 * Pattern 4: Cross-LLM Verification — JaCaMo
 *
 * Asks a second LLM to verify the first LLM's output.
 * Accepts only if both providers return valid results.
 */

!start.

+!start
   <- .println("=== Pattern 4: Cross-LLM Verification ===");
      makeArtifact("gl", "gl.adapter.jacamo.JaCaMoAdapter", [], GlId);
      focus(GlId);
      // configure("model", "gemini-2.0-flash");
      // use_provider("gemini");
      configure("model", "llama-3.3-70b-versatile");
      use_provider("groq");
      ask("agent1", "classify", "Classify: apple", Rid);
      valid(Rid, IsValid);
      !verify(Rid, IsValid).

+!verify(Rid, true)
   <- field(Rid, "label", Label);
      candidate(Rid, Cid);
      ask("agent1", "verify", "Is this correct? apple = ", Vrid);
      valid(Vrid, VIsValid);
      !compare(Cid, Vrid, VIsValid).

+!verify(Rid, false)
   <- .println("First provider invalid -> SKIPPED");
      .stopMAS.

+!compare(Cid, Vrid, true)
   <- accept(Cid);
      .println("Both providers agreed -> ACCEPTED");
      .stopMAS.

+!compare(Cid, Vrid, false)
   <- reject(Cid);
      .println("Second provider invalid -> REJECTED");
      .stopMAS.
