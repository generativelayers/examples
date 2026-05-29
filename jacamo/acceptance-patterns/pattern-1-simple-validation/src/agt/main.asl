/**
 * Pattern 1: Simple Validation — JaCaMo
 *
 * The simplest governance pattern: accept valid output, reject invalid.
 * Demonstrates the fundamental valid/invalid context-guard branching.
 */

!start.

+!start
   <- .println("=== Pattern 1: Simple Validation ===");
      makeArtifact("gl", "gl.adapter.jacamo.JaCaMoAdapter", [], GlId);
      focus(GlId);
      use_provider;
      ask("agent1", "classify", "Classify: apple", Rid);
      valid(Rid, IsValid);
      !decide(Rid, IsValid).

+!decide(Rid, true)
   <- candidate(Rid, Cid);
      accept(Cid);
      field(Rid, "label", Label);
      .println("Valid output -> ACCEPTED: ", Label);
      .stopMAS.

+!decide(Rid, false)
   <- .println("Invalid output -> REJECTED");
      .stopMAS.
