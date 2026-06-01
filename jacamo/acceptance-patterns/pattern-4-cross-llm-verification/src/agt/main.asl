// Pipeline: start → !artifact_ready → !configured → !verified → !cross_checked → !labels_match → ?verified
/**
 * Pattern 4: Cross-LLM Verification — JaCaMo
 *
 * Asks a second LLM to verify the first LLM's output.
 * Accepts only if both labels match.
 */

// setting("model", "gpt-oss-120b"). setting("provider", "cerebras").
setting("model", "gemini-2.5-flash"). setting("provider", "gemini").
attempt_count(0).

// DOMAIN MODEL
verified(Rid) :- cross_checked(Rid).

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !artifact_ready;
      !configured(true);
      ask("agent1", "classify", "Classify: apple", Rid);
      !verified(Rid).

// ACHIEVEMENT: create and focus the GL artifact
+!artifact_ready
   <- makeArtifact("gl", "gl.adapter.jacamo.JaCaMoAdapter", [], GlId);
      focus(GlId).

// ACHIEVEMENT: setup (actions only)
+!configured(true)
   :  setting("model", M) & setting("provider", P)
   <- configure("model", M);
      use_provider(P).

// SERENDIPITY
+!verified(Rid)
   :  verified(Rid)
   <- .println("Already verified: ", Rid).

// DECOMPOSITION: bind validity → cross-check
+!verified(Rid)
   <- valid(Rid, IsValid);
      !verified_branch(Rid, IsValid).

+!verified_branch(Rid, true)
   <- ?attempt_count(Count);
      -+attempt_count(Count + 1);
      !cross_checked(Rid);
      ?verified(Rid).

// ACHIEVEMENT: invalid
+!verified_branch(Rid, false)
   <- .println("Invalid output → ABORTED").

// ACHIEVEMENT: cross-check with second LLM
+!cross_checked(Rid)
   <- field(Rid, "label", L1);
      .concat("Is this correct? apple = ", L1, Prompt);
      ask("agent1", "verify", Prompt, Vrid);
      field(Vrid, "label", L2);
      !labels_match(Rid, L1, L2).

// ACHIEVEMENT: labels match → accept
+!labels_match(Rid, L1, L2)
   :  L1 == L2
   <- candidate(Rid, Cid);
      accept(Cid);
      +accepted(Rid);
      +cross_checked(Rid);
      .println("Labels match ('", L1, "') → ACCEPTED").

// ACHIEVEMENT: labels disagree → reject
+!labels_match(Rid, L1, L2)
   :  L1 \== L2
   <- candidate(Rid, Cid);
      reject(Cid);
      .println("Labels DISAGREE ('", L1, "' \\== '", L2, "') → REJECTED").

// RECOVERY
-!verified(Rid)
   <- .println("Verification FAILED for ", Rid).

-!cross_checked(Rid)
   <- .println("Cross-check FAILED for ", Rid).
