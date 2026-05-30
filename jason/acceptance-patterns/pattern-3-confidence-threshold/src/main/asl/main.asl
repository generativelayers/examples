/**
 * Pattern 3: Confidence Threshold — Jason
 *
 * Extracts the confidence field and makes a tiered decision:
 * high (1.0) → accept, low (0.0) → reject, otherwise → escalate.
 */

!start.

+!start
   <- .println("=== Pattern 3: Confidence Threshold ===");
      gl.configure("model", "gpt-oss-120b");
      gl.use_provider("cerebras");
      gl.invoke("agent1", "classify", "llm.answer", "ANSWER", "Classify: apple", "label,confidence", Rid);
      !decide(Rid).

+!decide(Rid)
   :  gl.valid(Rid, true)
   <- gl.candidate(Rid, Cid);
      gl.field(Rid, "confidence", Conf);
      !assess(Cid, Conf).

+!assess(Cid, "1.0")
   <- gl.accept(Cid);
      .println("High confidence (1.0) -> ACCEPTED");
      .stopMAS.

+!assess(Cid, "0.0")
   <- gl.reject(Cid);
      .println("Low confidence (0.0) -> REJECTED");
      .stopMAS.

+!assess(Cid, Conf)
   <- .println("Medium confidence (", Conf, ") -> ESCALATING");
      .stopMAS.
