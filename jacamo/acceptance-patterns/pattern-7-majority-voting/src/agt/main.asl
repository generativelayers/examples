// Pipeline: start → !artifact_ready → !configured → !votes_collected → !vote_cast(1,2,3) → !consensus_reached → !tallied → ?consensus_reached
/**
 * Pattern 7: Majority Voting — JaCaMo
 *
 * Asks 3 providers the same question. Compares labels pairwise.
 * Accepts only if 2+ providers agree on the same label.
 */

// setting("model", "gpt-oss-120b"). setting("provider", "cerebras").
setting("model", "gemini-2.5-flash"). setting("provider", "gemini").

// DOMAIN MODEL
consensus_reached(true) :- consensus_label(_).

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !artifact_ready;
      !configured(true);
      !votes_collected(true);
      !consensus_reached(true).

// ACHIEVEMENT: create and focus the GL artifact
+!artifact_ready
   <- makeArtifact("gl", "gl.adapter.jacamo.JaCaMoAdapter", [], GlId);
      focus(GlId).

// ACHIEVEMENT: setup (actions only)
+!configured(true)
   :  setting("model", M) & setting("provider", P)
   <- configure("model", M);
      use_provider(P).

// DECOMPOSITION: collect = cast 3 votes → print summary
+!votes_collected(true)
   <- !vote_cast(1);
      !vote_cast(2);
      !vote_cast(3);
      !print_vote_summary.

// ACHIEVEMENT: cast a single vote (actions only)
+!vote_cast(N)
   <- ask("agent1", "classify", "Classify: tomato", Rid);
      field(Rid, "label", Label);
      +vote(N, Label).

// ACHIEVEMENT: print summary of collected votes
+!print_vote_summary
   <- for (vote(Id, Label)) {
          .println("  Vote ", Id, ": ", Label);
      }.

// SERENDIPITY
+!consensus_reached(true)
   :  consensus_reached(true)
   <- ?consensus_label(Winner);
      .println("Already have consensus: ", Winner).

// DECOMPOSITION: tally the votes → verify
+!consensus_reached(true)
   :  vote(1, L1) & vote(2, L2) & vote(3, L3)
   <- !tallied(L1, L2, L3);
      ?consensus_reached(true).

// ACHIEVEMENT: 1 & 2 agree
+!tallied(L1, L2, L3)
   :  L1 == L2
   <- +consensus_label(L1);
      .println("Majority agrees on '", L1, "' (1&2) → ACCEPTED").

// ACHIEVEMENT: 1 & 3 agree
+!tallied(L1, L2, L3)
   :  L1 == L3
   <- +consensus_label(L1);
      .println("Majority agrees on '", L1, "' (1&3) → ACCEPTED").

// ACHIEVEMENT: 2 & 3 agree, 1 disagrees
+!tallied(L1, L2, L3)
   :  L2 == L3 & L1 \== L2
   <- +consensus_label(L2);
      .println("Majority agrees on '", L2, "' (2&3) → ACCEPTED").

// ACHIEVEMENT: no consensus
+!tallied(L1, L2, L3)
   <- .println("No consensus — all disagree → NO DECISION").

// RECOVERY
-!consensus_reached(true)
   <- .println("Consensus determination FAILED").
