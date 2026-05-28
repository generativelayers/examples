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
			"Main", new int[] {27,9,27,28},
			new GoalEvent('+',
				new Goal(
					new Predicate("main", new Term[] {
						new Variable(Type.LIST, "args",false)
					})
				)
			),
			Predicate.TRUE,
			new Block(
				"Main", new int[] {27,27,48,5},
				new Statement[] {
					new ModuleCall("console",
						"Main", new int[] {28,8,28,68},
						new Predicate("println", new Term[] {
							Primitive.newPrimitive("=== GRL Invalid Output Rejection Demo ===")
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
						"Main", new int[] {29,8,29,27},
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
					new Subgoal(
						"Main", new int[] {33,8,48,5},
						new Goal(
							new Predicate("tryClassify", new Term[] {
								Primitive.newPrimitive("Classify 'banana' as food. Return label, confidence, and category."),
								Primitive.newPrimitive("label,confidence,category"),
								Primitive.newPrimitive(1)
							})
						)
					),
					new Subgoal(
						"Main", new int[] {40,8,48,5},
						new Goal(
							new Predicate("tryClassify", new Term[] {
								Primitive.newPrimitive("Classify 'banana' as food. Return label and confidence."),
								Primitive.newPrimitive("label,confidence"),
								Primitive.newPrimitive(2)
							})
						)
					),
					new ModuleCall("console",
						"Main", new int[] {46,8,46,27},
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
						"Main", new int[] {47,8,47,48},
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
		addRule(new Rule(
			"Main", new int[] {50,9,50,75},
			new GoalEvent('+',
				new Goal(
					new Predicate("tryClassify", new Term[] {
						new Variable(Type.STRING, "prompt",false),
						new Variable(Type.STRING, "requiredCsv",false),
						new Variable(Type.INTEGER, "attemptNum",false)
					})
				)
			),
			Predicate.TRUE,
			new Block(
				"Main", new int[] {50,74,89,5},
				new Statement[] {
					new ModuleCall("console",
						"Main", new int[] {51,8,51,71},
						new Predicate("println", new Term[] {
							Operator.newOperator('+',
								Primitive.newPrimitive("[ATTEMPT "),
								Operator.newOperator('+',
									new Variable(Type.INTEGER, "attemptNum"),
									Primitive.newPrimitive("] Invoking GRL...")
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
					new ModuleCall("console",
						"Main", new int[] {52,8,52,83},
						new Predicate("println", new Term[] {
							Operator.newOperator('+',
								Primitive.newPrimitive("[ATTEMPT "),
								Operator.newOperator('+',
									new Variable(Type.INTEGER, "attemptNum"),
									Operator.newOperator('+',
										Primitive.newPrimitive("]   required = "),
										new Variable(Type.STRING, "requiredCsv")
									)
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
						new Variable(Type.STRING, "resultId"),
						"Main", new int[] {54,8,89,5},
						new ModuleTerm("grl", Type.STRING,
							new Predicate("invoke", new Term[] {
								Primitive.newPrimitive("agent_a"),
								Primitive.newPrimitive("classify_food"),
								Primitive.newPrimitive("llm.answer"),
								Primitive.newPrimitive("ANSWER"),
								new Variable(Type.STRING, "prompt"),
								new Variable(Type.STRING, "requiredCsv")
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
					new Declaration(
						new Variable(Type.STRING, "outcome"),
						"Main", new int[] {59,8,89,5},
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
					),
					new ModuleCall("console",
						"Main", new int[] {60,8,60,79},
						new Predicate("println", new Term[] {
							Operator.newOperator('+',
								Primitive.newPrimitive("[ATTEMPT "),
								Operator.newOperator('+',
									new Variable(Type.INTEGER, "attemptNum"),
									Operator.newOperator('+',
										Primitive.newPrimitive("]   outcome  = "),
										new Variable(Type.STRING, "outcome")
									)
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
					new ModuleCall("console",
						"Main", new int[] {61,8,61,91},
						new Predicate("println", new Term[] {
							Operator.newOperator('+',
								Primitive.newPrimitive("[ATTEMPT "),
								Operator.newOperator('+',
									new Variable(Type.INTEGER, "attemptNum"),
									Operator.newOperator('+',
										Primitive.newPrimitive("]   valid    = "),
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
									)
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
						new Variable(Type.STRING, "candidateId"),
						"Main", new int[] {63,8,89,5},
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
					new Declaration(
						new Variable(Type.BOOLEAN, "isValid"),
						"Main", new int[] {64,8,89,5},
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
					new If(
						"Main", new int[] {66,8,89,5},
						new BooleanTermFormula(
							new Variable(Type.BOOLEAN, "isValid")
						),
						new Block(
							"Main", new int[] {66,21,78,9},
							new Statement[] {
								new Declaration(
									new Variable(Type.STRING, "label"),
									"Main", new int[] {68,12,78,9},
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
									"Main", new int[] {69,12,78,9},
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
								new ModuleCall("grl",
									"Main", new int[] {71,12,71,35},
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
									"Main", new int[] {72,12,78,9},
									new Predicate("candidate_accepted", new Term[] {
										new Variable(Type.STRING, "candidateId")
									})
								),
								new BeliefUpdate('+',
									"Main", new int[] {73,12,78,9},
									new Predicate("classification", new Term[] {
										new Variable(Type.STRING, "label"),
										new Variable(Type.STRING, "confidence"),
										Operator.newOperator('+',
											Primitive.newPrimitive("attempt_"),
											new Variable(Type.INTEGER, "attemptNum")
										)
									})
								),
								new ModuleCall("console",
									"Main", new int[] {75,12,75,70},
									new Predicate("println", new Term[] {
										Operator.newOperator('+',
											Primitive.newPrimitive("[ATTEMPT "),
											Operator.newOperator('+',
												new Variable(Type.INTEGER, "attemptNum"),
												Primitive.newPrimitive("]   ACCEPTED")
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
								new ModuleCall("console",
									"Main", new int[] {76,12,76,85},
									new Predicate("println", new Term[] {
										Operator.newOperator('+',
											Primitive.newPrimitive("[ATTEMPT "),
											Operator.newOperator('+',
												new Variable(Type.INTEGER, "attemptNum"),
												Operator.newOperator('+',
													Primitive.newPrimitive("]     label      = "),
													new Variable(Type.STRING, "label")
												)
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
								new ModuleCall("console",
									"Main", new int[] {77,12,77,90},
									new Predicate("println", new Term[] {
										Operator.newOperator('+',
											Primitive.newPrimitive("[ATTEMPT "),
											Operator.newOperator('+',
												new Variable(Type.INTEGER, "attemptNum"),
												Operator.newOperator('+',
													Primitive.newPrimitive("]     confidence = "),
													new Variable(Type.STRING, "confidence")
												)
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
						),
						new Block(
							"Main", new int[] {78,15,89,5},
							new Statement[] {
								new ModuleCall("grl",
									"Main", new int[] {80,12,80,35},
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
									"Main", new int[] {81,12,85,9},
									new Predicate("candidate_rejected", new Term[] {
										new Variable(Type.STRING, "candidateId"),
										new Variable(Type.STRING, "outcome")
									})
								),
								new ModuleCall("console",
									"Main", new int[] {83,12,83,85},
									new Predicate("println", new Term[] {
										Operator.newOperator('+',
											Primitive.newPrimitive("[ATTEMPT "),
											Operator.newOperator('+',
												new Variable(Type.INTEGER, "attemptNum"),
												Operator.newOperator('+',
													Primitive.newPrimitive("]   REJECTED ??? "),
													new Variable(Type.STRING, "outcome")
												)
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
								new ModuleCall("console",
									"Main", new int[] {84,12,84,94},
									new Predicate("println", new Term[] {
										Operator.newOperator('+',
											Primitive.newPrimitive("[ATTEMPT "),
											Operator.newOperator('+',
												new Variable(Type.INTEGER, "attemptNum"),
												Primitive.newPrimitive("]   No beliefs adopted. Fail-closed.")
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
					new SpecialBeliefUpdate(
						"Main", new int[] {87,8,89,5},
						new Predicate("attempt", new Term[] {
							new Variable(Type.INTEGER, "attemptNum")
						})
					),
					new ModuleCall("console",
						"Main", new int[] {88,8,88,27},
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
					)
				}
			),
			false
		));
	}

	public void initialize(astra.core.Agent agent) {
		agent.initialize(
			new Predicate("attempt", new Term[] {
				Primitive.newPrimitive(0)
			})
		);
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
