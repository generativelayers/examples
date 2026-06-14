// Pipeline: start > !banner > !drafted > !checked > !revised > !accepted_final
/**
 * Pattern 8: Iterative Refinement - JaCaMo
 *
 * Generate, check, refine, and accept only the final validated
 * candidate. Free-text outputs use the framework's text field.
 */

// DOMAIN MODEL
refined(FinalRid) :- accepted_final(FinalRid).
has_candidate(Cid) :- Cid \== "".
no_candidate(Cid)  :- Cid == "".

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !artifact_ready;
      !banner;
      bind("agent1", "groq", "llama-3.3-70b-versatile", "", Bid);
      +binding(Bid);
      !drafted("Write a short paragraph about photosynthesis.");
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
      .println("=== Pattern 8: Iterative Refinement ===");
      .println("");
      .println("[Layer] Available providers: ", Providers).

// DECOMPOSITION: draft
+!drafted(Prompt)
   :  binding(Bid)
   <- call(Bid, "draft", "llm.answer", "ANSWER", Prompt, "answer", "", DraftRid);
      !checked(DraftRid).

// DECOMPOSITION: check
+!checked(DraftRid)
   :  binding(Bid)
   <- !print_draft(DraftRid);
      candidate(DraftRid, DraftCid);
      !checked_candidate(DraftRid, DraftCid, Bid).

+!checked_candidate(DraftRid, DraftCid, Bid)
   :  has_candidate(DraftCid)
   <- get(DraftCid, "answer", DraftText);
      .concat("Review this text and suggest improvements: ", DraftText, Prompt);
      call(Bid, "check", "llm.answer", "ANSWER", Prompt, "answer", "", CheckRid);
      !revised(DraftRid, CheckRid).

+!checked_candidate(DraftRid, DraftCid, Bid)
   :  no_candidate(DraftCid)
   <- .println("[AGENT] Cannot check draft - no candidate").

// ACHIEVEMENT: print draft
+!print_draft(DraftRid)
   <- candidate(DraftRid, DraftCid);
      !print_draft_candidate(DraftCid).

+!print_draft_candidate(DraftCid)
   :  has_candidate(DraftCid)
   <- get(DraftCid, "answer", DraftText);
      .println("[Draft] ", DraftText).

+!print_draft_candidate(DraftCid)
   :  no_candidate(DraftCid)
   <- .println("[Draft] no candidate").

// DECOMPOSITION: revise
+!revised(DraftRid, CheckRid)
   :  binding(Bid)
   <- !print_check(CheckRid);
      candidate(DraftRid, DraftCid);
      candidate(CheckRid, CheckCid);
      !revised_candidates(DraftRid, DraftCid, CheckRid, CheckCid, Bid).

+!revised_candidates(DraftRid, DraftCid, CheckRid, CheckCid, Bid)
   :  has_candidate(DraftCid) & has_candidate(CheckCid)
   <- get(DraftCid, "answer", DraftText);
      get(CheckCid, "answer", CheckText);
      .concat("Revise this text: ", DraftText, " Based on: ", CheckText, Prompt);
      call(Bid, "revise", "llm.answer", "ANSWER", Prompt, "answer", "", FinalRid);
      !accepted_final(FinalRid).

+!revised_candidates(DraftRid, DraftCid, CheckRid, CheckCid, Bid)
   <- .println("[AGENT] Cannot revise - missing candidates").

// ACHIEVEMENT: print check
+!print_check(CheckRid)
   <- candidate(CheckRid, CheckCid);
      !print_check_candidate(CheckCid).

+!print_check_candidate(CheckCid)
   :  has_candidate(CheckCid)
   <- get(CheckCid, "answer", CheckText);
      .println("[Check] ", CheckText).

+!print_check_candidate(CheckCid)
   :  no_candidate(CheckCid)
   <- .println("[Check] no candidate").

// DECOMPOSITION: accept final and print trace
+!accepted_final(FinalRid)
   <- !print_revised(FinalRid);
      candidate(FinalRid, FinalCid);
      !accept_candidate(FinalCid, FinalRid);
      !print_trace(FinalRid);
      !print_complete.

// ACHIEVEMENT: print revised
+!print_revised(FinalRid)
   <- candidate(FinalRid, FinalCid);
      !print_revised_candidate(FinalCid).

+!print_revised_candidate(FinalCid)
   :  has_candidate(FinalCid)
   <- get(FinalCid, "answer", FinalText);
      .println("[Revised] ", FinalText).

+!print_revised_candidate(FinalCid)
   :  no_candidate(FinalCid)
   <- .println("[Revised] no candidate").

// ACHIEVEMENT: accept candidate
+!accept_candidate(FinalCid, FinalRid)
   :  has_candidate(FinalCid)
   <- accept(FinalCid, "final refined text", _);
      +accepted_final(FinalRid);
      .println("Final candidate - ACCEPTED").

+!accept_candidate(FinalCid, FinalRid)
   :  no_candidate(FinalCid)
   <- .println("Final candidate missing - REJECTED").

// ACHIEVEMENT: print trace
+!print_trace(Rid)
   <- explain(Rid, Trace);
      .println("");
      .println("[TRACE] ", Trace).

// ACHIEVEMENT: print complete
+!print_complete
   <- .println("=== Demo Complete ===").

// RECOVERY
-!drafted(Prompt)
   :  not accepted_final(_)
   <- .println("Pipeline FAILED").
