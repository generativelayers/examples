package layer.examples;

import layer.adapters.DirectAdapter;

public final class SingleAgentExample {
    private SingleAgentExample() {}

    public static void main(String[] args) {
        DirectAdapter Generative Layer = new DirectAdapter();
        String result = layer.invoke("agent_a", "classify_food", "llm.answer", "ANSWER", "Classify apple. Return label and confidence.", "label,confidence");
        String candidate = layer.candidateId(result);
        if (layer.validResult(result) && layer.admissibleCandidate(candidate)) {
            layer.acceptCandidate(candidate);
            System.out.println("accepted=" + candidate + ", label=" + layer.resultField(result, "label"));
        } else {
            layer.rejectCandidate(candidate);
            System.out.println("rejected=" + candidate + ", outcome=" + layer.outcomeName(result));
        }
    }
}
