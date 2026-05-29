/**
 * Pattern 6: Belief Consistency — Jason
 *
 * Compares the LLM output against existing beliefs.
 * Matches → confirm, Contradicts → reject, New → adopt.
 */

category("apple", "fruit"). category("carrot", "vegetable").

!start.

+!start
   <- .println("=== Pattern 6: Belief Consistency ===");
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
   <- gl.field(Rid, "label", Label);
      gl.candidate(Rid, Cid);
      !check_belief(Cid, "apple", Label).

+!check_belief(Cid, Item, Label)
   :  category(Item, Label)
   <- gl.accept(Cid);
      .println("Matches belief: ", Item, " = ", Label, " -> CONFIRMED");
      .stopMAS.

+!check_belief(Cid, Item, Label)
   :  category(Item, Existing) & Label \== Existing
   <- gl.reject(Cid);
      .println("Contradicts belief! Expected ", Existing, " got ", Label, " -> REJECTED");
      .stopMAS.

+!check_belief(Cid, Item, Label)
   :  not category(Item, _)
   <- gl.accept(Cid);
      .println("No prior belief for ", Item, " -> NEW KNOWLEDGE: ", Label);
      .stopMAS.
