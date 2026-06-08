setting("model", "gemini-2.5-flash"). setting("provider", "gemini").
category("apple", "fruit"). category("carrot", "vegetable").

consistent(Rid) :- confirmed(Rid).
consistent(Rid) :- rejected(Rid).
consistent(Rid) :- adopted_new(Rid).

!start.

+!start
   <- !configured(true);
      gl.ask("agent1", "classify", "Classify: apple", Rid);
      !consistent(Rid).

+!configured(true)
   :  setting("model", M) & setting("provider", P)
   <- gl.configure("model", M);
      gl.use_provider(P).

+!consistent(Rid)
   :  consistent(Rid)
   <- .println("Already checked: ", Rid).

+!consistent(Rid)
   :  gl.valid(Rid, true)
   <- gl.field(Rid, "label", Label);
      gl.candidate(Rid, Cid);
      !belief_checked(Rid, "apple", Label, Cid).

+!consistent(Rid)
   <- gl.candidate(Rid, Cid);
      gl.reject(Cid);
      +rejected(Rid);
      .println("Invalid output - REJECTED").

+!belief_checked(Rid, Item, Label, Cid)
   :  category(Item, Label)
   <- gl.accept(Cid);
      +confirmed(Rid);
      .println("Matches belief - CONFIRMED").

+!belief_checked(Rid, Item, Label, Cid)
   :  category(Item, Existing) & Label \== Existing
   <- gl.reject(Cid);
      +rejected(Rid);
      .println("Contradicts belief - REJECTED").

+!belief_checked(Rid, Item, Label, Cid)
   :  not category(Item, _)
   <- gl.accept(Cid);
      +category(Item, Label);
      +adopted_new(Rid);
      .println("No prior belief - NEW KNOWLEDGE").

-!consistent(Rid)
   <- .println("Consistency check FAILED for ", Rid).
