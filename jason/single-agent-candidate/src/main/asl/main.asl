/**
 * Single Agent Candidate — Generative Layer demonstration (Jason).
 *
 * Shows the fundamental Generative Layer flow:
 *   configure → use_provider → invoke → validate → accept/reject
 *
 * Uses the same GL commands as the ASTRA version:
 *   gl.actions.<command>(...)
 *
 * Provider is configurable via environment:
 *   GL_PROVIDER=gemini  GL_MODEL=gemini-2.5-flash  mvn exec:java
 *   GL_PROVIDER=openai  GL_MODEL=gpt-4o-mini       mvn exec:java
 *   GL_PROVIDER=fake                                mvn exec:java  (default)
 */

!start.

+!start
   <- .println("=== Generative Layer Single Agent Candidate Demo ===");
      .println("");

      // Step 0 — List available providers
      gl.actions.providers(Providers);
      .println("[Layer] Available providers: ", Providers);

      // Step 1 — Configure the provider (reads GL_PROVIDER / GL_MODEL env vars)
      // To override: set GL_PROVIDER=gemini and GL_MODEL=gemini-2.5-flash
      // Default: "fake" for offline testing.
      gl.actions.use_provider;

      // Step 2 — Invoke the generative resource
      gl.actions.invoke(
          "agent_a",                  // agentId
          "classify_food",            // goalId
          "llm.answer",              // bodyId (generative body)
          "ANSWER",                  // affordance type
          "Classify the food item 'apple'. What category does it belong to? (e.g. fruit, vegetable, grain, dairy, meat). Return label (the category) and confidence (0 to 1).",
          "label,confidence",        // required fields for validation
          ResultId                   // output: bound result ID
      );

      .println("[Layer] resultId  = ", ResultId);

      gl.actions.outcome(ResultId, Outcome);
      .println("[Layer] outcome   = ", Outcome);

      gl.actions.valid(ResultId, IsValid);
      .println("[Layer] valid     = ", IsValid);

      // Step 3 — Get the candidate handle
      gl.actions.candidate(ResultId, CandidateId);
      .println("[Layer] candidate = ", CandidateId);

      // Step 4 — Agent deliberation: inspect, then accept or reject
      gl.actions.admissible(CandidateId, IsAdmissible);

      if (IsValid == true & IsAdmissible == true) {
          gl.actions.field(ResultId, "label", Label);
          gl.actions.field(ResultId, "confidence", Confidence);

          .println("");
          .println("[AGENT] Candidate is valid and admissible.");
          .println("[AGENT]   label      = ", Label);
          .println("[AGENT]   confidence = ", Confidence);

          gl.actions.accept(CandidateId);
          +candidate_accepted(CandidateId);
          +classification(Label, Confidence);

          .println("[AGENT] Candidate ACCEPTED. Belief adopted.");
      } else {
          gl.actions.reject(CandidateId);
          +candidate_rejected(CandidateId);

          .println("");
          .println("[AGENT] Candidate REJECTED.");
          .println("[AGENT]   outcome = ", Outcome);
      };

      // Step 5 — Trace for auditability
      gl.actions.trace(ResultId, TraceId);
      .println("");
      .println("[TRACE] traceId = ", TraceId);
      .println("=== Demo Complete ===").
