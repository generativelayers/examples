setting("provider1", "cerebras"). setting("model1", "gpt-oss-120b").
setting("provider2", "cerebras"). setting("model2", "gpt-oss-120b").
setting("provider3", "cerebras"). setting("model3", "gpt-oss-120b").

consensus_reached(true) :- consensus_label(_).

!start.

+!start
   <- !votes_collected(true);
      !consensus_reached(true);
      .stopMAS.

+!votes_collected(true)
   <- !vote_cast(1);
      !vote_cast(2);
      !vote_cast(3);
      !print_vote_summary.

+!vote_cast(1)
   :  setting("model1", M) & setting("provider1", P)
   <- gl.configure("model", M);
      gl.use_provider(P);
      gl.ask("agent1", "classify", "Classify: tomato", Rid);
      gl.candidate(Rid, Cid);
      gl.field(Rid, "label", Label);
      +vote(1, Rid, Cid, Label).

+!vote_cast(2)
   :  setting("model2", M) & setting("provider2", P)
   <- gl.configure("model", M);
      gl.use_provider(P);
      gl.ask("agent1", "classify", "Classify: tomato", Rid);
      gl.candidate(Rid, Cid);
      gl.field(Rid, "label", Label);
      +vote(2, Rid, Cid, Label).

+!vote_cast(3)
   :  setting("model3", M) & setting("provider3", P)
   <- gl.configure("model", M);
      gl.use_provider(P);
      gl.ask("agent1", "classify", "Classify: tomato", Rid);
      gl.candidate(Rid, Cid);
      gl.field(Rid, "label", Label);
      +vote(3, Rid, Cid, Label).

+!print_vote_summary
   <- for (vote(Id, _, _, Label)) {
          .println("  Vote ", Id, ": ", Label);
      }.

+!consensus_reached(true)
   :  consensus_reached(true)
   <- ?consensus_label(Winner);
      .println("Already have consensus: ", Winner).

+!consensus_reached(true)
   :  vote(1, R1, C1, L1) & vote(2, R2, C2, L2) & vote(3, R3, C3, L3)
   <- !tallied(R1, C1, L1, R2, C2, L2, R3, C3, L3);
      ?consensus_reached(true).

+!tallied(R1, C1, L1, R2, C2, L2, R3, C3, L3)
   :  L1 == L2
   <- gl.accept(C1);
      gl.accept(C2);
      gl.reject(C3);
      +consensus_label(L1);
      .println("Majority agrees on '", L1, "' (1&2) - ACCEPTED").

+!tallied(R1, C1, L1, R2, C2, L2, R3, C3, L3)
   :  L1 == L3
   <- gl.accept(C1);
      gl.reject(C2);
      gl.accept(C3);
      +consensus_label(L1);
      .println("Majority agrees on '", L1, "' (1&3) - ACCEPTED").

+!tallied(R1, C1, L1, R2, C2, L2, R3, C3, L3)
   :  L2 == L3
   <- gl.reject(C1);
      gl.accept(C2);
      gl.accept(C3);
      +consensus_label(L2);
      .println("Majority agrees on '", L2, "' (2&3) - ACCEPTED").

+!tallied(R1, C1, L1, R2, C2, L2, R3, C3, L3)
   <- gl.reject(C1);
      gl.reject(C2);
      gl.reject(C3);
      .println("No consensus - all candidates REJECTED").

-!consensus_reached(true)
   <- .println("Consensus determination FAILED").
