consensus_reached(true) :- consensus_label(_).

!start.

+!start
   <- !artifact_ready;
      configure("model", "gpt-oss-120b");
      use_provider("cerebras");
      !vote_cast(1);
      configure("model", "gpt-oss-120b");
      use_provider("cerebras");
      !vote_cast(2);
      configure("model", "gpt-oss-120b");
      use_provider("cerebras");
      !vote_cast(3);
      !consensus_reached(true);
      .stopMAS.

+!artifact_ready
   <- makeArtifact("gl", "gl.jacamo.GL", [], GlId);
      focus(GlId).

+!vote_cast(Id)
   <- ask("agent1", "classify", "Classify: tomato", Rid);
      candidate(Rid, Cid);
      field(Rid, "label", Label);
      +vote(Id, Cid, Label).

+!consensus_reached(true)
   :  consensus_reached(true)
   <- ?consensus_label(Winner);
      .println("Already have consensus: ", Winner).

+!consensus_reached(true)
   :  vote(1, C1, L1) & vote(2, C2, L2) & vote(3, C3, L3)
   <- !tallied(C1, L1, C2, L2, C3, L3);
      ?consensus_reached(true).

+!tallied(C1, L1, C2, L2, C3, L3)
   :  L1 == L2
   <- accept(C1);
      accept(C2);
      +consensus_label(L1);
      .println("Majority 1 and 2 - ACCEPTED").

+!tallied(C1, L1, C2, L2, C3, L3)
   :  L1 == L3
   <- accept(C1);
      accept(C3);
      +consensus_label(L1);
      .println("Majority 1 and 3 - ACCEPTED").

+!tallied(C1, L1, C2, L2, C3, L3)
   :  L2 == L3
   <- accept(C2);
      accept(C3);
      +consensus_label(L2);
      .println("Majority 2 and 3 - ACCEPTED").

+!tallied(C1, L1, C2, L2, C3, L3)
   <- .println("No consensus - NO DECISION").

-!consensus_reached(true)
   <- .println("Consensus determination FAILED").
