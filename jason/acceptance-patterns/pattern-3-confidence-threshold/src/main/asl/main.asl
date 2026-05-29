/**
 * Pattern 3: Confidence Threshold — Jason
 *
 * Extracts the confidence field and makes a tiered decision:
 * high (1.0) → accept, low (0.0) → reject, otherwise → escalate.
 */

!start.

+!start
   <- .println("=== Pattern 3: Confidence Threshold ===");
      // gl.configure("model", "gemini-2.0-flash");
      // gl.use_provider("gemini");
      gl.configure("endpoint", "https://api.groq.com/openai/v1/chat/completions");
      gl.configure("model", "llama-3.3-70b-versatile");
      gl.configure("apiKeyEnv", "GROQ_API_KEY");
      gl.use_provider("openai");
      gl.ask("agent1", "classify", "Classify: apple", Rid);
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
