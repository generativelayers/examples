// Pipeline: start > !banner > !classified > !verified > !cross_check > !evaluate_verifier > !match_labels | !rejected_verifier | !rejected_primary
/**
 * Pattern 4: Cross-LLM Verification - Jason
 *
 * Use a primary provider and a verifier provider; accept only
 * when both candidates agree.
 */

// Requires: GL ontology beliefs (gl_status, gl_candidate_type, gl_verdict_type, ...)
//   See: https://github.com/generativelayers/examples/tree/main/jason/shared

// DOMAIN MODEL
verified(Cid) :- accepted(Cid).
verified(Cid) :- rejected(Cid).
has_candidate(Cid) :- Cid \== "".
no_candidate(Cid)  :- Cid == "".

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !banner;
      gl.bind("agent1", "groq", "llama-3.3-70b-versatile", "", Bid);
      +primary_binding(Bid);
      gl.bind("verifier1", "cerebras", "gpt-oss-120b", "", Vbid);
      +verifier_binding(Vbid);
      !classified("apple");
      !shutdown.

// ACHIEVEMENT: clean exit
+!shutdown
   <- .stopMAS.

// ACHIEVEMENT: display banner
+!banner
   :  gl.see(Providers)
   <- .println("=== Pattern 4: Cross-LLM Verification ===");
      .println("");
      .println("[Layer] Available providers: ", Providers).

// DECOMPOSITION: classify = call + deliberate/verify
+!classified(Item)
   :  primary_binding(Bid) & verifier_binding(Vbid)
   <- .concat("Classify: ", Item, ". Return only a label field.", Prompt);
      gl.call(Bid, "classify", "llm.answer", "ANSWER", Prompt, "label", "", Rid);
      !verified(Rid, Item, Bid, Vbid).

// SERENDIPITY: already verified
+!verified(Rid, Item, Bid, Vbid)
   :  gl.candidate(Rid, Cid) & verified(Cid)
   <- .println("[AGENT] Already verified: ", Rid).

// DECOMPOSITION: admissible > check verifier output
+!verified(Rid, Item, Bid, Vbid)
   :  gl.candidate(Rid, Cid) & gl.decide(Cid, "ADMISSIBLE") & gl.get(Cid, "label", Label)
   <- !cross_check(Rid, Cid, Label, Item, Bid, Vbid).

// DECOMPOSITION: not admissible > reject
+!verified(Rid, Item, Bid, Vbid)
   :  gl.candidate(Rid, Cid)
   <- !rejected_primary(Cid, Rid).

// DECOMPOSITION: cross-check with verifier
+!cross_check(Rid, PrimaryCid, PrimaryLabel, Item, Bid, Vbid)
   <- .concat("Classify this item and return only a label field: ", Item, Prompt);
      gl.call(Vbid, "verify", "llm.answer", "ANSWER", Prompt, "label", "", Vrid);
      !evaluate_verifier(Rid, PrimaryCid, PrimaryLabel, Vrid, Item).

// DECOMPOSITION: verifier admissible > compare labels
+!evaluate_verifier(Rid, PrimaryCid, PrimaryLabel, Vrid, Item)
   :  gl.candidate(Vrid, VerifierCid) & gl.decide(VerifierCid, "ADMISSIBLE") & gl.get(VerifierCid, "label", VerifierLabel)
   <- .println("Primary Agent: label = ", PrimaryLabel);
      .println("Verifier Agent: label = ", VerifierLabel);
      !match_labels(Rid, PrimaryCid, PrimaryLabel, Vrid, VerifierCid, VerifierLabel).

// DECOMPOSITION: verifier not admissible > reject
+!evaluate_verifier(Rid, PrimaryCid, PrimaryLabel, Vrid, Item)
   :  gl.candidate(Vrid, VerifierCid)
   <- !rejected_verifier(PrimaryCid, VerifierCid, Rid, Vrid).

// ACHIEVEMENT: labels match > accept both
+!match_labels(Rid, PrimaryCid, PrimaryLabel, Vrid, VerifierCid, VerifierLabel)
   :  PrimaryLabel == VerifierLabel
   <- .concat("cross-LLM match: ", PrimaryLabel, Reason1);
      .concat("cross-LLM match: ", VerifierLabel, Reason2);
      gl.accept(PrimaryCid, Reason1, _);
      gl.accept(VerifierCid, Reason2, _);
      +accepted(PrimaryCid);
      +accepted(VerifierCid);
      .println("Result: MATCH - ACCEPTED");
      !print_trace(Rid);
      !print_trace(Vrid);
      .println("=== Demo Complete ===").

// ACHIEVEMENT: labels mismatch > reject both
+!match_labels(Rid, PrimaryCid, PrimaryLabel, Vrid, VerifierCid, VerifierLabel)
   :  PrimaryLabel \== VerifierLabel
   <- .concat("cross-LLM mismatch: ", PrimaryLabel, " vs ", VerifierLabel, Reason);
      gl.reject(PrimaryCid, Reason, _);
      gl.reject(VerifierCid, Reason, _);
      +rejected(PrimaryCid);
      +rejected(VerifierCid);
      .println("Result: MISMATCH - REJECTED");
      !print_trace(Rid);
      !print_trace(Vrid);
      .println("=== Demo Complete ===").

// ACHIEVEMENT: reject primary (candidate exists)
+!rejected_primary(Cid, Rid)
   :  has_candidate(Cid)
   <- gl.reject(Cid, "primary validation failed", _);
      +rejected(Cid);
      .println("Invalid primary output - REJECTED");
      !print_trace(Rid).

// ACHIEVEMENT: reject primary (no candidate)
+!rejected_primary(Cid, Rid)
   :  no_candidate(Cid)
   <- +rejected("");
      .println("Primary invocation failed - REJECTED");
      !print_trace(Rid).

// DECOMPOSITION: reject verifier
+!rejected_verifier(PrimaryCid, VerifierCid, Rid, Vrid)
   <- !reject_single_cid(PrimaryCid);
      !reject_single_cid(VerifierCid);
      .println("Verifier output invalid - REJECTED");
      !print_trace(Rid);
      !print_trace(Vrid).

// ACHIEVEMENT: reject single candidate (exists)
+!reject_single_cid(Cid)
   :  has_candidate(Cid)
   <- gl.reject(Cid, "verifier validation failed", _);
      +rejected(Cid).

// ACHIEVEMENT: reject single candidate (none)
+!reject_single_cid(Cid)
   :  no_candidate(Cid)
   <- +rejected("").

// ACHIEVEMENT: print trace
+!print_trace(Rid)
   :  gl.explain(Rid, Trace)
   <- .println("");
      .println("[TRACE] ", Trace).

// RECOVERY
-!verified(Rid, Item, Bid, Vbid)
   :  not accepted(_) & not rejected(_)
   <- .println("Verification FAILED for ", Rid).
