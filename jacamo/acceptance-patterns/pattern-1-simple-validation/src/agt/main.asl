// Pipeline: start → !artifact_ready → !configured → !validated → ?validated
/**
 * Pattern 1: Simple Validation — JaCaMo
 *
 * The simplest governance pattern: accept valid output, reject invalid.
 * Demonstrates the fundamental valid/invalid context-guard branching.
 *
 * NOTE: In JaCaMo, GL operations (valid, field, candidate, accept, reject)
 * are CArtAgO artifact operations — they MUST be called in plan bodies,
 * not in context guards. valid() binds its result; branching is done
 * by passing the bound value to a subgoal.
 */

// setting("model", "gpt-oss-120b"). setting("provider", "cerebras").
setting("model", "gpt-oss-120b"). setting("provider", "cerebras").

// DOMAIN MODEL
validated(Rid) :- accepted(Rid).
validated(Rid) :- rejected(Rid).

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !artifact_ready;
      !configured(true);
      ask("agent1", "classify", "Classify: apple", Rid);
      !validated(Rid).

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
+!validated(Rid)
   :  validated(Rid)
   <- .println("Already validated: ", Rid).

// DECOMPOSITION: bind validity → branch
+!validated(Rid)
   <- valid(Rid, IsValid);
      !validated_branch(Rid, IsValid).

// ACHIEVEMENT: valid → accept, verify
+!validated_branch(Rid, true)
   <- candidate(Rid, Cid);
      accept(Cid);
      +accepted(Rid);
      field(Rid, "label", Label);
      +classified(Label);
      ?validated(Rid);
      .println("ACCEPTED: ", Label).

// ACHIEVEMENT: invalid → reject the concrete candidate
+!validated_branch(Rid, false)
   <- candidate(Rid, Cid);
      reject(Cid);
      +rejected(Rid);
      .println("Invalid output → REJECTED").

// RECOVERY
-!validated(Rid)
   <- .println("Validation FAILED for ", Rid).
