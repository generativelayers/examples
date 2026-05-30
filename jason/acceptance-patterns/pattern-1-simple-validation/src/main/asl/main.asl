/**
 * Pattern 1: Simple Validation — Jason
 *
 * The simplest governance pattern: accept valid output, reject invalid.
 * Demonstrates the fundamental valid/invalid context-guard branching.
 */

!start.

+!start
   <- .println("=== Pattern 1: Simple Validation ===");
      gl.configure("model", "gpt-oss-120b");
      gl.use_provider("cerebras");
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
