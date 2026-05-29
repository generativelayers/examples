/**
 * Pattern 2: Content Inspection — JaCaMo
 *
 * After validation, inspects the LLM output against the agent's
 * own knowledge base. Accepts only if the label is a known category.
 */

known("fruit"). known("vegetable"). known("grain").

!start.

+!start
   <- .println("=== Pattern 2: Content Inspection ===");
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
      !check_content(Cid, Label).

+!decide(Rid, false)
   <- .println("Invalid output -> REJECTED");
      .stopMAS.

+!check_content(Cid, Label)
   :  known(Label)
   <- accept(Cid);
      .println("Known category '", Label, "' -> ACCEPTED");
      .stopMAS.

+!check_content(Cid, Label)
   :  not known(Label)
   <- reject(Cid);
      .println("Unknown category '", Label, "' -> REJECTED");
      .stopMAS.
