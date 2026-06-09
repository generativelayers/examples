setting("primary_provider", "cerebras"). setting("primary_model", "gpt-oss-120b").
setting("verifier_provider", "cerebras"). setting("verifier_model", "gpt-oss-120b").
attempt_count(0).

verified(Rid) :- cross_checked(Rid).
verified(Rid) :- rejected(Rid).

!start.

+!start
   <- !configured_primary;
      gl.ask("agent1", "classify", "Classify: apple", Rid);
      !verified(Rid);
      .stopMAS.

+!configured_primary
   :  setting("primary_model", M) & setting("primary_provider", P)
   <- gl.configure("model", M);
      gl.use_provider(P).

+!configured_verifier
   :  setting("verifier_model", M) & setting("verifier_provider", P)
   <- gl.configure("model", M);
      gl.use_provider(P).

+!verified(Rid)
   :  verified(Rid)
   <- .println("Already verified: ", Rid).

+!verified(Rid)
   :  gl.valid(Rid, true)
   <- ?attempt_count(Count);
      -+attempt_count(Count + 1);
      !cross_checked(Rid);
      ?verified(Rid).

+!verified(Rid)
   <- gl.candidate(Rid, Cid);
      gl.reject(Cid);
      +rejected(Rid);
      .println("Invalid first output - REJECTED").

+!cross_checked(Rid)
   :  gl.valid(Rid, true)
   <- gl.field(Rid, "label", L1);
      !configured_verifier;
      .concat("Verify the classification. Return label only. apple = ", L1, Prompt);
      gl.ask("agent1", "verify", Prompt, Vrid);
      gl.field(Vrid, "label", L2);
      !labels_match(Rid, Vrid, L1, L2).

+!labels_match(Rid, Vrid, L1, L2)
   :  L1 == L2
   <- gl.candidate(Rid, Cid1);
      gl.candidate(Vrid, Cid2);
      gl.accept(Cid1);
      gl.accept(Cid2);
      +accepted(Rid);
      +cross_checked(Rid);
      .println("Providers agree on '", L1, "' - ACCEPTED").

+!labels_match(Rid, Vrid, L1, L2)
   :  L1 \== L2
   <- gl.candidate(Rid, Cid1);
      gl.candidate(Vrid, Cid2);
      gl.reject(Cid1);
      gl.reject(Cid2);
      +rejected(Rid);
      .println("Providers disagree: ", L1, " vs ", L2, " - REJECTED").

-!verified(Rid)
   <- .println("Verification FAILED for ", Rid).

-!cross_checked(Rid)
   <- .println("Cross-check FAILED for ", Rid).
