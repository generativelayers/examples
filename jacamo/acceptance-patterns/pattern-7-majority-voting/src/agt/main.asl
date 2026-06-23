// Pipeline: start > !banner > !classified > !vote_cast(1..3) > !vote_recorded > !consensus_reached
/**
 * Pattern 7: Majority Voting - JaCaMo
 *
 * Collect multiple candidate votes and record acceptance for the concrete
 * candidates that form a majority.
 */

// DOMAIN MODEL
consensus_reached(true) :- consensus_label(_).
consensus_reached(true) :- no_consensus(true).
has_candidate(Cid) :- Cid \== "".
no_candidate(Cid)  :- Cid == "".

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !artifact_ready;
      !banner;
      bind("agent1", "groq", "llama-3.3-70b-versatile", "", Bid1);
      +binding(1, Bid1);
      bind("agent2", "cerebras", "gpt-oss-120b", "", Bid2);
      +binding(2, Bid2);
      bind("agent3", "groq", "llama-3.3-70b-versatile", "", Bid3);
      +binding(3, Bid3);
      !classified("tomato");
      !shutdown.

// ACHIEVEMENT: create and focus the GL artifact
+!artifact_ready
   		<- makeArtifact("gl", "gl.jacamo.GL", [], GlId);
      focus(GlId).

// ACHIEVEMENT: clean exit
+!shutdown
   <- .stopMAS.

// ACHIEVEMENT: display banner
+!banner
   <- see(Providers);
      .println("=== Pattern 7: Majority Voting ===");
      .println("");
      .println("[Layer] Available providers: ", Providers).

// DECOMPOSITION: classify = cast 3 votes + check consensus
+!classified(Item)
   :  binding(1, Bid1) & binding(2, Bid2) & binding(3, Bid3)
   <- !vote_cast(1, Bid1, Item);
      !vote_cast(2, Bid2, Item);
      !vote_cast(3, Bid3, Item);
      !consensus_reached(true).

// DECOMPOSITION: cast vote
+!vote_cast(Id, Bid, Item)
   <- .concat("Classify: ", Item, ". Return only a label field.", Prompt);
      call(Bid, "classify", "llm.answer", "ANSWER", Prompt, "label", "", Rid);
      !vote_recorded(Id, Rid).

// DECOMPOSITION: handle deliberation for vote
+!vote_recorded(Id, Rid)
   <- candidate(Rid, Cid);
      !vote_candidate(Id, Rid, Cid).

+!vote_candidate(Id, Rid, Cid)
   :  has_candidate(Cid)
   <- decide(Cid, Admissibility);
      !vote_decision(Id, Rid, Cid, Admissibility).

+!vote_candidate(Id, Rid, Cid)
   :  no_candidate(Cid)
   <- result(Rid, Outcome);
      !vote_decision(Id, Rid, Cid, Outcome).

// DECOMPOSITION: route decision for vote
+!vote_decision(Id, Rid, Cid, "ADMISSIBLE")
   <- get(Cid, "label", Label);
      +vote(Id, Rid, Cid, Label);
      .println("[Vote ", Id, "] label = ", Label).

+!vote_decision(Id, Rid, Cid, Outcome)
   <- +vote(Id, Rid, Cid, "INVALID");
      .println("[Vote ", Id, "] output invalid").

// SERENDIPITY: consensus already reached
+!consensus_reached(X)
   :  consensus_reached(true) & consensus_label(Winner)
   <- .println("Already have consensus: ", Winner).

// ACHIEVEMENT: tally votes 1 & 2 match
+!consensus_reached(X)
   :  vote(1, R1, C1, L1) &
      vote(2, R2, C2, L2) &
      vote(3, R3, C3, L3) &
      L1 == L2 & L1 \== "INVALID"
   <- accept(C1, "majority vote", _);
      accept(C2, "majority vote", _);
      +consensus_label(L1);
      .println("Majority (votes 1 & 2): '", L1, "' - ACCEPTANCE RECORDED");
      !print_trace(R1);
      !print_trace(R2);
      !print_trace(R3);
      .println("=== Demo Complete ===").

// ACHIEVEMENT: tally votes 1 & 3 match
+!consensus_reached(X)
   :  vote(1, R1, C1, L1) &
      vote(2, R2, C2, L2) &
      vote(3, R3, C3, L3) &
      L1 == L3 & L1 \== "INVALID"
   <- accept(C1, "majority vote", _);
      accept(C3, "majority vote", _);
      +consensus_label(L1);
      .println("Majority (votes 1 & 3): '", L1, "' - ACCEPTANCE RECORDED");
      !print_trace(R1);
      !print_trace(R2);
      !print_trace(R3);
      .println("=== Demo Complete ===").

// ACHIEVEMENT: tally votes 2 & 3 match
+!consensus_reached(X)
   :  vote(1, R1, C1, L1) &
      vote(2, R2, C2, L2) &
      vote(3, R3, C3, L3) &
      L2 == L3 & L2 \== "INVALID"
   <- accept(C2, "majority vote", _);
      accept(C3, "majority vote", _);
      +consensus_label(L2);
      .println("Majority (votes 2 & 3): '", L2, "' - ACCEPTANCE RECORDED");
      !print_trace(R1);
      !print_trace(R2);
      !print_trace(R3);
      .println("=== Demo Complete ===").

// ACHIEVEMENT: no majority consensus
+!consensus_reached(X)
   :  vote(1, R1, C1, L1) &
      vote(2, R2, C2, L2) &
      vote(3, R3, C3, L3)
   <- reject(C1, "no majority consensus", _);
      reject(C2, "no majority consensus", _);
      reject(C3, "no majority consensus", _);
      +no_consensus(true);
      .println("No majority - NO CONSENSUS");
      !print_trace(R1);
      !print_trace(R2);
      !print_trace(R3);
      .println("=== Demo Complete ===").

// ACHIEVEMENT: print trace
+!print_trace(Rid)
   <- explain(Rid, Trace);
      .println("");
      .println("[TRACE] ", Trace).

// RECOVERY
-!consensus_reached(X)
   :  not consensus_label(_) & not no_consensus(true)
   <- .println("Consensus FAILED").

-!vote_recorded(Id, Rid)
   :  not vote(Id, _, _, _)
   <- .println("Vote ", Id, " FAILED").