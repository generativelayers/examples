// Pipeline: start → !configured → !consistent → !belief_checked(match|contradict|new) → ?consistent
/**
 * Pattern 6: Belief Consistency — Jason
 *
 * Compares the LLM output against existing beliefs.
 * Matches → confirm, Contradicts → reject, New → adopt.
 */

// Requires: GL ontology beliefs (gl_status, gl_candidate_type, gl_verdict_type, ...)
//   See: https://github.com/generativelayers/examples/tree/main/jason/shared

// setting("model", "gpt-oss-120b"). setting("provider", "cerebras").
setting("model", "gemini-2.5-flash"). setting("provider", "gemini").
category("apple", "fruit"). category("carrot", "vegetable").

// DOMAIN MODEL
consistent(Rid) :- belief_checked(Rid).

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !configured(true);
      gl.ask("agent1", "classify", "Classify: apple", Rid);
      !consistent(Rid).

// ACHIEVEMENT: setup (actions only)
+!configured(true)
   :  setting("model", M) & setting("provider", P)
   <- gl.configure("model", M);
      gl.use_provider(P).

// SERENDIPITY
+!consistent(Rid)
   :  consistent(Rid)
   <- .println("Already checked: ", Rid).

// DECOMPOSITION: valid → check belief
+!consistent(Rid)
   :  gl.valid(Rid, true)
   <- gl.field(Rid, "label", Label);
      gl.candidate(Rid, Cid);
      !belief_checked("apple", Label, Cid);
      +belief_checked(Rid);
      ?consistent(Rid).

// ACHIEVEMENT: invalid
+!consistent(Rid)
   <- .println("Invalid output → REJECTED").

// ACHIEVEMENT: matches existing belief → confirm
+!belief_checked(Item, Label, Cid)
   :  category(Item, Label)
   <- gl.accept(Cid);
      .println("Matches belief: ", Item, " = ", Label, " → CONFIRMED").

// ACHIEVEMENT: contradicts existing belief → reject
+!belief_checked(Item, Label, Cid)
   :  category(Item, Existing) & Label \== Existing
   <- gl.reject(Cid);
      .println("Contradicts belief! Expected ", Existing, " got ", Label, " → REJECTED").

// ACHIEVEMENT: no prior belief → adopt new knowledge
+!belief_checked(Item, Label, Cid)
   :  not category(Item, _)
   <- gl.accept(Cid);
      +category(Item, Label);
      .println("No prior belief for ", Item, " → NEW KNOWLEDGE: ", Label).

// RECOVERY
-!consistent(Rid)
   <- .println("Consistency check FAILED for ", Rid).
