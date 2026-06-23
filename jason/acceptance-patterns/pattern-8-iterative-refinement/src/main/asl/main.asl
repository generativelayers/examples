// Pipeline: start > !banner > !drafted > !checked > !revised > !accepted_final
/**
 * Pattern 8: Iterative Refinement - Jason
 *
 * Generate, check, refine, and record acceptance only for the final refined
 * candidate. Free-text outputs use the framework's text field.
 */

// Requires: GL ontology beliefs (gl_status, gl_candidate_type, gl_verdict_type, ...)
//   See: https://github.com/generativelayers/examples/tree/main/jason/shared

refined(FinalRid) :- accepted_final(FinalRid).

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !banner;
      gl.bind("agent1", "groq", "llama-3.3-70b-versatile", "", Bid);
      +binding(Bid);
      !drafted("Write a short paragraph about photosynthesis.");
      !shutdown.

// ACHIEVEMENT: clean exit
+!shutdown
   <- .stopMAS.

// ACHIEVEMENT: display banner
+!banner
   :  gl.see(Providers)
   <- .println("=== Pattern 8: Iterative Refinement ===");
      .println("");
      .println("[Layer] Available providers: ", Providers).

// DECOMPOSITION: draft
+!drafted(Prompt)
   :  binding(Bid)
   <- gl.call(Bid, "draft", "llm.answer", "ANSWER", Prompt, "answer", "", DraftRid);
      !checked(DraftRid).

// DECOMPOSITION: check
+!checked(DraftRid)
   :  binding(Bid)
   <- !print_draft(DraftRid);
      gl.candidate(DraftRid, DraftCid);
      gl.get(DraftCid, "answer", DraftText);
      .concat("Review this text and suggest improvements: ", DraftText, Prompt);
      gl.call(Bid, "check", "llm.answer", "ANSWER", Prompt, "answer", "", CheckRid);
      !revised(DraftRid, CheckRid).

// ACHIEVEMENT: print draft
+!print_draft(DraftRid)
   :  gl.candidate(DraftRid, DraftCid) & gl.get(DraftCid, "answer", DraftText)
   <- .println("[Draft] ", DraftText).

// DECOMPOSITION: revise
+!revised(DraftRid, CheckRid)
   :  binding(Bid)
   <- !print_check(CheckRid);
      gl.candidate(DraftRid, DraftCid);
      gl.get(DraftCid, "answer", DraftText);
      gl.candidate(CheckRid, CheckCid);
      gl.get(CheckCid, "answer", CheckText);
      .concat("Revise this text: ", DraftText, " Based on: ", CheckText, Prompt);
      gl.call(Bid, "revise", "llm.answer", "ANSWER", Prompt, "answer", "", FinalRid);
      !accepted_final(FinalRid).

// ACHIEVEMENT: print check
+!print_check(CheckRid)
   :  gl.candidate(CheckRid, CheckCid) & gl.get(CheckCid, "answer", CheckText)
   <- .println("[Check] ", CheckText).

// DECOMPOSITION: accept final and print trace
+!accepted_final(FinalRid)
   <- !print_revised(FinalRid);
      gl.candidate(FinalRid, FinalCid);
      !accept_candidate(FinalCid, FinalRid);
      !print_trace(FinalRid);
      !print_complete.

// ACHIEVEMENT: print revised
+!print_revised(FinalRid)
   :  gl.candidate(FinalRid, FinalCid) & gl.get(FinalCid, "answer", FinalText)
   <- .println("[Revised] ", FinalText).

// ACHIEVEMENT: record final acceptance
+!accept_candidate(FinalCid, FinalRid)
   <- gl.accept(FinalCid, "final refined text", _);
      +accepted_final(FinalRid);
      .println("Final candidate - ACCEPTANCE RECORDED").

// ACHIEVEMENT: print trace
+!print_trace(Rid)
   :  gl.explain(Rid, Trace)
   <- .println("");
      .println("[TRACE] ", Trace).

// ACHIEVEMENT: print complete
+!print_complete
   <- .println("=== Demo Complete ===").

// RECOVERY
-!drafted(Prompt)
   :  not accepted_final(_)
   <- .println("Pipeline FAILED").