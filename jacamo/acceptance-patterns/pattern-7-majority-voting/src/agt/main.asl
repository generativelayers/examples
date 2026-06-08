consensus_reached(true) :- consensus_label(_).

!start.

+!start
   <- !artifact_ready;
      configure("model", "gemini-2.5-flash");
      use_provider("gemini");
      !vote_cast(1);
      configure("model", "gpt-oss-120b");
      use_provider("cerebras");
      !vote_cast(2);
      configure("model", "gemini-2.5-flash");
      use_provider("gemini");
      !vote_cast(3);
     