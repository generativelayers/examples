/**
 * Single Agent Candidate β€” Generative Layer demonstration (Jason).
 *
 * Shows the fundamental Generative Layer flow:
 *   configure β†’ use_provider β†’ invoke β†’ validate β†’ accept/reject
 *
 * Uses the same GL commands as the ASTRA version:
 *   gl.<command>(...)
 */

!start.

+!start
   <- .println("=== Generative Layer Single Agent Candidate Demo ===");
      .println("");

      // Step 0 β€” List available providers
      gl.providers(Providers);
      .println("[Layer] Available providers: ", Providers);

      // Step 1 β€” Configure the provider (reads GL_PROVIDER / GL_MODEL env vars)
      gl.use_provider;
      !classify_food("apple").

+!classify_food(FoodItem)
   <- // Step 2 β€” Invoke the generative resource
      gl.invoke(
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

// Step 3 β€” deliberate based on validation results using BDI context-guards:
+!deliberate_result(ResultId)
   :  gl.valid(ResultId, true)
   <- .println("[Layer] valid     = true");
      gl.candidate(ResultId, CandidateId);
      .println("[Layer] candidate = ", CandidateId);
      !deliberate_candidate(ResultId, CandidateId).

+!deliberate_result(ResultId)
   :  gl.valid(ResultId, false)
   <- .println("[Layer] valid     = false");
      !handle_rejection("", ResultId).

// Deliberating candidate with BDI guard conditions:
+!deliberate_candidate(ResultId, CandidateId)
   :  gl.admissible(CandidateId, true)
   <- gl.field(ResultId, "label", Label);
      gl.field(ResultId, "confidence", Confidence);

      .println("");
      .println("[AGENT] Candidate is valid and admissible.");
      .println("[AGENT]   label      = ", Label);
      .println("[AGENT]   confidence = ", Confidence);

      gl.accept(CandidateId);
      +candidate_accepted(CandidateId);
      +classification(Label, Confidence);

      .println("[AGENT] Candidate ACCEPTED. Belief adopted.");
      !print_trace(ResultId).

+!deliberate_candidate(ResultId, CandidateId)
   :  gl.admissible(CandidateId, false)
   <- !handle_rejection(CandidateId, ResultId).

+!handle_rejection(CandidateId, ResultId)
   <- if (CandidateId \== "") {
          gl.reject(CandidateId);
      };
      +candidate_rejected(CandidateId);

      .println("");
      .println("[AGENT] Candidate REJECTED.");
      gl.outcome(ResultId, Outcome);
      .println("[AGENT]   outcome = ", Outcome);
      !print_trace(ResultId).

+!print_trace(ResultId)
   <- gl.trace(ResultId, TraceId);
      .println("");
      .println("[TRACE] traceId = ", TraceId);
      .println("=== Demo Complete ===").
