/**
 * Pattern 7: Majority Voting — Jason
 *
 * Asks 3 providers the same question. Compares labels pairwise.
 * Accepts only if 2+ providers agree on the same label.
 */

!start.

+!start
   <- .println("=== Pattern 7: Majority Voting ===");
      // gl.configure("model", "gemini-2.0-flash");
      // gl.use_provider("gemini");
      gl.configure("endpoint", "https://api.groq.com/openai/v1/chat/completions");
      gl.configure("model", "llama-3.3-70b-versatile");
      gl.configure("apiKeyEnv", "GROQ_API_KEY");
      gl.use_provider("openai");
      gl.ask("agent1", "classify", "Classify: tomato", R1);
      gl.ask("agent1", "classify", "Classify: tomato", R2);
      gl.ask("agent1", "classify", "Classify: tomato", R3);
      gl.field(R1, "label", L1);
      gl.field(R2, "label", L2);
      gl.field(R3, "label", L3);
      .println("Provider 1: ", L1, " | Provider 2: ", L2, " | Provider 3: ", L3);
      !vote(R1, L1, R2, L2, R3, L3).

+!vote(R1, L1, R2, L2, R3, L3)
   :  L1 == L2
   <- gl.candidate(R1, Cid);
      gl.accept(Cid);
      .println("Majority agrees on '", L1, "' -> ACCEPTED");
      .stopMAS.

+!vote(R1, L1, R2, L2, R3, L3)
   :  L1 == L3
   <- gl.candidate(R1, Cid);
      gl.accept(Cid);
      .println("Majority agrees on '", L1, "' -> ACCEPTED");
      .stopMAS.

+!vote(R1, L1, R2, L2, R3, L3)
   :  L2 == L3
   <- gl.candidate(R2, Cid);
      gl.accept(Cid);
      .println("Majority agrees on '", L2, "' -> ACCEPTED");
      .stopMAS.

+!vote(R1, L1, R2, L2, R3, L3)
   :  L1 \== L2 & L1 \== L3 & L2 \== L3
   <- .println("No consensus — all disagree -> NO DECISION");
      .stopMAS.
