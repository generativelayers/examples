// Pipeline: start → !configured → !inspected → !known_category
/**
 * Pattern 2: Content Inspection — Jason
 *
 * After validation, inspects the LLM output against the agent's
 * own knowledge base. Accepts only if the label is a known category.
 */

// Requires: GL ontology beliefs (gl_status, gl_candidate_type, gl_verdict_type, ...)
//   See: https://github.com/generativelayers/examples/tree/main/jason/shared

// setting("model", "gpt-oss-120b"). setting("provider", "cerebras").
setting("model", "gpt-oss-120b"). setting("provider", "cerebras").
known("fruit"). known("vegetable"). known("grain").

// DOMAIN MODEL
inspected(Rid) :- accepted(Rid).
inspected(Rid) :- rejected(Rid).

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !configured(true);
      gl.invoke("agent1", "classify", "llm.answer", "ANSWER",
               "Based on the Agent beliefs, classify: apple",
               "label,confidence", Rid);
      !inspected(Rid);
      .stopMAS.

// ACHIEVEMENT: setup (actions only)
+!configured(true)
   :  setting("model", M) & setting("provider", P)
   <- gl.configure("model", M);
      gl.use_provider(P).

// SERENDIPITY
+!inspected(Rid)
   :  inspected(Rid)
   <- .println("Already inspected: ", Rid).

// DECOMPOSITION: valid → check content. Do not mark accepted here.
// Acceptance/rejection is performed only by the known_category branches.
+!inspected(Rid)
   :  gl.valid(Rid, true)
   <- gl.candidate(Rid, Cid);
      gl.field(Rid, "label", Label);
      !known_category(Rid, Cid, Label);
      ?inspected(Rid).

// ACHIEVEMENT: invalid → reject the concrete candidate
+!inspected(Rid)
   <- gl.candidate(Rid, Cid);
      gl.reject(Cid);
      +rejected(Rid);
      .println("Invalid output → REJECTED").

// ACHIEVEMENT: known → accept
+!known_category(Rid, Cid, Label)
   :  known(Label)
   <- gl.accept(Cid);
      +accepted(Rid);
      .println("Known category '", Label, "' → ACCEPTED").

// ACHIEVEMENT: unknown → reject
+!known_category(Rid, Cid, Label)
   :  not known(Label)
   <- gl.reject(Cid);
      +rejected(Rid);
      .println("Unknown category '", Label, "' → REJECTED").

// RECOVERY
-!inspected(Rid)
   <- .println("Inspection FAILED for ", Rid).
