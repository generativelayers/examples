/**
 * Assessor Agent β€” peer-reviews a candidate from the Generator.
 *
 * Receives a candidate via KQML achieve, applies domain-specific
 * assessment criteria, then sends the verdict back.
 *
 * The Assessor does NOT adopt or reject the candidate itself β€”
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

// Deliberation using context-guarded plans instead of procedural checks:
+!evaluate(Sender, CandidateId, Label, Confidence)
   :  Label \== "" & Confidence \== ""
   <- .println("[Assessor] Candidate looks valid. Recording ACCEPT assessment.");

      // Record formal assessment in the Generative Layer kernel
      gl.assess(
          "assessor", CandidateId, "ACCEPT", 0.85,
          "Candidate produced valid structured output with required fields."
      );

      // Send verdict back to the Generator
      .send(Sender, tell, verdict(CandidateId, "ACCEPT",
           "Valid output with label and confidence fields present.")).

+!evaluate(Sender, CandidateId, Label, Confidence)
   :  Label == "" | Confidence == ""
   <- .println("[Assessor] Candidate does NOT look valid. Recording REJECT assessment.");

      // Record formal assessment in the Generative Layer kernel β€” rejected
      gl.assess(
          "assessor", CandidateId, "REJECT", 0.90,
          "Candidate failed validation; missing fields."
      );

      // Send verdict back to the Generator
      .send(Sender, tell, verdict(CandidateId, "REJECT",
           "Output failed validation criteria.")).
