// Pipeline: start → !banner → !configured → !classified(food) → !invoked → !deliberated → accept|reject
/**
 * Single Agent Candidate — Generative Layer demonstration (Jason).
 *
 * Shows the fundamental Generative Layer flow:
 *   configure → invoke → validate → accept/reject → trace
 */

// Requires: GL ontology beliefs (gl_status, gl_candidate_type, gl_verdict_type, ...)
//   See: https://github.com/generativelayers/examples/tree/main/jason/shared

// setting("model", "gpt-oss-120b"). setting("provider", "cerebras").
setting("model", "gemini-2.5-flash"). setting("provider", "gemini").

// DOMAIN MODEL
classified(Item, Label, Conf) :- accepted(_) & classified(Item, Label, Conf).

!start.

// DECOMPOSITION: start only adopts subgoals
+!start
   <- !banner;
      !configured(true);
      !classified("apple").

// ACHIEVEMENT: display banner (actions only)
+!banner
   <- gl.providers(Providers);
      .println("=== Generative Layer Single Agent Candidate Demo ===");
      .println("");
      .println("[Layer] Available providers: ", Providers).

// ACHIEVEMENT: setup (actions only)
+!configured(true)
   :  setting("model", M) & setting("provider", P)
   <- gl.configure("model", M);
      gl.use_provider(P).

// DECOMPOSITION: classify = invoke + deliberate
+!classified(FoodItem)
   <- .concat("Classify the food item '", FoodItem,
              "'. What category does it belong to? (e.g. fruit, vegetable, grain, dairy, meat). Return label (the category) and confidence (0 to 1).",
              Prompt);
      gl.invoke("agent_a", "classify_food", "llm.answer", "ANSWER",
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

// DECOMPOSITION: valid + admissible → accept + trace
+!deliberated(Rid)
   :  gl.valid(Rid, true) & gl.admissible(Rid, true)
   <- gl.candidate(Rid, Cid);
      !accepted_candidate(Rid, Cid);
      !print_trace(Rid).

// DECOMPOSITION: valid but not admissible → reject + trace
+!deliberated(Rid)
   :  gl.valid(Rid, true) & gl.admissible(Rid, false)
   <- gl.candidate(Rid, Cid);
      !rejected_candidate(Cid, Rid);
      !print_trace(Rid).

// DECOMPOSITION: invalid → reject + trace
+!deliberated(Rid)
   :  gl.valid(Rid, false)
   <- !rejected_candidate("", Rid);
      !print_trace(Rid).

// ACHIEVEMENT: accept (actions only)
+!accepted_candidate(Rid, Cid)
   <- gl.field(Rid, "label", Label);
      gl.field(Rid, "confidence", Confidence);
      .println("");
      .println("[AGENT] Candidate is valid and admissible.");
      .println("[AGENT]   label      = ", Label);
      .println("[AGENT]   confidence = ", Confidence);
      gl.accept(Cid);
      +accepted(Cid);
      +classified("food", Label, Confidence);
      .println("[AGENT] Candidate ACCEPTED. Belief adopted.").

// ACHIEVEMENT: reject (actions only)
+!rejected_candidate(Cid, Rid)
   <- if (Cid \== "") {
          gl.reject(Cid);
      };
      gl.outcome(Rid, Outcome);
      +rejected(Cid, Outcome);
      .println("");
      .println("[AGENT] Candidate REJECTED.");
      .println("[AGENT]   outcome = ", Outcome).

// ACHIEVEMENT: print trace (actions only)
+!print_trace(Rid)
   <- gl.trace(Rid, TraceId);
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
