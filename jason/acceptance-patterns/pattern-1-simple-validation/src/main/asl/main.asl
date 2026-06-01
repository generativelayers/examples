// Pipeline: start → !configured → !validated → ?validated
/**
 * Pattern 1: Simple Validation — Jason
 *
 * The simplest governance pattern: accept valid output, reject invalid.
 * Demonstrates the fundamental valid/invalid context-guard branching.
 */

// Requires: GL ontology beliefs (gl_status, gl_candidate_type, gl_verdict_type, ...)
//   See: https://github.com/generativelayers/examples/tree/main/jason/shared

// setting("model", "gpt-oss-120b"). setting("provider", "cerebras").
setting("model", "gemini-2.5-flash"). setting("provider", "gemini").

// DOMAIN MODEL
validated(Rid) :- accepted(Rid).

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !configured(true);
      gl.ask("agent1", "classify", "Classify: apple", Rid);
      !validated(Rid).

// ACHIEVEMENT: setup (actions only)
+!configured(true)
   :  setting("model", M) & setting("provider", P)
   <- gl.configure("model", M);
      gl.use_provider(P).

// SERENDIPITY
+!validated(Rid)
   :  validated(Rid)
   <- .println("Already validated: ", Rid).

// ACHIEVEMENT: valid → accept, verify
+!validated(Rid)
   :  gl.valid(Rid, true)
   <- gl.candidate(Rid, Cid);
      gl.accept(Cid);
      +accepted(Rid);
      gl.field(Rid, "label", Label);
      +classified(Label);
      ?validated(Rid);
      .println("ACCEPTED: ", Label).

// ACHIEVEMENT: invalid → reject
+!validated(Rid)
   <- .println("Invalid output → REJECTED").

// RECOVERY
-!validated(Rid)
   <- .println("Validation FAILED for ", Rid).
