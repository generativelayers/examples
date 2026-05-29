/**
 * Pattern 5: Agent-to-Agent Review — JaCaMo (Reviewer)
 *
 * Pure BDI reviewer — no LLM involved.
 * Checks the label against its own beliefs and responds.
 */

known_food("fruit"). known_food("vegetable"). known_food("grain").

+!review(Label, Rid)
   :  known_food(Label)
   <- .println("[Reviewer] '", Label, "' is known -> APPROVED");
      .send(main, tell, approved(Rid)).

+!review(Label, Rid)
   :  not known_food(Label)
   <- .println("[Reviewer] '", Label, "' is unknown -> DISAPPROVED");
      .send(main, tell, disapproved(Rid, "not in knowledge base")).
