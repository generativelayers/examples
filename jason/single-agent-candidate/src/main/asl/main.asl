/**
 * Single Agent Candidate — Generative Layer demonstration (Jason).
 *
 * Shows the fundamental Generative Layer flow:
 *   configure → use_provider → invoke → validate → accept/reject
 *
 * Uses the same framework commands as the ASTRA version:
 *   gl.adapters.jason.actions.<command>(...)
 *
 * The agent chooses its own provider and model, then asks the generative layer
 * to classify a food item. No generated output enters beliefs
 * without explicit agent action.
 */

!start.

+!start
   <- .println("=== Generative Layer Single Agent Candidate Demo ===");
      .println("");

      // Step 0 — List available providers
      gl.adapters.jason.actions.providers(Providers);
      .println("[Layer] Available providers: ", Providers);

      // Step 1 — Configure the provider (agent chooses!)
      // Options: gl.adapters.jason.actions.use_provider("gemini");
      //          gl.adapters.jason.actions.use_provider("gemini", "gemini-2.5-flash");
      //          gl.adapters.jason.actions.use_provider("openai", "gpt-4o-mini");
      //          gl.adapters.jason.actions.use_provider("fake");
      //
      // Or fine-grained:
      //   gl.adapters.jason.actions.configure("provider", "gemini");
      //   gl.adapters.jason.actions.configure("model", "gemini-2.5-flash");
      //   gl.adapters.jason.actions.use_provider;
      gl.adapters.jason.actions.use_provider("gemini");

      // Step 2 — Invoke the generative resource
      gl.adapters.jason.actions.invoke(
          "agent_a",                  // agentId
          "classify_food",            // goalId
          "llm.answer",              // bodyId (generative body)
          "ANSWER",                  // affordance type
          "Classify the food item 'apple'. What category does it belong to? (e.g. fruit, vegetable, grain, dairy, meat). Return label (the category) and confidence (0 to 1).",
          "label,confidence",        // required fields for validation
          ResultId                   // output: bound result ID
      );

      .println("[Layer] resultId  = ", ResultId);

      gl.adapters.jason.actions.outcome(ResultId, Outcome);
      .println("[Layer] outcome   = ", Outcome);

      gl.adapters.jason.actions.valid(ResultId, IsValid);
      .println("[Layer] valid     = ", IsValid);

      // Step 3 — Get the candidate handle
      gl.adapters.jason.actions.candidate(ResultId, CandidateId);
      .println("[Layer] candidate = ", CandidateId);

      // Step 4 — Agent deliberation: inspect, then accept or reject
      gl.adapters.jason.actions.admissible(CandidateId, IsAdmissible);

      if (IsValid == true & IsAdmissible == true) {
          gl.adapters.jason.actions.field(ResultId, "label", Label);
          gl.adapters.jason.actions.field(ResultId, "confidence", Confidence);

          .println("");
          .println("[AGENT] Candidate is valid and admissible.");
          .println("[AGENT]   label      = ", Label);
          .println("[AGENT]   confidence = ", Confidence);

          gl.adapters.jason.actions.accept(CandidateId);
          +candidate_accepted(CandidateId);
          +classification(Label, Confidence);

          .println("[AGENT] Candidate ACCEPTED. Belief adopted.");
      } else {
          gl.adapters.jason.actions.reject(CandidateId);
          +candidate_rejected(CandidateId);

          .println("");
          .println("[AGENT] Candidate REJECTED.");
          .println("[AGENT]   outcome = ", Outcome);
      };

      // Step 5 — Trace for auditability
      gl.adapters.jason.actions.trace(ResultId, TraceId);
      .println("");
      .println("[TRACE] traceId = ", TraceId);
      .println("=== Demo Complete ===").
