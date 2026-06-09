setting("primary_provider", "cerebras"). setting("primary_model", "gpt-oss-120b").
setting("reviewer_provider", "cerebras"). setting("reviewer_model", "gpt-oss-120b").
attempt_count(0).

verified(Rid) :- cross_checked(Rid).
verified(Rid) :- rejected(Rid).

!start.

+!start
   <- !artifact_ready;
      !configured_primary;
      ask("agent1", "classify", "Classify apple", Rid);
      !verified(Rid).

+!artifact_ready
   <- makeArtifact("gl", "gl.jacamo.GL", [], GlId);
      focus(GlId).

+!configured_primary
   :  setting("primary_model", M) & setting("primary_provider", P)
   <- configure("model", M);
      use_provider(P).

+!configured_reviewer
   :  setting("reviewer_model", M) & setting("reviewer_provider", P)
   <- configure("model", M);
      use_provider(P).

+!verified(Rid)
   :  verified(Rid)
   <- .println("Already checked: ", Rid).

+!verified(Rid)
   <- valid(Rid, IsValid);
      !verified_branch(Rid, IsValid).

+!verified_branch(Rid, true)
   <- ?attempt_count(Count);
      -+attempt_count(Count + 1);
      !cross_checked(Rid);
      ?verified(Rid).

+!verified_branch(Rid, false)
   <- candidate(Rid, Cid);
      reject(Cid);
      +rejected(Rid);
      .println("Invalid first output - REJECTED").

+!cross_checked(Rid)
   <- field(Rid, "label", L1);
      !configured_reviewer;
      .concat("Classify apple. First answer was ", L1, Prompt);
      ask("agent1", "review", Prompt, Vrid);
      field(Vrid, "label", L2);
      !labels_match(Rid, Vrid, L1, L2).

+!labels_match(Rid, Vrid, L1, L2)
   :  L1 == L2
   <- candidate(Rid, Cid1);
      candidate(Vrid, Cid2);
      accept(Cid1);
      accept(Cid2);
      +accepted(Rid);
      +cross_checked(Rid);
      .println("Providers agree - ACCEPTED").

+!labels_match(Rid, Vrid, L1, L2)
   <- candidate(Rid, Cid1);
      candidate(Vrid, Cid2);
      reject(Cid1);
      reject(Cid2);
      +rejected(Rid);
      .println("Providers disagree - REJECTED").

-!verified(Rid)
   <- .println("Check FAILED for ", Rid).

-!cross_checked(Rid)
   <- .println("Cross-check FAILED for ", Rid).
