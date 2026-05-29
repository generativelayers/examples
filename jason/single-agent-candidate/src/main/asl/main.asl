/**
 * Single Agent Candidate — Generative Layer demonstration (Jason).
 *
 * Shows the fundamental Generative Layer flow:
 *   configure → use_provider → invoke → validate → accept/reject
 *
 * Uses the same GL commands as the ASTRA version:
 *   gl.actions.<command>(...)
 */

!start.

+!start
   <- .println("=== Generative Layer Single Agent Candidate Demo ===");
      .println("");

      // Step 0 — List available providers
      gl.actions.providers(Providers);
      .println("[Layer] Available providers: ", Providers);

      // Step 1 — Configure the provider (reads GL_PROVIDER / GL_MODEL env vars)
      gl.actions.use_provider;
      !classify_food("apple").

+!classify_food(FoodItem)
   <- // Step 2 — Invoke the generative resource
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
      !deliberate_result(ResultId).

// Step 3 — deliberate based on validation results using BDI context-guards:
+!deliberate_result(ResultId)
   :  gl.actions.valid(ResultId, true)
   <- .println("[Layer] valid     = true");
      gl.actions.candidate(ResultId, CandidateId);
      .println("[Layer] candidate = ", CandidateId);
      !deliberate_candidate(ResultId, CandidateId).

+!deliberate_result(ResultId)
   :  gl.actions.valid(ResultId, false)
   <- .println("[Layer] valid     = false");
      !handle_rejection("", ResultId).

// Deliberating candidate with BDI guard conditions:
+!deliberate_candidate(ResultId, CandidateId)
   :  gl.actions.admissible(CandidateId, true)
   <- gl.actions.field(ResultId, "label", Label);
      gl.actions.field(ResultId, "confidence", Confidence);

      .println("");
      .println("[AGENT] Candidate is valid and admissible.");
      .println("[AGENT]   label      = ", Label);
      .println("[AGENT]   confidence = ", Confidence);

      gl.actions.accept(CandidateId);
      +candidate_accepted(CandidateId);
      +classification(Label, Confidence);

      .println("[AGENT] Candidate ACCEPTED. Belief adopted.");
      !print_trace(ResultId).

+!deliberate_candidate(ResultId, CandidateId)
   :  gl.actions.admissible(CandidateId, false)
   <- !handle_rejection(CandidateId, ResultId).

+!handle_rejection(CandidateId, ResultId)
   <- if (CandidateId \== "") {
          gl.actions.reject(CandidateId);
      };
      +candidate_rejected(CandidateId);

      .println("");
      .println("[AGENT] Candidate REJECTED.");
      gl.actions.outcome(ResultId, Outcome);
      .println("[AGENT]   outcome = ", Outcome);
      !print_trace(ResultId).

+!print_trace(ResultId)
   <- gl.actions.trace(ResultId, TraceId);
      .println("");
      .println("[TRACE] traceId = ", TraceId);
      .println("=== Demo Complete ===").
