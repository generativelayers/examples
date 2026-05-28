package generativelayers.examples;

import generativelayers.adapters.DirectAdapter;

public final class SingleAgentExample {
    private SingleAgentExample() {}

    public static void main(String[] args) {
        DirectAdapter Generative Layer = new DirectAdapter();
        String result = gl.invoke("agent_a", "classify_food", "llm.answer", "ANSWER", "Classify apple. Return label and confidence.", "label,confidence");
        String candidate = gl.candidateId(result);
        if (layer.validResult(result) && gl.admissibleCandidate(candidate)) {
            gl.acceptCandidate(candidate);
            System.out.println("accepted=" + candidate + ", label=" + gl.resultField(result, "label"));
        } else {
            gl.rejectCandidate(candidate);
            System.out.println("rejected=" + candidate + ", outcome=" + gl.outcomeName(result));
        }
    }
}
