/**
 * Pattern 2: Content Inspection — Jason
 *
 * After validation, inspects the LLM output against the agent's
 * own knowledge base. Accepts only if the label is a known category.
 */

known("fruit"). known("vegetable"). known("grain").

!start.

+!start
   <- .println("=== Pattern 2: Content Inspection ===");
      gl.configure("model", "gpt-oss-120b");
      gl.use_provider("cerebras");
      gl.ask("agent1", "classify", "Classify: apple", Rid);
      !decide(Rid).

+!decide(Rid)
   :  gl.valid(Rid, true)
   <- gl.field(Rid, "label", Label);
      gl.candidate(Rid, Cid);
      !check_content(Cid, Label).

+!check_content(Cid, Label)
   :  known(Label)
   <- gl.accept(Cid);
      .println("Known category '", Label, "' -> ACCEPTED");
      .stopMAS.

+!check_content(Cid, Label)
   :  not known(Label)
   <- gl.reject(Cid);
      .println("Unknown category '", Label, "' -> REJECTED");
      .stopMAS.
