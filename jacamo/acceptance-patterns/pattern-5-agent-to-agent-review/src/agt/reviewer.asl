// Pipeline: +!review_request → +review_pending → !review_decided → send(approve|reject) → ?review_decided
/**
 * Pattern 5: Agent-to-Agent Review — JaCaMo (Reviewer)
 *
 * Pure BDI reviewer — no LLM involved.
 * Checks the label against its own beliefs and responds.
 */

known_food("fruit"). known_food("vegetable"). known_food("grain").

// DOMAIN MODEL
review_decided(Cid) :- review_approved(Cid).

// ACHIEVEMENT: incoming request → store and deliberate
+!review_request(Label, Cid)
   <- +review_pending(Label, Cid);
      !review_decided(Cid).

// SERENDIPITY
+!review_decided(Cid)
   :  review_decided(Cid)
   <- .println("[Reviewer] Already decided for ", Cid).

// ACHIEVEMENT: known → approve
+!review_decided(Cid)
   :  review_pending(Label, Cid) & known_food(Label)
   <- .send(main, tell, review_approved(Cid));
      +review_approved(Cid);
      ?review_decided(Cid);
      .println("[Reviewer] '", Label, "' is known → APPROVED").

// ACHIEVEMENT: unknown → reject
+!review_decided(Cid)
   :  review_pending(Label, Cid) & not known_food(Label)
   <- .send(main, tell, review_rejected(Cid, "not in knowledge base"));
      .println("[Reviewer] '", Label, "' is unknown → DISAPPROVED").

// RECOVERY
-!review_decided(Cid)
   <- .println("[Reviewer] Decision FAILED for ", Cid).
