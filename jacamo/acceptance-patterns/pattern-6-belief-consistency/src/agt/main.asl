// Pipeline: start → !artifact_ready → !configured → !consistent → !belief_checked(match|contradict|new) → ?consistent
/**
 * Pattern 6: Belief Consistency — JaCaMo
 *
 * Compares the LLM output against existing beliefs.
 * Matches → confirm, Contradicts → reject, New → adopt.
 */

// setting("model", "gpt-oss-120b"). setting("provider", "cerebras").
setting("model", "gemini-2.5-flash"). setting("provider", "gemini").
category("apple", "fruit"). category("carrot", "vegetable").

// DOMAIN MODEL
consistent(Rid) :- belief_checked(Rid).

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !artifact_ready;
      !configured(true);
      ask("agent1", "classify", "Classify: apple", Rid);
      !consistent(Rid).

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
+!consistent(Rid)
   :  consistent(Rid)
   <- .println("Already checked: ", Rid).

// DECOMPOSITION: bind validity → branch
+!consistent(Rid)
   <- valid(Rid, IsValid);
      !consistent_branch(Rid, IsValid).

// DECOMPOSITION: valid → check belief
+!consistent_branch(Rid, true)
   <- field(Rid, "label", Label);
      candidate(Rid, Cid);
      !belief_checked("apple", Label, Cid);
      +belief_checked(Rid);
      ?consistent(Rid).

// ACHIEVEMENT: invalid
+!consistent_branch(Rid, false)
   <- .println("Invalid output → REJECTED").

// ACHIEVEMENT: matches existing belief → confirm
+!belief_checked(Item, Label, Cid)
   :  category(Item, Label)
   <- accept(Cid);
      .println("Matches belief: ", Item, " = ", Label, " → CONFIRMED").

// ACHIEVEMENT: contradicts existing belief → reject
+!belief_checked(Item, Label, Cid)
   :  category(Item, Existing) & Label \== Existing
   <- reject(Cid);
      .println("Contradicts belief! Expected ", Existing, " got ", Label, " → REJECTED").

// ACHIEVEMENT: no prior belief → adopt new knowledge
+!belief_checked(Item, Label, Cid)
   :  not category(Item, _)
   <- accept(Cid);
      +category(Item, Label);
      .println("No prior belief for ", Item, " → NEW KNOWLEDGE: ", Label).

// RECOVERY
-!consistent(Rid)
   <- .println("Consistency check FAILED for ", Rid).
