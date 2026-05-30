/**
 * Pattern 3: Confidence Threshold — JaCaMo
 *
 * Extracts the confidence field and makes a tiered decision:
 * high (1.0) → accept, low (0.0) → reject, otherwise → escalate.
 */

!start.

+!start
   <- .println("=== Pattern 3: Confidence Threshold ===");
      makeArtifact("gl", "gl.adapter.jacamo.JaCaMoAdapter", [], GlId);
      focus(GlId);
      configure("model", "gpt-oss-120b");
      use_provider("cerebras");
      ask("agent1", "classify", "Classify: apple", Rid);
      valid(Rid, IsValid);
      !decide(Rid, IsValid).

+!decide(Rid, true)
   <- candidate(Rid, Cid);
      field(Rid, "confidence", Conf);
      !assess(Cid, Conf).

+!decide(Rid, false)
   <- .println("Invalid output -> REJECTED");
      .stopMAS.

+!assess(Cid, "1.0")
   <- accept(Cid);
      .println("High confidence (1.0) -> ACCEPTED");
      .stopMAS.

+!assess(Cid, "0.0")
   <- reject(Cid);
      .println("Low confidence (0.0) -> REJECTED");
      .stopMAS.

+!assess(Cid, Conf)
   <- .println("Medium confidence (", Conf, ") -> ESCALATING");
      .stopMAS.
