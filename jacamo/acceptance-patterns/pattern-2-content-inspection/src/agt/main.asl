// Pipeline: start → !artifact_ready → !configured → !inspected → !known_category → ?inspected
/**
 * Pattern 2: Content Inspection — JaCaMo
 *
 * After validation, inspects the LLM output against the agent's
 * own knowledge base. Accepts only if the label is a known category.
 */

// setting("model", "gpt-oss-120b"). setting("provider", "cere