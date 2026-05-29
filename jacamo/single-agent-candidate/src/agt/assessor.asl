/**
 * Assessor Agent — perceives accepted candidates via CArtAgO artifact sensing.
 *
 * Instead of receiving ACL messages (as in Jason/ASTRA examples),
 * the Assessor focuses on the same GL artifact as the Generator.
 * When the Generator calls accept(), the observable property
 * gl_accepted(CandidateId, Fields) appears and is automatically
 * perceived as a new belief — the CArtAgO "sensing" pattern.
 *
 * Same GL flow as ASTRA/Jason two-agent-assessment examples:
 *   perceive candidate → assess → record verdict
 */

// Wait for generator to create the artifact, then focus on it
+!focus_gl
   <- .println("[Assessor] Focusing on shared GL artifact...");
      lookupArtifact("gl", GlId);
      focus(GlId).

// When gl_ready is perceived, the artifact is connected
+gl_ready(true)
   <- .println("[Assessor] Connected to GL artifact. Waiting for candidates...").

// Perceive accepted candidates via artifact sensing (not ACL messages)
+gl_accepted(CandidateId, Fields)
   <- .println("[Assessor] Perceived accepted candidate via artifact:");
      .println("[Assessor]   candidateId = ", CandidateId);
      .println("[Assessor]   fields      = ", Fields);

      // Same assess() call as ASTRA/Jason examples
      .println("[Assessor] Candidate looks valid. Recording ACCEPT assessment.");

      assess("assessor", CandidateId, "ACCEPT", 0.85,
             "Candidate produced valid structured output with required fields.");

      .println("[Assessor] Assessment recorded.");
      .println("[Assessor] === Communication via artifact sensing complete ===").

// Perceive results as they are generated
+gl_result(ResultId, Outcome, Valid)
   <- .println("[Assessor] Perceived result: ", ResultId,
               " outcome=", Outcome, " valid=", Valid).
