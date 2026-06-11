// Pipeline: start > !artifact_ready > !configured > !refined > !checked > !updated > !accepted_final
/**
 * Pattern 8: Iterative Refinement - JaCaMo
 *
 * Generate, check, refine, and accept only the final validated
 * candidate. Free-text outputs use the framework's text field.
 */

// setting("model", "gpt-oss-120b"). setting("provider", "cerebras").
setting("model", "gpt-oss-120b"). setting("provider", "cerebras").

refined(Rid) :- accepted_final(true).

!start.

+!start
   <- !artifact_ready;
      !configured(true);
      ask("agent1", "step1", "Write short text about photosynthesis", DraftRid);
      !refined(DraftRid);
      .stopMAS.

+!artifact_ready
   <- makeArtifact("gl", "gl.jacamo.GL", [], GlId);
      focus(GlId).

+!configured(true)
   :  setting("model", M) & setting("provider", P)
   <- configure("model", M);
      use_provider(P).

+!refined(Rid)
   :  refined(Rid)
   <- .println("Already done: ", Rid).

+!refined(Rid)
   <- valid(Rid, IsValid);
      !refined_branch(Rid, IsValid).

+!refined_branch(DraftRid, true)
   <- !checked(DraftRid);
      !updated(DraftRid);
      !accepted_final(DraftRid);
      ?refined(DraftRid).

+!refined_branch(DraftRid, false)
   <- candidate(DraftRid, DraftCid);
      reject(DraftCid);
      .println("First output invalid - REJECTED").

+!checked(DraftRid)
   <- field(DraftRid, "text", DraftText);
      .concat("Check text: ", DraftText, Prompt);
      ask("agent1", "step2", Prompt, CheckRid);
      valid(CheckRid, CheckValid);
      !checked_branch(DraftRid, CheckRid, CheckValid).

+!checked_branch(DraftRid, CheckRid, true)
   <- +check_for(DraftRid, CheckRid);
      +checked(CheckRid).

+!checked_branch(DraftRid, CheckRid, false)
   <- candidate(CheckRid, CheckCid);
      reject(CheckCid);
      .println("Check output invalid - REJECTED").

+!checked(Rid)
   :  checked(Rid)
   <- .println("Already checked").

+!updated(DraftRid)
   :  check_for(DraftRid, CheckRid)
   <- field(DraftRid, "text", DraftText);
      field(CheckRid, "text", CheckText);
      .concat("Text: ", DraftText, " Notes: ", CheckText, Prompt);
      ask("agent1", "step3", Prompt, FinalRid);
      valid(FinalRid, FinalValid);
      !updated_branch(FinalRid, FinalValid).

+!updated_branch(FinalRid, true)
   <- +updated(FinalRid).

+!updated_branch(FinalRid, false)
   <- candidate(FinalRid, FinalCid);
      reject(FinalCid);
      .println("Final output invalid - REJECTED").

+!updated(Rid)
   :  updated(Rid)
   <- .println("Already updated").

+!accepted_final(Rid)
   :  updated(FinalRid)
   <- candidate(FinalRid, Cid);
      accept(Cid);
      +accepted_final(true);
      .println("Final candidate ACCEPTED").

-!refined(Rid)
   <- .println("Pipeline failed: ", Rid).
