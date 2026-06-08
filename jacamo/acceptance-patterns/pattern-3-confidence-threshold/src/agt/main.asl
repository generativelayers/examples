setting("model", "gemini-2.5-flash"). setting("provider", "gemini").

assessed(Rid) :- accepted(Rid).
assessed(Rid) :- rejected(Rid).
assessed(Rid) :- escalated(Rid).

!start.

+!start
   <- !artifact_ready;
      !configured(true);
      invoke("agent1", "classify", "llm.answer", "ANSWER", "Classify apple. Return label and confidence_tier high medium or low.", "label,confidence_tier", Rid);
      !assessed(Rid).

+!artifact_ready
   <- makeArtifact("gl", "gl.jacamo.GL", [], GlId);
      focus(GlId).

+!configured(true)
   :  setting("model", M) & setting("provider", P)
   <- configure("model", M);
      use_provider(P).

+!assessed(Rid)
   :  assessed(Rid)
   <- .println("Already assessed: ", Rid).

+!assessed(Rid)
   <- valid(Rid, IsValid);
      !assessed_branch(Rid, IsValid).

+!assessed_branch(Rid, true)
   <- candidate(Rid, Cid);
      field(Rid, "confidence_tier", Tier);
      !assess_confidence(Rid, Cid, Tier).

+!assessed_branch(Rid, false)
   <- candidate(Rid, Cid);
      reject(Cid);
      +rejected(Rid);
      .println("Invalid output - REJECTED").

+!assess_confidence(Rid, Cid, "high")
   <- accept(Cid);
      +accepted(Rid);
      +confidence_tier(Rid, "high");
      ?assessed(Rid);
      .println("High confidence - ACCEPTED").

+!assess_confidence(Rid, Cid, "low")
   <- reject(Cid);
      +rejected(Rid);
      +confidence_tier(Rid, "low");
      ?assessed(Rid);
      .println("Low confidence - REJECTED").

+!assess_confidence(Rid, Cid, Tier)
   <- +escalated(Rid);
      +confidence_tier(Rid, Tier);
      ?assessed(Rid);
      .println("Confidence tier ", Tier, " - ESCALATING").

-!assessed(Rid)
   <- .println("Assessment FAILED for ", Rid).
