setting("model", "gpt-oss-120b"). setting("provider", "cerebras").

refined(Rid) :- accepted_final(true).

!start.

+!start
   <- !configured(true);
      gl.ask("agent1", "step1", "Write short text about photosynthesis", DraftRid);
      !refined(DraftRid).

+!configured(true)
   :  setting("model", M) & setting("provider", P)
   <- gl.configure("model", M);
      gl.use_provider(P).

+!refined(Rid)
   :  refined(Rid)
   <- .println("Already done: ", Rid).

+!refined(DraftRid)
   :  gl.valid(DraftRid, true)
   <- !checked(DraftRid);
      !updated(DraftRid);
      !accepted_final(DraftRid);
      ?refined(DraftRid).

+!refined(DraftRid)
   <- gl.candidate(DraftRid, DraftCid);
      gl.reject(DraftCid);
      .println("First output invalid - REJECTED").

+!checked(DraftRid)
   :  gl.valid(DraftRid, true)
   <- gl.field(DraftRid, "text", DraftText);
      .concat("Check text: ", DraftText, Prompt);
      gl.ask("agent1", "step2", Prompt, CheckRid);
      +check_for(DraftRid, CheckRid);
      +checked(CheckRid).

+!checked(Rid)
   :  checked(Rid)
   <- .println("Already checked").

+!updated(DraftRid)
   :  check_for(DraftRid, CheckRid) & gl.valid(CheckRid, true)
   <- gl.field(DraftRid, "text", DraftText);
      gl.field(CheckRid, "text", CheckText);
      .concat("Text: ", DraftText, " Notes: ", CheckText, Prompt);
      gl.ask("agent1", "step3", Prompt, FinalRid);
      +updated(FinalRid).

+!updated(Rid)
   :  updated(Rid)
   <- .println("Already updated").

+!accepted_final(Rid)
   :  updated(FinalRid) & gl.valid(FinalRid, true)
   <- gl.candidate(FinalRid, Cid);
      gl.accept(Cid);
      +accepted_final(true);
      .println("Final candidate ACCEPTED").

-!refined(Rid)
   <- .println("Pipeline failed: ", Rid).
