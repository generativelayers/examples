/**
 * gl_ontology.asl " Shared Generative Layer beliefs for Jason MAS.
 *
 * All GL-aware Jason agents should include this file:
 *   { include("gl_ontology.asl") }
 *
 * This provides a shared vocabulary for candidates, assessments,
 * and verdicts " the Jason equivalent of the ASTRA GLOntology agent.
 *
 * These are initial beliefs that describe the GL type system.
 * Agents can query these to validate message content at runtime.
 */

// "" GL Type Definitions (as initial beliefs) 

// Candidate status values
gl_status("PROPOSED").
gl_status("VALIDATED").
gl_status("ASSESSED").
gl_status("ACCEPTED_BY_AGENT").
gl_status("REJECTED_BY_AGENT").
gl_status("INVALID").
gl_status("ESCALATED").

// Candidate types
gl_candidate_type("CANDIDATE_ANSWER").
gl_candidate_type("TASK_DECOMPOSITION").
gl_candidate_type("ACTION_PROPOSAL").
gl_candidate_type("TOOL_CALL_PROPOSAL").
gl_candidate_type("GROUNDED_FACT").
gl_candidate_type("MEMORY_USE").
gl_candidate_type("REFLECTION_NOTE").
gl_candidate_type("EXPLANATION").

// Assessment verdicts
gl_verdict_type("ACCEPT").
gl_verdict_type("REJECT").
gl_verdict_type("UNCERTAIN").
gl_verdict_type("NEEDS_EVIDENCE").
gl_verdict_type("NEEDS_HUMAN").
gl_verdict_type("RETRY").

// Affordance types
gl_affordance("ANSWER").
gl_affordance("CLASSIFY").
gl_affordance("SUMMARISE").
gl_affordance("GROUND_FACT").
gl_affordance("DECOMPOSE_GOAL").
gl_affordance("PROPOSE_TOOL_CALL").
gl_affordance("PROPOSE_ACTION").
gl_affordance("RETRIEVE_MEMORY").
gl_affordance("REFLECT").
gl_affordance("CRITIQUE").
gl_affordance("ASSESS").
gl_affordance("EXPLAIN").
gl_affordance("ESCALATE").

// Outcome types
gl_outcome_type("SUCCESS").
gl_outcome_type("GOVERNANCE_DENIED").
gl_outcome_type("GOVERNANCE_ESCALATED").
gl_outcome_type("PROVIDER_FAILED").
gl_outcome_type("INVALID_OUTPUT").

// "" GL Validation Rules """""""""""""""""""""""""""""""""""""""""

// Check if a verdict is a valid GL verdict
gl_valid_verdict(V) :- gl_verdict_type(V).

// Check if a status is a valid GL candidate status
gl_valid_status(S) :- gl_status(S).

// Check if an affordance is a valid GL affordance
gl_valid_affordance(A) :- gl_affordance(A).
