// Pipeline: start → !artifact_ready → !banner → !configured → !classified(food) → !invoked → !deliberated → accept|reject
/**
 * Single Agent Candidate — Generative Layer demonstration (JaCaMo).
 *
 * Shows the fundamental Generative Layer flow using CArtAgO artifacts:
 *   artifact_ready → configure → invoke → validate → accept/reject → trace
 */

// setting("model", "gpt-oss-120b"). setting("provider", "cerebras").
setting("model", "gpt-oss-120b"). setting("provider", "cerebras").

// DOMAIN MODEL
classified(Item, Label, Conf) :- accepted(_) & classified(Item, Label, Conf).

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !artifact_ready;
      !banner;
      !configured(true);
      !classified("apple");
      .stopMAS.

// ACHIEVEMENT: create and focus the GL artifact
+!artifact_ready
   <- makeArtifact("gl", "gl.jacamo.GL", [], GlId);
      focus(GlId).

// ACHIEVEMENT: display banner (actions only)
+!banner
   <- providers(Providers);
      .println("=== Generative Layer Single Agent Candidate Demo (JaCaMo) ===");
      .println("");
      .println("[Layer] Available providers: ", Providers).

// ACHIEVEMENT: setup (actions only)
+!configured(true)
   :  setting("model", M) & setting("provider", P)
   <- configure("model", M);
      use_provider(P).

// DECOMPOSITION: classify = invoke + deliberate
+!classified(FoodItem)
   <- .concat("Classify the food item '", FoodItem,
              "'. What category does it belong to? (e.g. fruit, vegetable, grain, dairy, meat). Return label (the category) and confidence (0 to 1).",
              Prompt);
      invoke("generator", "classify_food", "llm.answer", "ANSWER",
             Prompt, "label,confidence", Rid);
      !invoked(Rid).

// DECOMPOSITION: bind rid once → log → deliberate
+!invoked(Rid)
   <- !log_invocation(Rid);
      !deliberated(Rid).

// ACHIEVEMENT: log invocation result (actions only)
+!log_invocation(Rid)
   <- .println("[Layer] resultId  = ", Rid).

// SERENDIPITY: already accepted
+!deliberated(Rid)
   :  accepted(Rid)
   <- .println("[AGENT] Already deliberated: ", Rid).

// DECOMPOSITION: bind validity → branch
+!deliberated(Rid)
   <- valid(Rid, IsValid);
      !deliberated_branch(Rid, IsValid).

// DECOMPOSITION: valid → check admissibility → accept/reject + trace
+!deliberated_branch(Rid, true)
   <- admissible(Rid, IsAdmissible);
      candidate(Rid, Cid);
      !deliberated_admissible(Rid, Cid, IsAdmissible);
      !print_trace(Rid).

// DECOMPOSITION: invalid → reject + trace
+!deliberated_branch(Rid, false)
   <- !rejected_candidate("", Rid);
      !print_trace(Rid).

// ACHIEVEMENT: admissible → accept
+!deliberated_admissible(Rid, Cid, true)
   <- !accepted_candidate(Rid, Cid).

// ACHIEVEMENT: not admissible → reject
+!deliberated_admissible(Rid, Cid, false)
   <- !rejected_candidate(Cid, Rid).

// ACHIEVEMENT: accept (actions only)
+!accepted_candidate(Rid, Cid)
   <- field(Rid, "label", Label);
      field(Rid, "confidence", Confidence);
      .println("");
      .println("[AGENT] Candidate is valid and admissible.");
      .println("[AGENT]   label      = ", Label);
      .println("[AGENT]   confidence = ", Confidence);
      accept(Cid);
      +accepted(Cid);
      +classified("food", Label, Confidence);
      .println("[AGENT] Candidate ACCEPTED. Belief adopted.").

// ACHIEVEMENT: reject (actions only)
+!rejected_candidate(Cid, Rid)
   <- if (Cid \== "") {
          reject(Cid);
      };
      outcome(Rid, Outcome);
      +rejected(Cid, Outcome);
      .println("");
      .println("[AGENT] Candidate REJECTED.");
      .println("[AGENT]   outcome = ", Outcome).

// ACHIEVEMENT: print trace (actions only)
+!print_trace(Rid)
   <- trace(Rid, TraceId);
      .println("");
      .println("[TRACE] traceId = ", TraceId);
      .println("=== Demo Complete ===").

// RECOVERY
-!classified(FoodItem)
   <- .println("[AGENT] Classification FAILED for ", FoodItem).

-!invoked(Rid)
   <- .println("[AGENT] Invocation handling FAILED for ", Rid).

-!deliberated(Rid)
   <- .println("[AGENT] Deliberation FAILED for ", Rid).
