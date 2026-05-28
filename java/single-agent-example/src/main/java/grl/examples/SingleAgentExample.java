package grl.examples;

import grl.adapters.DirectAdapter;

public final class SingleAgentExample {
    private SingleAgentExample() {}

    public static void main(String[] args) {
        DirectAdapter grl = new DirectAdapter();
        String result = grl.invoke("agent_a", "classify_food", "llm.answer", "ANSWER", "Classify apple. Return label and confidence.", "label,confidence");
        String candidate = grl.candidateId(result);
        if (grl.validResult(result) && grl.admissibleCandidate(candidate)) {
            grl.acceptCandidate(candidate);
            System.out.println("accepted=" + candidate + ", label=" + grl.resultField(result, "label"));
        } else {
            grl.rejectCandidate(candidate);
            System.out.println("rejected=" + candidate + ", outcome=" + grl.outcomeName(result));
        }
    }
}
