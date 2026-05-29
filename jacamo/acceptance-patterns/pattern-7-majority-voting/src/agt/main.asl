/**
 * Pattern 7: Majority Voting — JaCaMo
 *
 * Asks 3 providers the same question. Compares labels pairwise.
 * Accepts only if 2+ providers agree on the same label.
 */

!start.

+!start
   <- .println("=== Pattern 7: Majority Voting ===");
      makeArtifact("gl", "gl.adapter.jacamo.JaCaMoAdapter", [], GlId);
      focus(GlId);
      use_provider;
      ask("agent1", "classify", "Classify: tomato", R1);
      ask("agent1", "classify", "Classify: tomato", R2);
      ask("agent1", "classify", "Classify: tomato", R3);
      field(R1, "label", L1);
      field(R2, "label", L2);
      field(R3, "label", L3);
      .println("Provider 1: ", L1, " | Provider 2: ", L2, " | Provider 3: ", L3);
      !vote(R1, L1, R2, L2, R3, L3).

+!vote(R1, L1, R2, L2, R3, L3)
   :  L1 == L2
   <- candidate(R1, Cid);
      accept(Cid);
      .println("Majority agrees on '", L1, "' -> ACCEPTED");
      .stopMAS.

+!vote(R1, L1, R2, L2, R3, L3)
   :  L1 == L3
   <- candidate(R1, Cid);
      accept(Cid);
      .println("Majority agrees on '", L1, "' -> ACCEPTED");
      .stopMAS.

+!vote(R1, L1, R2, L2, R3, L3)
   :  L2 == L3
   <- candidate(R2, Cid);
      accept(Cid);
      .println("Majority agrees on '", L2, "' -> ACCEPTED");
      .stopMAS.

+!vote(R1, L1, R2, L2, R3, L3)
   :  L1 \== L2 & L1 \== L3 & L2 \== L3
   <- .println("No consensus — all disagree -> NO DECISION");
      .stopMAS.
