// Pipeline: start → !artifact_ready → !configured → !assessed → !assess_confidence(high|low|medium) → ?assessed
/**
 * Pattern 3: Confidence Threshold — JaCaMo
 *
 * Extracts the confidence field and makes a tiered decision:
 * high → accept, low → reject + fail, otherwise → escalate.
 */

// setting("model", "gpt-oss-120b"). setting("provider", "cerebras").
setting("model", "gemini-2.5-flash"). setting("provider", "gemini").
threshold("high", "1.0"). threshold("low", "0.0").

// DOMAIN MODEL
assessed(Rid) :- confidence_tier(Rid, _).

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !artifact_ready;
      !configured(true);
      invoke("agent1", "classify", "llm.answer", "ANSWER",
             "Classify: apple", "label,confidence", Rid);
      !assessed(Rid).

// ACHIEVEMENT: create and focus the GL artifact
+!artifact_ready
   <- makeArtifact("gl", "gl.adapter.jacamo.JaCaMoAdapter", [], GlId);
      focus(GlId).

// ACHIEVEMENT: setup (actions only)
+!configured(true)
   :  setting("model", M) & setting("provider", P)
   <- configure("model", M);
      use_provider(P).

// SERENDIPITY
+!assessed(Rid)
   :  assessed(Rid)
   <- .println("Already assessed: ", Rid).

// DECOMPOSITION: bind validity → branch
+!assessed(Rid)
   <- valid(Rid, IsValid);
      !assessed_branch(Rid, IsValid).

// DECOMPOSITION: valid → extract confidence, delegate to tier assessment
+!assessed_branch(Rid, true)
   <- candidate(Rid, Cid);
      field(Rid, "confidence", Conf);
      !assess_confidence(Rid, Cid, Conf).

// ACHIEVEMENT: invalid output
+!assessed_branch(Rid, false)
   <- .println("Invalid output → REJECTED").

// ACHIEVEMENT: high confidence → accept
+!assess_confidence(Rid, Cid, Conf)
   :  threshold("high", Conf)
   <- accept(Cid);
      +accepted(Rid);
      +confidence_tier(Rid, "high");
      ?assessed(Rid);
      .println("High confidence (", Conf, ") → ACCEPTED").

// ACHIEVEMENT: low confidence → reject, fail
+!assess_confidence(Rid, Cid, Conf)
   :  threshold("low", Conf)
   <- reject(Cid);
      +confidence_tier(Rid, "low");
      ?assessed(Rid);
      .println("Low confidence (", Conf, ") → REJECTED");
      .fail.

// ACHIEVEMENT: medium confidence → escalate (catch-all)
+!assess_confidence(Rid, Cid, Conf)
   <- +confidence_tier(Rid, "medium");
      ?assessed(Rid);
      .println("Medium confidence → ESCALATING").

// RECOVERY
-!assessed(Rid)
   <- .println("Assessment FAILED for ", Rid).
