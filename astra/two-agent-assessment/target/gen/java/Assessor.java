/**
 * GENERATED CODE - DO NOT CHANGE
 */

import astra.core.*;
import astra.execution.*;
import astra.event.*;
import astra.messaging.*;
import astra.formula.*;
import astra.lang.*;
import astra.statement.*;
import astra.term.*;
import astra.type.*;
import astra.tr.*;
import astra.reasoner.util.*;
import astra.learn.*;

import astra.learn.library.*;

import java.util.Arrays;

import astra.explanation.*;


public class Assessor extends ASTRAClass {
	public Assessor() {
		setParents(new Class[] {astra.lang.Agent.class});
		addRule(new Rule(
			"Assessor", new int[] {22,9,24,60},
			new MessageEvent(
				new Performative("request"),
				new Variable(Type.STRING, "sender",false),
				new Predicate("review_request", new Term[] {
					new Variable(Type.STRING, "candidateId",false),
					new Variable(Type.STRING, "resultId",false),
					new Variable(Type.STRING, "label",false),
					new Variable(Type.STRING, "confidence",false)
				})
			),
			Predicate.TRUE,
			new Block(
				"Assessor", new int[] {24,59,35,5},
				new Statement[] {
					new ModuleCall("console",
						"Assessor", new int[] {26,8,26,80},
						new Predicate("println", new Term[] {
							Operator.newOperator('+',
								Primitive.newPrimitive("[Assessor] Received assessment request from "),
								new Variable(Type.STRING, "sender")
							)
						}),
						new DefaultModuleCallAdaptor() {
							public boolean inline() {
								return true;
							}

							public boolean invoke(Intention intention, Predicate predicate) {
								return ((astra.lang.Console) intention.getModule("Assessor","console")).println(
									(java.lang.String) intention.evaluate(predicate.getTerm(0))
								);
							}
						}
					),
					new ModuleCall("console",
						"Assessor", new int[] {27,8,27,68},
						new Predicate("println", new Term[] {
							Operator.newOperator('+',
								Primitive.newPrimitive("[Assessor]   candidateId = "),
								new Variable(Type.STRING, "candidateId")
							)
						}),
						new DefaultModuleCallAdaptor() {
							public boolean inline() {
								return true;
							}

							public boolean invoke(Intention intention, Predicate predicate) {
								return ((astra.lang.Console) intention.getModule("Assessor","console")).println(
									(java.lang.String) intention.evaluate(predicate.getTerm(0))
								);
							}
						}
					),
					new ModuleCall("console",
						"Assessor", new int[] {28,8,28,62},
						new Predicate("println", new Term[] {
							Operator.newOperator('+',
								Primitive.newPrimitive("[Assessor]   label       = "),
								new Variable(Type.STRING, "label")
							)
						}),
						new DefaultModuleCallAdaptor() {
							public boolean inline() {
								return true;
							}

							public boolean invoke(Intention intention, Predicate predicate) {
								return ((astra.lang.Console) intention.getModule("Assessor","console")).println(
									(java.lang.String) intention.evaluate(predicate.getTerm(0))
								);
							}
						}
					),
					new ModuleCall("console",
						"Assessor", new int[] {29,8,29,67},
						new Predicate("println", new Term[] {
							Operator.newOperator('+',
								Primitive.newPrimitive("[Assessor]   confidence  = "),
								new Variable(Type.STRING, "confidence")
							)
						}),
						new DefaultModuleCallAdaptor() {
							public boolean inline() {
								return true;
							}

							public boolean invoke(Intention intention, Predicate predicate) {
								return ((astra.lang.Console) intention.getModule("Assessor","console")).println(
									(java.lang.String) intention.evaluate(predicate.getTerm(0))
								);
							}
						}
					),
					new Subgoal(
						"Assessor", new int[] {34,8,35,5},
						new Goal(
							new Predicate("evaluateCandidate", new Term[] {
								new Variable(Type.STRING, "sender"),
								new Variable(Type.STRING, "candidateId"),
								new Variable(Type.STRING, "resultId"),
								new Variable(Type.STRING, "label"),
								new Variable(Type.STRING, "confidence")
							})
						)
					)
				}
			),
			false
		));
		addRule(new Rule(
			"Assessor", new int[] {37,9,39,49},
			new GoalEvent('+',
				new Goal(
					new Predicate("evaluateCandidate", new Term[] {
						new Variable(Type.STRING, "sender",false),
						new Variable(Type.STRING, "candidateId",false),
						new Variable(Type.STRING, "resultId",false),
						new Variable(Type.STRING, "label",false),
						new Variable(Type.STRING, "confidence",false)
					})
				)
			),
			Predicate.TRUE,
			new Block(
				"Assessor", new int[] {39,48,66,5},
				new Statement[] {
					new Declaration(
						new Variable(Type.BOOLEAN, "isValid"),
						"Assessor", new int[] {41,8,66,5},
						new ModuleTerm("grl", Type.BOOLEAN,
							new Predicate("valid", new Term[] {
								new Variable(Type.STRING, "resultId")
							}),
							new ModuleTermAdaptor() {
								public Object invoke(Intention intention, Predicate predicate) {
									return ((grl.adapters.astra.GRLModule) intention.getModule("Assessor","grl")).valid(
										(java.lang.String) intention.evaluate(predicate.getTerm(0))
									);
								}
								public Object invoke(BindingsEvaluateVisitor visitor, Predicate predicate) {
									return ((grl.adapters.astra.GRLModule) visitor.agent().getModule("Assessor","grl")).valid(
										(java.lang.String) visitor.evaluate(predicate.getTerm(0))
									);
								}
							}
						)
					),
					new If(
						"Assessor", new int[] {43,8,66,5},
						new BooleanTermFormula(
							new Variable(Type.BOOLEAN, "isValid")
						),
						new Block(
							"Assessor", new int[] {43,21,54,9},
							new Statement[] {
								new ModuleCall("console",
									"Assessor", new int[] {44,12,44,89},
									new Predicate("println", new Term[] {
										Primitive.newPrimitive("[Assessor] Result is valid. Recording ENDORSED assessment.")
									}),
									new DefaultModuleCallAdaptor() {
										public boolean inline() {
											return true;
										}

										public boolean invoke(Intention intention, Predicate predicate) {
											return ((astra.lang.Console) intention.getModule("Assessor","console")).println(
												(java.lang.String) intention.evaluate(predicate.getTerm(0))
											);
										}
									}
								),
								new ModuleCall("grl",
									"Assessor", new int[] {47,12,48,90},
									new Predicate("assess", new Term[] {
										Primitive.newPrimitive("assessor"),
										new Variable(Type.STRING, "candidateId"),
										Primitive.newPrimitive("ENDORSED"),
										Primitive.newPrimitive(0.85),
										Primitive.newPrimitive("Candidate produced valid structured output with required fields.")
									}),
									new DefaultModuleCallAdaptor() {
										public boolean inline() {
											return true;
										}

										public boolean invoke(Intention intention, Predicate predicate) {
											return ((grl.adapters.astra.GRLModule) intention.getModule("Assessor","grl")).assess(
												(java.lang.String) intention.evaluate(predicate.getTerm(0)),
												(java.lang.String) intention.evaluate(predicate.getTerm(1)),
												(java.lang.String) intention.evaluate(predicate.getTerm(2)),
												(java.lang.Double) intention.evaluate(predicate.getTerm(3)),
												(java.lang.String) intention.evaluate(predicate.getTerm(4))
											);
										}
									}
								),
								new BeliefUpdate('+',
									"Assessor", new int[] {49,12,54,9},
									new Predicate("assessment_recorded", new Term[] {
										new Variable(Type.STRING, "candidateId"),
										Primitive.newPrimitive("ENDORSED")
									})
								),
								new Send("Assessor", new int[] {52,12,53,75},
									new Performative("inform"),
									new Variable(Type.STRING, "sender"),
									new Predicate("verdict", new Term[] {
										new Variable(Type.STRING, "candidateId"),
										Primitive.newPrimitive("ENDORSED"),
										Primitive.newPrimitive("Valid output with label and confidence fields present.")
									})
								)
							}
						),
						new Block(
							"Assessor", new int[] {54,15,66,5},
							new Statement[] {
								new ModuleCall("console",
									"Assessor", new int[] {55,12,55,94},
									new Predicate("println", new Term[] {
										Primitive.newPrimitive("[Assessor] Result is NOT valid. Recording CONTESTED assessment.")
									}),
									new DefaultModuleCallAdaptor() {
										public boolean inline() {
											return true;
										}

										public boolean invoke(Intention intention, Predicate predicate) {
											return ((astra.lang.Console) intention.getModule("Assessor","console")).println(
												(java.lang.String) intention.evaluate(predicate.getTerm(0))
											);
										}
									}
								),
								new ModuleCall("grl",
									"Assessor", new int[] {58,12,59,93},
									new Predicate("assess", new Term[] {
										Primitive.newPrimitive("assessor"),
										new Variable(Type.STRING, "candidateId"),
										Primitive.newPrimitive("CONTESTED"),
										Primitive.newPrimitive(0.90),
										Primitive.newPrimitive("Candidate failed validation; output does not meet quality criteria.")
									}),
									new DefaultModuleCallAdaptor() {
										public boolean inline() {
											return true;
										}

										public boolean invoke(Intention intention, Predicate predicate) {
											return ((grl.adapters.astra.GRLModule) intention.getModule("Assessor","grl")).assess(
												(java.lang.String) intention.evaluate(predicate.getTerm(0)),
												(java.lang.String) intention.evaluate(predicate.getTerm(1)),
												(java.lang.String) intention.evaluate(predicate.getTerm(2)),
												(java.lang.Double) intention.evaluate(predicate.getTerm(3)),
												(java.lang.String) intention.evaluate(predicate.getTerm(4))
											);
										}
									}
								),
								new BeliefUpdate('+',
									"Assessor", new int[] {60,12,65,9},
									new Predicate("assessment_recorded", new Term[] {
										new Variable(Type.STRING, "candidateId"),
										Primitive.newPrimitive("CONTESTED")
									})
								),
								new Send("Assessor", new int[] {63,12,64,55},
									new Performative("inform"),
									new Variable(Type.STRING, "sender"),
									new Predicate("verdict", new Term[] {
										new Variable(Type.STRING, "candidateId"),
										Primitive.newPrimitive("CONTESTED"),
										Primitive.newPrimitive("Output failed validation criteria.")
									})
								)
							}
						)
					)
				}
			),
			false
		));
	}

	public void initialize(astra.core.Agent agent) {
	}

	public Fragment createFragment(astra.core.Agent agent) throws ASTRAClassNotFoundException {
		Fragment fragment = new Fragment(this);
		fragment.addModule("grl",grl.adapters.astra.GRLModule.class,agent);
		fragment.addModule("console",astra.lang.Console.class,agent);
		return fragment;
	}

	public static void main(String[] args) {
		Scheduler.setStrategy(new TestSchedulerStrategy());
		ListTerm argList = new ListTerm();
		for (String arg: args) {
			argList.add(Primitive.newPrimitive(arg));
		}

		String name = java.lang.System.getProperty("astra.name", "main");
		try {
			astra.core.Agent agent = new Assessor().newInstance(name);
			if (!agent.isRunnable()) {
				java.lang.System.out.println("WARNING: No +!main(...) rule has been defined for main agent type: Assessor");
			}
			agent.initialize(new Goal(new Predicate("main", new Term[] { argList })));
			Scheduler.schedule(agent);
		} catch (AgentCreationException e) {
			e.printStackTrace();
		} catch (ASTRAClassNotFoundException e) {
			e.printStackTrace();
		};
	}
}
