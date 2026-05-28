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


public class Main extends ASTRAClass {
	public Main() {
		setParents(new Class[] {astra.lang.Agent.class});
		addRule(new Rule(
			"Main", new int[] {21,9,21,28},
			new GoalEvent('+',
				new Goal(
					new Predicate("main", new Term[] {
						new Variable(Type.LIST, "args",false)
					})
				)
			),
			Predicate.TRUE,
			new Block(
				"Main", new int[] {21,27,94,5},
				new Statement[] {
					new ModuleCall("console",
						"Main", new int[] {22,8,22,66},
						new Predicate("println", new Term[] {
							Primitive.newPrimitive("=== GRL Single Agent Candidate Demo ===")
						}),
						new DefaultModuleCallAdaptor() {
							public boolean inline() {
								return true;
							}

							public boolean invoke(Intention intention, Predicate predicate) {
								return ((astra.lang.Console) intention.getModule("Main","console")).println(
									(java.lang.String) intention.evaluate(predicate.getTerm(0))
								);
							}
						}
					),
					new ModuleCall("console",
						"Main", new int[] {23,8,23,27},
						new Predicate("println", new Term[] {
							Primitive.newPrimitive("")
						}),
						new DefaultModuleCallAdaptor() {
							public boolean inline() {
								return true;
							}

							public boolean invoke(Intention intention, Predicate predicate) {
								return ((astra.lang.Console) intention.getModule("Main","console")).println(
									(java.lang.String) intention.evaluate(predicate.getTerm(0))
								);
							}
						}
					),
					new ModuleCall("console",
						"Main", new int[] {26,8,26,72},
						new Predicate("println", new Term[] {
							Operator.newOperator('+',
								Primitive.newPrimitive("[GRL] Available providers: "),
								new ModuleTerm("grl", Type.STRING,
									new Predicate("providers", new Term[] {}),
									new ModuleTermAdaptor() {
										public Object invoke(Intention intention, Predicate predicate) {
											return ((grl.adapters.astra.GRLModule) intention.getModule("Main","grl")).providers(
											);
										}
										public Object invoke(BindingsEvaluateVisitor visitor, Predicate predicate) {
											return ((grl.adapters.astra.GRLModule) visitor.agent().getModule("Main","grl")).providers(
											);
										}
									}
								)
							)
						}),
						new DefaultModuleCallAdaptor() {
							public boolean inline() {
								return true;
							}

							public boolean invoke(Intention intention, Predicate predicate) {
								return ((astra.lang.Console) intention.getModule("Main","console")).println(
									(java.lang.String) intention.evaluate(predicate.getTerm(0))
								);
							}
						}
					),
					new ModuleCall("grl",
						"Main", new int[] {42,8,42,33},
						new Predicate("useProvider", new Term[] {
							Primitive.newPrimitive("gemini")
						}),
						new DefaultModuleCallAdaptor() {
							public boolean inline() {
								return true;
							}

							public boolean invoke(Intention intention, Predicate predicate) {
								return ((grl.adapters.astra.GRLModule) intention.getModule("Main","grl")).useProvider(
									(java.lang.String) intention.evaluate(predicate.getTerm(0))
								);
							}
						}
					),
					new Declaration(
						new Variable(Type.STRING, "resultId"),
						"Main", new int[] {45,8,94,5},
						new ModuleTerm("grl", Type.STRING,
							new Predicate("invoke", new Term[] {
								Primitive.newPrimitive("agent_a"),
								Primitive.newPrimitive("classify_food"),
								Primitive.newPrimitive("llm.answer"),
								Primitive.newPrimitive("ANSWER"),
								Primitive.newPrimitive("Classify the food item 'apple'. What category does it belong to? (e.g. fruit, vegetable, grain, dairy, meat). Return label (the category) and confidence (0 to 1)."),
								Primitive.newPrimitive("label,confidence")
							}),
							new ModuleTermAdaptor() {
								public Object invoke(Intention intention, Predicate predicate) {
									return ((grl.adapters.astra.GRLModule) intention.getModule("Main","grl")).invoke(
										(java.lang.String) intention.evaluate(predicate.getTerm(0)),
										(java.lang.String) intention.evaluate(predicate.getTerm(1)),
										(java.lang.String) intention.evaluate(predicate.getTerm(2)),
										(java.lang.String) intention.evaluate(predicate.getTerm(3)),
										(java.lang.String) intention.evaluate(predicate.getTerm(4)),
										(java.lang.String) intention.evaluate(predicate.getTerm(5))
									);
								}
								public Object invoke(BindingsEvaluateVisitor visitor, Predicate predicate) {
									return ((grl.adapters.astra.GRLModule) visitor.agent().getModule("Main","grl")).invoke(
										(java.lang.String) visitor.evaluate(predicate.getTerm(0)),
										(java.lang.String) visitor.evaluate(predicate.getTerm(1)),
										(java.lang.String) visitor.evaluate(predicate.getTerm(2)),
										(java.lang.String) visitor.evaluate(predicate.getTerm(3)),
										(java.lang.String) visitor.evaluate(predicate.getTerm(4)),
										(java.lang.String) visitor.evaluate(predicate.getTerm(5))
									);
								}
							}
						)
					),
					new ModuleCall("console",
						"Main", new int[] {54,8,54,56},
						new Predicate("println", new Term[] {
							Operator.newOperator('+',
								Primitive.newPrimitive("[GRL] resultId  = "),
								new Variable(Type.STRING, "resultId")
							)
						}),
						new DefaultModuleCallAdaptor() {
							public boolean inline() {
								return true;
							}

							public boolean invoke(Intention intention, Predicate predicate) {
								return ((astra.lang.Console) intention.getModule("Main","console")).println(
									(java.lang.String) intention.evaluate(predicate.getTerm(0))
								);
							}
						}
					),
					new ModuleCall("console",
						"Main", new int[] {55,8,55,69},
						new Predicate("println", new Term[] {
							Operator.newOperator('+',
								Primitive.newPrimitive("[GRL] outcome   = "),
								new ModuleTerm("grl", Type.STRING,
									new Predicate("outcome", new Term[] {
										new Variable(Type.STRING, "resultId")
									}),
									new ModuleTermAdaptor() {
										public Object invoke(Intention intention, Predicate predicate) {
											return ((grl.adapters.astra.GRLModule) intention.getModule("Main","grl")).outcome(
												(java.lang.String) intention.evaluate(predicate.getTerm(0))
											);
										}
										public Object invoke(BindingsEvaluateVisitor visitor, Predicate predicate) {
											return ((grl.adapters.astra.GRLModule) visitor.agent().getModule("Main","grl")).outcome(
												(java.lang.String) visitor.evaluate(predicate.getTerm(0))
											);
										}
									}
								)
							)
						}),
						new DefaultModuleCallAdaptor() {
							public boolean inline() {
								return true;
							}

							public boolean invoke(Intention intention, Predicate predicate) {
								return ((astra.lang.Console) intention.getModule("Main","console")).println(
									(java.lang.String) intention.evaluate(predicate.getTerm(0))
								);
							}
						}
					),
					new Declaration(
						new Variable(Type.BOOLEAN, "isValid"),
						"Main", new int[] {56,8,94,5},
						new ModuleTerm("grl", Type.BOOLEAN,
							new Predicate("valid", new Term[] {
								new Variable(Type.STRING, "resultId")
							}),
							new ModuleTermAdaptor() {
								public Object invoke(Intention intention, Predicate predicate) {
									return ((grl.adapters.astra.GRLModule) intention.getModule("Main","grl")).valid(
										(java.lang.String) intention.evaluate(predicate.getTerm(0))
									);
								}
								public Object invoke(BindingsEvaluateVisitor visitor, Predicate predicate) {
									return ((grl.adapters.astra.GRLModule) visitor.agent().getModule("Main","grl")).valid(
										(java.lang.String) visitor.evaluate(predicate.getTerm(0))
									);
								}
							}
						)
					),
					new ModuleCall("console",
						"Main", new int[] {57,8,57,55},
						new Predicate("println", new Term[] {
							Operator.newOperator('+',
								Primitive.newPrimitive("[GRL] valid     = "),
								new Variable(Type.BOOLEAN, "isValid")
							)
						}),
						new DefaultModuleCallAdaptor() {
							public boolean inline() {
								return true;
							}

							public boolean invoke(Intention intention, Predicate predicate) {
								return ((astra.lang.Console) intention.getModule("Main","console")).println(
									(java.lang.String) intention.evaluate(predicate.getTerm(0))
								);
							}
						}
					),
					new Declaration(
						new Variable(Type.STRING, "candidateId"),
						"Main", new int[] {60,8,94,5},
						new ModuleTerm("grl", Type.STRING,
							new Predicate("candidate", new Term[] {
								new Variable(Type.STRING, "resultId")
							}),
							new ModuleTermAdaptor() {
								public Object invoke(Intention intention, Predicate predicate) {
									return ((grl.adapters.astra.GRLModule) intention.getModule("Main","grl")).candidate(
										(java.lang.String) intention.evaluate(predicate.getTerm(0))
									);
								}
								public Object invoke(BindingsEvaluateVisitor visitor, Predicate predicate) {
									return ((grl.adapters.astra.GRLModule) visitor.agent().getModule("Main","grl")).candidate(
										(java.lang.String) visitor.evaluate(predicate.getTerm(0))
									);
								}
							}
						)
					),
					new ModuleCall("console",
						"Main", new int[] {61,8,61,59},
						new Predicate("println", new Term[] {
							Operator.newOperator('+',
								Primitive.newPrimitive("[GRL] candidate = "),
								new Variable(Type.STRING, "candidateId")
							)
						}),
						new DefaultModuleCallAdaptor() {
							public boolean inline() {
								return true;
							}

							public boolean invoke(Intention intention, Predicate predicate) {
								return ((astra.lang.Console) intention.getModule("Main","console")).println(
									(java.lang.String) intention.evaluate(predicate.getTerm(0))
								);
							}
						}
					),
					new Declaration(
						new Variable(Type.BOOLEAN, "isAdmissible"),
						"Main", new int[] {64,8,94,5},
						new ModuleTerm("grl", Type.BOOLEAN,
							new Predicate("admissible", new Term[] {
								new Variable(Type.STRING, "candidateId")
							}),
							new ModuleTermAdaptor() {
								public Object invoke(Intention intention, Predicate predicate) {
									return ((grl.adapters.astra.GRLModule) intention.getModule("Main","grl")).admissible(
										(java.lang.String) intention.evaluate(predicate.getTerm(0))
									);
								}
								public Object invoke(BindingsEvaluateVisitor visitor, Predicate predicate) {
									return ((grl.adapters.astra.GRLModule) visitor.agent().getModule("Main","grl")).admissible(
										(java.lang.String) visitor.evaluate(predicate.getTerm(0))
									);
								}
							}
						)
					),
					new If(
						"Main", new int[] {66,8,94,5},
						new AND(
							new BooleanTermFormula(
								new Variable(Type.BOOLEAN, "isValid")
							),
							new BooleanTermFormula(
								new Variable(Type.BOOLEAN, "isAdmissible")
							)
						),
						new Block(
							"Main", new int[] {66,36,80,9},
							new Statement[] {
								new Declaration(
									new Variable(Type.STRING, "label"),
									"Main", new int[] {67,12,80,9},
									new ModuleTerm("grl", Type.STRING,
										new Predicate("field", new Term[] {
											new Variable(Type.STRING, "resultId"),
											Primitive.newPrimitive("label")
										}),
										new ModuleTermAdaptor() {
											public Object invoke(Intention intention, Predicate predicate) {
												return ((grl.adapters.astra.GRLModule) intention.getModule("Main","grl")).field(
													(java.lang.String) intention.evaluate(predicate.getTerm(0)),
													(java.lang.String) intention.evaluate(predicate.getTerm(1))
												);
											}
											public Object invoke(BindingsEvaluateVisitor visitor, Predicate predicate) {
												return ((grl.adapters.astra.GRLModule) visitor.agent().getModule("Main","grl")).field(
													(java.lang.String) visitor.evaluate(predicate.getTerm(0)),
													(java.lang.String) visitor.evaluate(predicate.getTerm(1))
												);
											}
										}
									)
								),
								new Declaration(
									new Variable(Type.STRING, "confidence"),
									"Main", new int[] {68,12,80,9},
									new ModuleTerm("grl", Type.STRING,
										new Predicate("field", new Term[] {
											new Variable(Type.STRING, "resultId"),
											Primitive.newPrimitive("confidence")
										}),
										new ModuleTermAdaptor() {
											public Object invoke(Intention intention, Predicate predicate) {
												return ((grl.adapters.astra.GRLModule) intention.getModule("Main","grl")).field(
													(java.lang.String) intention.evaluate(predicate.getTerm(0)),
													(java.lang.String) intention.evaluate(predicate.getTerm(1))
												);
											}
											public Object invoke(BindingsEvaluateVisitor visitor, Predicate predicate) {
												return ((grl.adapters.astra.GRLModule) visitor.agent().getModule("Main","grl")).field(
													(java.lang.String) visitor.evaluate(predicate.getTerm(0)),
													(java.lang.String) visitor.evaluate(predicate.getTerm(1))
												);
											}
										}
									)
								),
								new ModuleCall("console",
									"Main", new int[] {70,12,70,31},
									new Predicate("println", new Term[] {
										Primitive.newPrimitive("")
									}),
									new DefaultModuleCallAdaptor() {
										public boolean inline() {
											return true;
										}

										public boolean invoke(Intention intention, Predicate predicate) {
											return ((astra.lang.Console) intention.getModule("Main","console")).println(
												(java.lang.String) intention.evaluate(predicate.getTerm(0))
											);
										}
									}
								),
								new ModuleCall("console",
									"Main", new int[] {71,12,71,73},
									new Predicate("println", new Term[] {
										Primitive.newPrimitive("[AGENT] Candidate is valid and admissible.")
									}),
									new DefaultModuleCallAdaptor() {
										public boolean inline() {
											return true;
										}

										public boolean invoke(Intention intention, Predicate predicate) {
											return ((astra.lang.Console) intention.getModule("Main","console")).println(
												(java.lang.String) intention.evaluate(predicate.getTerm(0))
											);
										}
									}
								),
								new ModuleCall("console",
									"Main", new int[] {72,12,72,62},
									new Predicate("println", new Term[] {
										Operator.newOperator('+',
											Primitive.newPrimitive("[AGENT]   label      = "),
											new Variable(Type.STRING, "label")
										)
									}),
									new DefaultModuleCallAdaptor() {
										public boolean inline() {
											return true;
										}

										public boolean invoke(Intention intention, Predicate predicate) {
											return ((astra.lang.Console) intention.getModule("Main","console")).println(
												(java.lang.String) intention.evaluate(predicate.getTerm(0))
											);
										}
									}
								),
								new ModuleCall("console",
									"Main", new int[] {73,12,73,67},
									new Predicate("println", new Term[] {
										Operator.newOperator('+',
											Primitive.newPrimitive("[AGENT]   confidence = "),
											new Variable(Type.STRING, "confidence")
										)
									}),
									new DefaultModuleCallAdaptor() {
										public boolean inline() {
											return true;
										}

										public boolean invoke(Intention intention, Predicate predicate) {
											return ((astra.lang.Console) intention.getModule("Main","console")).println(
												(java.lang.String) intention.evaluate(predicate.getTerm(0))
											);
										}
									}
								),
								new ModuleCall("grl",
									"Main", new int[] {75,12,75,35},
									new Predicate("accept", new Term[] {
										new Variable(Type.STRING, "candidateId")
									}),
									new DefaultModuleCallAdaptor() {
										public boolean inline() {
											return true;
										}

										public boolean invoke(Intention intention, Predicate predicate) {
											return ((grl.adapters.astra.GRLModule) intention.getModule("Main","grl")).accept(
												(java.lang.String) intention.evaluate(predicate.getTerm(0))
											);
										}
									}
								),
								new BeliefUpdate('+',
									"Main", new int[] {76,12,80,9},
									new Predicate("candidate_accepted", new Term[] {
										new Variable(Type.STRING, "candidateId")
									})
								),
								new BeliefUpdate('+',
									"Main", new int[] {77,12,80,9},
									new Predicate("classification", new Term[] {
										new Variable(Type.STRING, "label"),
										new Variable(Type.STRING, "confidence")
									})
								),
								new ModuleCall("console",
									"Main", new int[] {79,12,79,74},
									new Predicate("println", new Term[] {
										Primitive.newPrimitive("[AGENT] Candidate ACCEPTED. Belief adopted.")
									}),
									new DefaultModuleCallAdaptor() {
										public boolean inline() {
											return true;
										}

										public boolean invoke(Intention intention, Predicate predicate) {
											return ((astra.lang.Console) intention.getModule("Main","console")).println(
												(java.lang.String) intention.evaluate(predicate.getTerm(0))
											);
										}
									}
								)
							}
						),
						new Block(
							"Main", new int[] {80,15,94,5},
							new Statement[] {
								new ModuleCall("grl",
									"Main", new int[] {81,12,81,35},
									new Predicate("reject", new Term[] {
										new Variable(Type.STRING, "candidateId")
									}),
									new DefaultModuleCallAdaptor() {
										public boolean inline() {
											return true;
										}

										public boolean invoke(Intention intention, Predicate predicate) {
											return ((grl.adapters.astra.GRLModule) intention.getModule("Main","grl")).reject(
												(java.lang.String) intention.evaluate(predicate.getTerm(0))
											);
										}
									}
								),
								new BeliefUpdate('+',
									"Main", new int[] {82,12,87,9},
									new Predicate("candidate_rejected", new Term[] {
										new Variable(Type.STRING, "candidateId")
									})
								),
								new ModuleCall("console",
									"Main", new int[] {84,12,84,31},
									new Predicate("println", new Term[] {
										Primitive.newPrimitive("")
									}),
									new DefaultModuleCallAdaptor() {
										public boolean inline() {
											return true;
										}

										public boolean invoke(Intention intention, Predicate predicate) {
											return ((astra.lang.Console) intention.getModule("Main","console")).println(
												(java.lang.String) intention.evaluate(predicate.getTerm(0))
											);
										}
									}
								),
								new ModuleCall("console",
									"Main", new int[] {85,12,85,58},
									new Predicate("println", new Term[] {
										Primitive.newPrimitive("[AGENT] Candidate REJECTED.")
									}),
									new DefaultModuleCallAdaptor() {
										public boolean inline() {
											return true;
										}

										public boolean invoke(Intention intention, Predicate predicate) {
											return ((astra.lang.Console) intention.getModule("Main","console")).println(
												(java.lang.String) intention.evaluate(predicate.getTerm(0))
											);
										}
									}
								),
								new ModuleCall("console",
									"Main", new int[] {86,12,86,75},
									new Predicate("println", new Term[] {
										Operator.newOperator('+',
											Primitive.newPrimitive("[AGENT]   outcome = "),
											new ModuleTerm("grl", Type.STRING,
												new Predicate("outcome", new Term[] {
													new Variable(Type.STRING, "resultId")
												}),
												new ModuleTermAdaptor() {
													public Object invoke(Intention intention, Predicate predicate) {
														return ((grl.adapters.astra.GRLModule) intention.getModule("Main","grl")).outcome(
															(java.lang.String) intention.evaluate(predicate.getTerm(0))
														);
													}
													public Object invoke(BindingsEvaluateVisitor visitor, Predicate predicate) {
														return ((grl.adapters.astra.GRLModule) visitor.agent().getModule("Main","grl")).outcome(
															(java.lang.String) visitor.evaluate(predicate.getTerm(0))
														);
													}
												}
											)
										)
									}),
									new DefaultModuleCallAdaptor() {
										public boolean inline() {
											return true;
										}

										public boolean invoke(Intention intention, Predicate predicate) {
											return ((astra.lang.Console) intention.getModule("Main","console")).println(
												(java.lang.String) intention.evaluate(predicate.getTerm(0))
											);
										}
									}
								)
							}
						)
					),
					new Declaration(
						new Variable(Type.STRING, "traceId"),
						"Main", new int[] {90,8,94,5},
						new ModuleTerm("grl", Type.STRING,
							new Predicate("trace", new Term[] {
								new Variable(Type.STRING, "resultId")
							}),
							new ModuleTermAdaptor() {
								public Object invoke(Intention intention, Predicate predicate) {
									return ((grl.adapters.astra.GRLModule) intention.getModule("Main","grl")).trace(
										(java.lang.String) intention.evaluate(predicate.getTerm(0))
									);
								}
								public Object invoke(BindingsEvaluateVisitor visitor, Predicate predicate) {
									return ((grl.adapters.astra.GRLModule) visitor.agent().getModule("Main","grl")).trace(
										(java.lang.String) visitor.evaluate(predicate.getTerm(0))
									);
								}
							}
						)
					),
					new ModuleCall("console",
						"Main", new int[] {91,8,91,27},
						new Predicate("println", new Term[] {
							Primitive.newPrimitive("")
						}),
						new DefaultModuleCallAdaptor() {
							public boolean inline() {
								return true;
							}

							public boolean invoke(Intention intention, Predicate predicate) {
								return ((astra.lang.Console) intention.getModule("Main","console")).println(
									(java.lang.String) intention.evaluate(predicate.getTerm(0))
								);
							}
						}
					),
					new ModuleCall("console",
						"Main", new int[] {92,8,92,55},
						new Predicate("println", new Term[] {
							Operator.newOperator('+',
								Primitive.newPrimitive("[TRACE] traceId = "),
								new Variable(Type.STRING, "traceId")
							)
						}),
						new DefaultModuleCallAdaptor() {
							public boolean inline() {
								return true;
							}

							public boolean invoke(Intention intention, Predicate predicate) {
								return ((astra.lang.Console) intention.getModule("Main","console")).println(
									(java.lang.String) intention.evaluate(predicate.getTerm(0))
								);
							}
						}
					),
					new ModuleCall("console",
						"Main", new int[] {93,8,93,48},
						new Predicate("println", new Term[] {
							Primitive.newPrimitive("=== Demo Complete ===")
						}),
						new DefaultModuleCallAdaptor() {
							public boolean inline() {
								return true;
							}

							public boolean invoke(Intention intention, Predicate predicate) {
								return ((astra.lang.Console) intention.getModule("Main","console")).println(
									(java.lang.String) intention.evaluate(predicate.getTerm(0))
								);
							}
						}
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
			astra.core.Agent agent = new Main().newInstance(name);
			if (!agent.isRunnable()) {
				java.lang.System.out.println("WARNING: No +!main(...) rule has been defined for main agent type: Main");
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
