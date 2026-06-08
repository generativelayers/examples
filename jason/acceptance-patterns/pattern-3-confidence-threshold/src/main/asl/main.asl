setting("model", "gemini-2.5-flash"). setting("provider", "gemini").

assessed(Rid) :- accepted(Rid).
assessed(Rid) :- rejected(Rid).
assessed(Rid) :- escalated(Rid).

!start.

+!start
   <- !configured(true);
      gl.invoke("agent1", "classify", "llm.answer", "ANSWER",
               "Classify: apple. Return label and confidence_tier: high, medium, or low.",
               "label,confidence_tier", Rid);
      !assessed(Rid).

+!configured(true)
   :  setting("model", M) & setting("provider", P)
   <- gl.configure("model", M);
      gl.use_provider(P).

+!assessed(Rid)
   :  assessed(Rid)
   <- .println("Already assessed: ", Rid).

+!assessed(Rid)
   :  gl.valid(Rid, true)
   <- gl.candidate(Rid, Cid);
      gl.field(Rid, "confidence_tier", Tier);
      !assess_confidence(Rid, Cid, Tier).

+!assessed(Rid)
   <- gl.candidate(Rid, Cid);
      gl.reject(Cid);
      +rejected(Rid);
      .println("Invalid output - REJECTED").

+!assess_confidence(Rid, Cid, "high")
   <- gl.accept(Cid);
      +accepted(Rid);
      +confidence_tier(Rid, "high");
      ?assessed(Rid);
      .println("High confidence - ACCEPTED").

+!assess_confidence(Rid, Cid, "low")
   <- gl.reject(Cid);
      +rejected(Rid);
      +confidence_tier(Rid, "low");
      ?assessed(Rid);
      .println("Low confidence - REJECTED");
      .fail.

+!assess_confidence(Rid, Cid, Tier)
   <- +escalated(Rid);
      +confidence_tier(Rid, Tier);
      ?assessed(Rid);
      .println("Confidence tier ", Tier, " - ESCALATING").

-!assessed(Rid)
   <- .println("Assessment FAILED for ", Rid).
