// Pipeline: start > !artifact_ready > !configured > !inspected > !known_category > ?inspected
/**
 * Pattern 2: Content Inspection - JaCaMo
 *
 * After validation, inspects the LLM output against the agent's
 * own knowledge base. Accepts only if the label is a known category.
 */

// setting("model", "gpt-oss-120b"). setting("provider", "cerebras").
setting("model", "gpt-oss-120b"). setting("provider", "cerebras").
known("fruit"). known("vegetable"). known("grain").

// DOMAIN MODEL
inspected(Rid) :- accepted(Rid).
inspected(Rid) :- rejected(Rid).

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !artifact_ready;
      !configured(true);
      invoke("agent1", "classify", "llm.answer", "ANSWER",
             "Based on the Agent beliefs, classify: apple",
             "label,confidence", Rid);
      !inspected(Rid);
      .stopMAS.

// ACHIEVEMENT: create and focus the GL artifact
+!artifact_ready
   <- makeArtifact("gl", "gl.jacamo.GL", [], GlId);
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

// DECOMPOSITION: bind validity > branch
+!inspected(Rid)
   <- valid(Rid, IsValid);
      !inspected_branch(Rid, IsValid).

// DECOMPOSITION: valid > check content. Do not mark accepted here.
// Acceptance/rejection is performed only by the known_category branches.
+!inspected_branch(Rid, true)
   <- candidate(Rid, Cid);
      field(Rid, "label", Label);
      !known_category(Rid, Cid, Label);
      ?inspected(Rid).

// ACHIEVEMENT: invalid > reject the concrete candidate
+!inspected_branch(Rid, false)
   <- candidate(Rid, Cid);
      reject(Cid);
      +rejected(Rid);
      .println("Invalid output > REJECTED").

// ACHIEVEMENT: known > accept
+!known_category(Rid, Cid, Label)
   :  known(Label)
   <- accept(Cid);
      +accepted(Rid);
      .println("Known category '", Label, "' > ACCEPTED").

// ACHIEVEMENT: unknown > reject
+!known_category(Rid, Cid, Label)
   :  not known(Label)
   <- reject(Cid);
      +rejected(Rid);
      .println("Unknown category '", Label, "' > REJECTED").

// RECOVERY
-!inspected(Rid)
   <- .println("Inspection FAILED for ", Rid).
