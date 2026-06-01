// Pipeline: start → !artifact_ready → !configured → !inspected → !known_category → ?inspected
/**
 * Pattern 2: Content Inspection — JaCaMo
 *
 * After validation, inspects the LLM output against the agent's
 * own knowledge base. Accepts only if the label is a known category.
 */

// setting("model", "gpt-oss-120b"). setting("provider", "cerebras").
setting("model", "gemini-2.5-flash"). setting("provider", "gemini").
known("fruit"). known("vegetable"). known("grain").

// DOMAIN MODEL
inspected(Rid) :- accepted(Rid).

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !artifact_ready;
      !configured(true);
      invoke("agent1", "classify", "llm.answer", "ANSWER",
             "Based on the Agent beliefs, classify: apple",
             "label,confidence", Rid);
      !inspected(Rid).

// ACHIEVEMENT: create and focus the GL artifact
+!artifact_ready
   <- makeArtifact("gl", "gl.adapter.jacamo.JaCaMoAdapter", [], GlId);
      focus(GlId).

// ACHIEVEMENT: setup (actions only)
+!configured(true)
   :  setting("model", M) & setting("provider", P)
   <- configure("model", M);
      use_provider(P).

// SERENDIPITY
+!inspected(Rid)
   :  inspected(Rid)
   <- .println("Already inspected: ", Rid).

// DECOMPOSITION: bind validity → branch
+!inspected(Rid)
   <- valid(Rid, IsValid);
      !inspected_branch(Rid, IsValid).

// DECOMPOSITION: valid → check content
+!inspected_branch(Rid, true)
   <- candidate(Rid, Cid);
      field(Rid, "label", Label);
      !known_category(Cid, Label);
      +accepted(Rid);
      ?inspected(Rid).

// ACHIEVEMENT: invalid
+!inspected_branch(Rid, false)
   <- .println("Invalid output → REJECTED").

// ACHIEVEMENT: known → accept
+!known_category(Cid, Label)
   :  known(Label)
   <- accept(Cid);
      .println("Known category '", Label, "' → ACCEPTED").

// ACHIEVEMENT: unknown → reject
+!known_category(Cid, Label)
   :  not known(Label)
   <- reject(Cid);
      .println("Unknown category '", Label, "' → REJECTED").

// RECOVERY
-!inspected(Rid)
   <- .println("Inspection FAILED for ", Rid).
