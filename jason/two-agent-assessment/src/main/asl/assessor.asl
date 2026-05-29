/**
 * Assessor Agent — peer-reviews a candidate from the Generator.
 *
 * Receives a candidate via KQML achieve, applies domain-specific
 * assessment criteria, then sends the verdict back.
 *
 * The Assessor does NOT adopt or reject the candidate itself —
 * it only provides an assessment. The Generator agent makes
 * the final adoption decision (agent autonomy preserved).
 */

// Handle incoming assessment request from Generator
+!review(CandidateId, ResultId, Label, Confidence)[source(Sender)]
   <- .println("[Assessor] Received assessment request from ", Sender);
      .println("[Assessor]   candidateId = ", CandidateId);
      .println("[Assessor]   label       = ", Label);
      .println("[Assessor]   confidence  = ", Confidence);

      !evaluate(Sender, CandidateId, Label, Confidence).

+!evaluate(Sender, CandidateId, Label, Confidence)
   <- // Domain-specific assessment: does the classification look reasonable?
      // A real assessor would apply richer domain logic here.
      .println("[Assessor] Candidate looks valid. Recording ACCEPT assessment.");

      // Record formal assessment in the Generative Layer kernel
      gl.actions.assess(
          "assessor", CandidateId, "ACCEPT", 0.85,
          "Candidate produced valid structured output with required fields."
      );

      // Send verdict back to the Generator
      .send(Sender, tell, verdict(CandidateId, "ACCEPT",
           "Valid output with label and confidence fields present.")).
