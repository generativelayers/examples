setting("model", "gpt-oss-120b"). setting("provider", "cerebras").
category("apple", "fruit"). category("carrot", "vegetable").

consistent(Rid) :- confirmed(Rid).
consistent(Rid) :- rejected(Rid).
consistent(Rid) :- adopted_new(Rid).

!start.

+!start
   <- !artifact_ready;
      !configured(true);
      ask("agent1", "classify", "Classify: apple", Rid);
      !consistent(Rid);
      .stopMAS.

+!artifact_ready
   <- makeArtifact("gl", "gl.jacamo.GL", [], GlId);
      focus(GlId).

+!configured(true)
   :  setting("model", M) & setting("provider", P)
   <- configure("model", M);
      use_provider(P).

+!consistent(Rid)
   :  consistent(Rid)
   <- .println("Already checked: ", Rid).

+!consistent(Rid)
   <- valid(Rid, IsValid);
      !consistent_branch(Rid, IsValid).

+!consistent_branch(Rid, true)
   <- field(Rid, "label", Label);
      candidate(Rid, Cid);
      !belief_checked(Rid, "apple", Label, Cid).

+!consistent_branch(Rid, false)
   <- candidate(Rid, Cid);
      reject(Cid);
      +rejected(Rid);
      .println("Invalid output - REJECTED").

+!belief_checked(Rid, Item, Label, Cid)
   :  category(Item, Label)
   <- accept(Cid);
      +confirmed(Rid);
      .println("Matches belief - CONFIRMED").

+!belief_checked(Rid, Item, Label, Cid)
   :  category(Item, Existing) & Label \== Existing
   <- reject(Cid);
      +rejected(Rid);
      .println("Contradicts belief - REJECTED").

+!belief_checked(Rid, Item, Label, Cid)
   :  not category(Item, _)
   <- accept(Cid);
      +category(Item, Label);
      +adopted_new(Rid);
      .println("No prior belief - NEW KNOWLEDGE").

-!consistent(Rid)
   <- .println("Consistency check FAILED for ", Rid).
