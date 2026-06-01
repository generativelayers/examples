// Pipeline: start → !configured → !verified → !cross_checked → !labels_match → ?verified
/**
 * Pattern 4: Cross-LLM Verification — Jason
 *
 * Asks a second LLM to verify the first LLM's output.
 * Accepts only if both labels match.
 */

// Requires: GL ontology beliefs (gl_status, gl_candidate_type, gl_verdict_type, ...)
//   See: https://github.com/generativelayers/examples/tree/main/jason/shared

// setting("model", "gpt-oss-120b"). setting("provider", "cerebras").
setting("model", "gemini-2.5-flash"). setting("provider", "gemini").
attempt_count(0).

// DOMAIN MODEL
verified(Rid) :- cross_checked(Rid).

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !configured(true);
      gl.ask("agent1", "classify", "Classify: apple", Rid);
      !verified(Rid).

// ACHIEVEMENT: setup (actions only)
+!configured(true)
   :  setting("model", M) & setting("provider", P)
   <- gl.configure("model", M);
      gl.use_provider(P).

// SERENDIPITY
+!verified(Rid)
   :  verified(Rid)
   <- .println("Already verified: ", Rid).

// DECOMPOSITION: valid → cross-check
+!verified(Rid)
   :  gl.valid(Rid, true)
   <- ?attempt_count(Count);
      -+attempt_count(Count + 1);
      !cross_checked(Rid);
      ?verified(Rid).

// ACHIEVEMENT: invalid
+!verified(Rid)
   <- .println("Invalid output → ABORTED").

// ACHIEVEMENT: cross-check with second LLM
+!cross_checked(Rid)
   :  gl.valid(Rid, true)
   <- gl.field(Rid, "label", L1);
      .concat("Is this correct? apple = ", L1, Prompt);
      gl.ask("agent1", "verify", Prompt, Vrid);
      gl.field(Vrid, "label", L2);
      !labels_match(Rid, L1, L2).

// ACHIEVEMENT: labels match → accept
+!labels_match(Rid, L1, L2)
   :  L1 == L2
   <- gl.candidate(Rid, Cid);
      gl.accept(Cid);
      +accepted(Rid);
      +cross_checked(Rid);
      .println("Labels match ('", L1, "') → ACCEPTED").

// ACHIEVEMENT: labels disagree → reject
+!labels_match(Rid, L1, L2)
   :  L1 \== L2
   <- gl.candidate(Rid, Cid);
      gl.reject(Cid);
      .println("Labels DISAGREE ('", L1, "' \\== '", L2, "') → REJECTED").

// RECOVERY
-!verified(Rid)
   <- .println("Verification FAILED for ", Rid).

-!cross_checked(Rid)
   <- .println("Cross-check FAILED for ", Rid).
