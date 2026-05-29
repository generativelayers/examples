/**
 * Generator Agent β€” produces a candidate via the shared JaCaMo GL artifact.
 *
 * Uses CArtAgO artifact operations instead of internal actions.
 * When the Generator accepts a candidate, the observable property
 * gl_accepted(CandidateId, FieldsCsv) is perceived by ALL agents
 * focused on the artifact β€” no ACL messages needed.
 *
 * Same GL flow as ASTRA/Jason two-agent-assessment examples:
 *   use_provider β†’ invoke β†’ valid β†’ field β†’ accept/reject + assess
 *
 * Provider is configurable via GL_PROVIDER / GL_MODEL env vars.
 */

!start.

+!start
   <- .println("[Generator] Starting candidate generation...");

      // Create the shared GL artifact β€” other agents will focus on it
      makeArtifact("gl", "gl.adapter.jacamo.JaCaMoAdapter", [], GlId);
      focus(GlId);



      // Step 1 β€” Configure provider from environment (default: fake)
      configure("model", "llama-3.3-70b-versatile");

      use_provider("groq");
      !generate_candidate("mango").

+!generate_candidate(FoodItem)
   <- // Step 2 β€” Invoke the generative resource (same args as ASTRA/Jason)
      invoke("generator", "classify_food", "llm.answer", "ANSWER",
             "Classify 'mango' as a food type. Return label and confidence.",
             "label,confidence", ResultId);
      .println("[Generator] resultId  = ", ResultId);
      !process_generation(ResultId).

// Step 3 β€” deliberate based on validation results using BDI context-guards:
+!process_generation(ResultId)
   :  valid(ResultId, true)
   <- outcome(ResultId, Outcome);
      .println("[Generator] outcome   = ", Outcome);
      .println("[Generator] valid     = true");
      candidate(ResultId, CandidateId);

      field(ResultId, "label", Label);
      field(ResultId, "confidence", Confidence);

      .println("[Generator] Candidate is valid and admissible.");
      .println("[Generator]   label      = ", Label);
      .println("[Generator]   confidence = ", Confidence);

      // Accept the candidate
      accept(CandidateId);
      .println("[Generator] Candidate ACCEPTED. Belief adopted.").

+!process_generation(ResultId)
   :  valid(ResultId, false)
   <- outcome(ResultId, Outcome);
      .println("[Generator] outcome   = ", Outcome);
      .println("[Generator] valid     = false");
      candidate(ResultId, CandidateId);

      if (CandidateId \== "") {
          reject(CandidateId);
      };
      .println("[Generator] Candidate invalid. REJECTED immediately.").

// The Generator also perceives its own acceptance
+gl_accepted(CandidateId, Fields)
   <- .println("[Generator] Observed gl_accepted: ", CandidateId, " -> ", Fields).
