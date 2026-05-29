/**
 * Pattern 1: Simple Validation — JaCaMo
 *
 * The simplest governance pattern: accept valid output, reject invalid.
 * Demonstrates the fundamental valid/invalid context-guard branching.
 */

!start.

+!start
   <- .println("=== Pattern 1: Simple Validation ===");
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
   <- candidate(Rid, Cid);
      accept(Cid);
      field(Rid, "label", Label);
      .println("Valid output -> ACCEPTED: ", Label);
      .stopMAS.

+!decide(Rid, false)
   <- .println("Invalid output -> REJECTED");
      .stopMAS.
