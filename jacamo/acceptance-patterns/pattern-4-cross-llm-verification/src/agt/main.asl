// Pipeline: start > !banner > !setup > !classified > !verified > !cross_check > !evaluate_verifier > !match_labels | !rejected_verifier | !rejected_primary
/**
 * Pattern 4: Cross-LLM Verification - JaCaMo
 *
 * Use a primary provider and a verifier provider; accept only
 * when both candidates agree.
 */

// DOMAIN MODEL
verified(Cid) :- accepted(Cid).
verified(Cid) :- rejected(Cid).
has_candidate(Cid) :- Cid \== "".
no_candidate(Cid)  :- Cid == "".

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !artifact_ready;
      !banner;
      !setup;
      !classified("apple");
      .stopMAS.

// ACHIEVEMENT: create and focus the GL artifact
+!artifact_ready
   <- makeArtifact("gl", "gl.jacamo.GL", [], GlId);
      focus(GlId).

// ACHIEVEMENT: display banner
+!banner
   <- see(Providers);
      .println("=== Pattern 4: Cross-LLM Verification ===");
      .println("").

// ACHIEVEMENT: setup
+!setup
   <- bind("agent1", "groq", "llama-3.3-70b-versatile", "", Bid);
      +primary_binding(Bid);
      bind("verifier1", "cerebras", "gpt-oss-120b", "", Vbid);
      +verifier_binding(Vbid).

// DECOMPOSITION: classify = call + deliberate/verify
+!classified(Item)
   :  primary_binding(Bid) & verifier_binding(Vbid)
   <- .concat("Classify: ", Item, ". Return only a label field.", Prompt);
      call(Bid, "classify", "llm.answer", "ANSWER", Prompt, "label", "", Rid);
      !verified(Rid, Item, Bid, Vbid).

// SERENDIPITY: already verified
+!verified(Rid, Item, Bid, Vbid)
   :  accepted(Cid) & candidate(Rid, Cid)
   <- .println("Already verified: ", Rid).

// DECOMPOSITION: handle deliberation
+!verified(Rid, Item, Bid, Vbid)
   <- candidate(Rid, Cid);
      !verified_candidate(Rid, Cid, Item, Bid, Vbid).

+!verified_candidate(Rid, Cid, Item, Bid, Vbid)
   :  has_candidate(Cid)
   <- decide(Cid, Admissibility);
      !verified_decision(Rid, Cid, Admissibility, Item, Bid, Vbid).

+!verified_candidate(Rid, Cid, Item, Bid, Vbid)
   :  no_candidate(Cid)
   <- result(Rid, Outcome);
      !verified_decision(Rid, Cid, Outcome, Item, Bid, Vbid).

// DECOMPOSITION: route primary decision
+!verified_decision(Rid, Cid, "ADMISSIBLE", Item, Bid, Vbid)
   <- get(Cid, "label", Label);
      !cross_check(Rid, Cid, Label, Item, Bid, Vbid).

+!verified_decision(Rid, Cid, Outcome, Item, Bid, Vbid)
   <- !rejected_primary(Cid, Rid, Outcome).

// DECOMPOSITION: cross-check with verifier
+!cross_check(Rid, PrimaryCid, PrimaryLabel, Item, Bid, Vbid)
   <- .concat("Classify this item and return only a label field: ", Item, Prompt);
      call(Vbid, "verify", "llm.answer", "ANSWER", Prompt, "label", "", Vrid);
      !evaluate_verifier(Rid, PrimaryCid, PrimaryLabel, Vrid, Item).

// DECOMPOSITION: evaluate verifier
+!evaluate_verifier(Rid, PrimaryCid, PrimaryLabel, Vrid, Item)
   <- candidate(Vrid, VerifierCid);
      !evaluate_verifier_candidate(Rid, PrimaryCid, PrimaryLabel, Vrid, VerifierCid, Item).

+!evaluate_verifier_candidate(Rid, PrimaryCid, PrimaryLabel, Vrid, VerifierCid, Item)
   :  has_candidate(VerifierCid)
   <- decide(VerifierCid, Admissibility);
      !evaluate_verifier_decision(Rid, PrimaryCid, PrimaryLabel, Vrid, VerifierCid, Admissibility, Item).

+!evaluate_verifier_candidate(Rid, PrimaryCid, PrimaryLabel, Vrid, VerifierCid, Item)
   :  no_candidate(VerifierCid)
   <- result(Vrid, Outcome);
      !evaluate_verifier_decision(Rid, PrimaryCid, PrimaryLabel, Vrid, VerifierCid, Outcome, Item).

// DECOMPOSITION: route verifier decision
+!evaluate_verifier_decision(Rid, PrimaryCid, PrimaryLabel, Vrid, VerifierCid, "ADMISSIBLE", Item)
   <- get(VerifierCid, "label", VerifierLabel);
      !match_labels(Rid, PrimaryCid, PrimaryLabel, Vrid, VerifierCid, VerifierLabel).

+!evaluate_verifier_decision(Rid, PrimaryCid, PrimaryLabel, Vrid, VerifierCid, Outcome, Item)
   <- !rejected_verifier(PrimaryCid, VerifierCid, Rid, Vrid, Outcome).

// ACHIEVEMENT: labels match > accept both
+!match_labels(Rid, PrimaryCid, PrimaryLabel, Vrid, VerifierCid, VerifierLabel)
   :  PrimaryLabel == VerifierLabel
   <- .concat("cross-LLM match: ", PrimaryLabel, Reason1);
      .concat("cross-LLM match: ", VerifierLabel, Reason2);
      accept(PrimaryCid, Reason1, _);
      accept(VerifierCid, Reason2, _);
      +accepted(PrimaryCid);
      +accepted(VerifierCid);
      .println("[Verifier] label = ", VerifierLabel, " - MATCH - ACCEPTED");
      !print_trace(Rid);
      !print_trace(Vrid);
      .println("=== Demo Complete ===").

// ACHIEVEMENT: labels mismatch > reject both
+!match_labels(Rid, PrimaryCid, PrimaryLabel, Vrid, VerifierCid, VerifierLabel)
   :  PrimaryLabel \== VerifierLabel
   <- .concat("cross-LLM mismatch: ", PrimaryLabel, " vs ", VerifierLabel, Reason);
      reject(PrimaryCid, Reason, _);
      reject(VerifierCid, Reason, _);
      +rejected(PrimaryCid);
      +rejected(VerifierCid);
      .println("[Verifier] label = ", VerifierLabel, " != ", PrimaryLabel, " - REJECTED");
      !print_trace(Rid);
      !print_trace(Vrid);
      .println("=== Demo Complete ===").

// ACHIEVEMENT: reject primary (candidate exists)
+!rejected_primary(Cid, Rid, Outcome)
   :  has_candidate(Cid)
   <- reject(Cid, "primary validation failed", _);
      +rejected(Cid);
      .println("Invalid primary output - REJECTED");
      !print_trace(Rid).

// ACHIEVEMENT: reject primary (no candidate)
+!rejected_primary(Cid, Rid, Outcome)
   :  no_candidate(Cid)
   <- +rejected("");
      .println("Primary invocation failed - REJECTED");
      !print_trace(Rid).

// DECOMPOSITION: reject verifier
+!rejected_verifier(PrimaryCid, VerifierCid, Rid, Vrid, Outcome)
   <- !reject_single_cid(PrimaryCid);
      !reject_single_cid(VerifierCid);
      .println("Verifier output invalid - REJECTED (outcome = ", Outcome, ")");
      !print_trace(Rid);
      !print_trace(Vrid).

// ACHIEVEMENT: reject single candidate (exists)
+!reject_single_cid(Cid)
   :  has_candidate(Cid)
   <- reject(Cid, "verifier validation failed", _);
      +rejected(Cid).

// ACHIEVEMENT: reject single candidate (none)
+!reject_single_cid(Cid)
   :  no_candidate(Cid)
   <- +rejected("").

// ACHIEVEMENT: print trace
+!print_trace(Rid)
   <- explain(Rid, Trace);
      .println("");
      .println("[TRACE] ", Trace).

// RECOVERY
-!verified(Rid, Item, Bid, Vbid)
   :  not accepted(_) & not rejected(_)
   <- .println("Verification FAILED for ", Rid).
