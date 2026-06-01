// Pipeline: start → !configured → !inspected → !known_category → ?inspected
/**
 * Pattern 2: Content Inspection — Jason
 *
 * After validation, inspects the LLM output against the agent's
 * own knowledge base. Accepts only if the label is a known category.
 */

// Requires: GL ontology beliefs (gl_status, gl_candidate_type, gl_verdict_type, ...)
//   See: https://github.com/generativelayers/examples/tree/main/jason/shared

// setting("model", "gpt-oss-120b"). setting("provider", "cerebras").
setting("model", "gemini-2.5-flash"). setting("provider", "gemini").
known("fruit"). known("vegetable"). known("grain").

// DOMAIN MODEL
inspected(Rid) :- accepted(Rid).

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !configured(true);
      gl.invoke("agent1", "classify", "llm.answer", "ANSWER",
               "Based on the Agent beliefs, classify: apple",
               "label,confidence", Rid);
      !inspected(Rid).

// ACHIEVEMENT: setup (actions only)
+!configured(true)
   :  setting("model", M) & setting("provider", P)
   <- gl.configure("model", M);
      gl.use_provider(P).

// SERENDIPITY
+!inspected(Rid)
   :  inspected(Rid)
   <- .println("Already inspected: ", Rid).

// DECOMPOSITION: valid → check content
+!inspected(Rid)
   :  gl.valid(Rid, true)
   <- gl.candidate(Rid, Cid);
      gl.field(Rid, "label", Label);
      !known_category(Cid, Label);
      +accepted(Rid);
      ?inspected(Rid).

// ACHIEVEMENT: invalid
+!inspected(Rid)
   <- .println("Invalid output → REJECTED").

// ACHIEVEMENT: known → accept
+!known_category(Cid, Label)
   :  known(Label)
   <- gl.accept(Cid);
      .println("Known category '", Label, "' → ACCEPTED").

// ACHIEVEMENT: unknown → reject
+!known_category(Cid, Label)
   :  not known(Label)
   <- gl.reject(Cid);
      .println("Unknown category '", Label, "' → REJECTED").

// RECOVERY
-!inspected(Rid)
   <- .println("Inspection FAILED for ", Rid).
