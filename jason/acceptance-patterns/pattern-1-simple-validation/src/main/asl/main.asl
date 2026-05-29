/**
 * Pattern 1: Simple Validation — Jason
 *
 * The simplest governance pattern: accept valid output, reject invalid.
 * Demonstrates the fundamental valid/invalid context-guard branching.
 */

!start.

+!start
   <- .println("=== Pattern 1: Simple Validation ===");
      // gl.configure("model", "gemini-2.0-flash");
      // gl.use_provider("gemini");
      gl.configure("model", "llama-3.3-70b-versatile");
      gl.use_provider("groq");
      gl.ask("agent1", "classify", "Classify: apple", Rid);
      !decide(Rid).

+!decide(Rid)
   :  gl.valid(Rid, true)
   <- gl.candidate(Rid, Cid);
      gl.accept(Cid);
      gl.field(Rid, "label", Label);
      .println("Valid output -> ACCEPTED: ", Label);
      .stopMAS.

+!decide(Rid)
   :  gl.valid(Rid, false)
   <- .println("Invalid output -> REJECTED");
      .stopMAS.
