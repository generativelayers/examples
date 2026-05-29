/**
 * Pattern 6: Belief Consistency — JaCaMo
 *
 * Compares the LLM output against existing beliefs.
 * Matches → confirm, Contradicts → reject, New → adopt.
 */

category("apple", "fruit"). category("carrot", "vegetable").

!start.

+!start
   <- .println("=== Pattern 6: Belief Consistency ===");
      makeArtifact("gl", "gl.adapter.jacamo.JaCaMoAdapter", [], GlId);
      focus(GlId);
      // configure("model", "gemini-2.0-flash");
      // use_provider("gemini");
      configure("endpoint", "https://api.groq.com/openai/v1/chat/completions");
      configure("model", "llama-3.3-70b-versatile");
      configure("apiKeyEnv", "GROQ_API_KEY");
      use_provider("openai");
      ask("agent1", "classify", "Classify: apple", Rid);
      valid(Rid, IsValid);
      !decide(Rid, IsValid).

+!decide(Rid, true)
   <- field(Rid, "label", Label);
      candidate(Rid, Cid);
      !check_belief(Cid, "apple", Label).

+!decide(Rid, false)
   <- .println("Invalid output -> REJECTED");
      .stopMAS.

+!check_belief(Cid, Item, Label)
   :  category(Item, Label)
   <- accept(Cid);
      .println("Matches belief: ", Item, " = ", Label, " -> CONFIRMED");
      .stopMAS.

+!check_belief(Cid, Item, Label)
   :  category(Item, Existing) & Label \== Existing
   <- reject(Cid);
      .println("Contradicts belief! Expected ", Existing, " got ", Label, " -> REJECTED");
      .stopMAS.

+!check_belief(Cid, Item, Label)
   :  not category(Item, _)
   <- accept(Cid);
      .println("No prior belief for ", Item, " -> NEW KNOWLEDGE: ", Label);
      .stopMAS.
