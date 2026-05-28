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


public class Generator extends ASTRAClass {
	public Generator() {
		setParents(new Class[] {astra.lang.Agent.class});
		addRule(new Rule(
			"Generator", new int[] {22,9,22,28},
			new GoalEvent('+',
				new Goal(
					new Predicate("main", new Term[] {
						new Variable(Type.LIST, "args",false)
					})
				)
			),
			Predicate.TRUE,
			new Block(
				"Generator", new int[] {22,27,58,5},
				new Statement[] {
					new ModuleCall("console",
						"Generator", new int[] {23,8,23,71},
						new Predicate("println", new Term[] {
							Primitive.newPrimitive("[Generator] Starting candidate generation...")
						}),
						new DefaultModuleCallAdaptor() {
							public boolean inline() {
								return true;
							}

							public boolean invoke(Intention intention, Predicate predicate) {
								return ((astra.lang.Console) intention.getModule("Generator","console")).println(
									(java.lang.String) intention.evaluate(predicate.getTerm(0))
								);
							}
						}
					),
					new Declaration(
						new Variable(Type.STRING, "resultId"),
						"Generator", new int[] {26,8,58,5},
						new ModuleTerm("grl", Type.STRING,
							new Predicate("invoke", new Term[] {
								Primitive.newPrimitive("generator"),
								Primitive.newPrimitive("classify_food"),
								Primitive.newPrimitive("llm.answer"),
								Primitive.newPrimitive("ANSWER"),
								Primitive.newPrimitive("Classify 'mango' as a food type. Return label and confidence."),
								Primitive.newPrimitive("label,confidence")
							}),
							new ModuleTermAdaptor() {
								public Object invoke(Intention intention, Predicate predicate) {
									return ((grl.adapters.astra.GRLModule) intention.getModule("Generator","grl")).invoke(
										(java.lang.String) intention.evaluate(predicate.getTerm(0)),
										(java.lang.String) intention.evaluate(predicate.getTerm(1)),
										(java.lang.String) intention.evaluate(predicate.getTerm(2)),
										(java.lang.String) intention.evaluate(predicate.getTerm(3)),
										(java.lang.String) intention.evaluate(predicate.getTerm(4)),
										(java.lang.String) intention.evaluate(predicate.getTerm(5))
									);
								}
								public Object invoke(BindingsEvaluateVisitor visitor, Predicate predicate) {
									return ((grl.adapters.astra.GRLModule) visitor.agent().getModule("Generator","grl")).invoke(
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
						"Generator", new int[] {32,8,32,62},
						new Predicate("println", new Term[] {
							Operator.newOperator('+',
								Primitive.newPrimitive("[Generator] resultId  = "),
								new Variable(Type.STRING, "resultId")
							)
						}),
						new DefaultModuleCallAdaptor() {
							public boolean inline() {
								return true;
							}

							public boolean invoke(Intention intention, Predicate predicate) {
								return ((astra.lang.Console) intention.getModule("Generator","console")).println(
									(java.lang.String) intention.evaluate(predicate.getTerm(0))
								);
							}
						}
					),
					new ModuleCall("console",
						"Generator", new int[] {33,8,33,75},
						new Predicate("println", new Term[] {
							Operator.newOperator('+',
								Primitive.newPrimitive("[Generator] outcome   = "),
								new ModuleTerm("grl", Type.STRING,
									new Predicate("outcome", new Term[] {
										new Variable(Type.STRING, "resultId")
									}),
									new ModuleTermAdaptor() {
										public Object invoke(Intention intention, Predicate predicate) {
											return ((grl.adapters.astra.GRLModule) intention.getModule("Generator","grl")).outcome(
												(java.lang.String) intention.evaluate(predicate.getTerm(0))
											);
										}
										public Object invoke(BindingsEvaluateVisitor visitor, Predicate predicate) {
											return ((grl.adapters.astra.GRLModule) visitor.agent().getModule("Generator","grl")).outcome(
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
								return ((astra.lang.Console) intention.getModule("Generator","console")).println(
									(java.lang.String) intention.evaluate(predicate.getTerm(0))
								);
							}
						}
					),
					new ModuleCall("console",
						"Generator", new int[] {34,8,34,73},
						new Predicate("println", new Term[] {
							Operator.newOperator('+',
								Primitive.newPrimitive("[Generator] valid     = "),
								new ModuleTerm("grl", Type.BOOLEAN,
									new Predicate("valid", new Term[] {
										new Variable(Type.STRING, "resultId")
									}),
									new ModuleTermAdaptor() {
										public Object invoke(Intention intention, Predicate predicate) {
											return ((grl.adapters.astra.GRLModule) intention.getModule("Generator","grl")).valid(
												(java.lang.String) intention.evaluate(predicate.getTerm(0))
											);
										}
										public Object invoke(BindingsEvaluateVisitor visitor, Predicate predicate) {
											return ((grl.adapters.astra.GRLModule) visitor.agent().getModule("Generator","grl")).valid(
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
								return ((astra.lang.Console) intention.getModule("Generator","console")).println(
									(java.lang.String) intention.evaluate(predicate.getTerm(0))
								);
							}
						}
					),
					new Declaration(
						new Variable(Type.STRING, "candidateId"),
						"Generator", new int[] {36,8,58,5},
						new ModuleTerm("grl", Type.STRING,
							new Predicate("candidate", new Term[] {
								new Variable(Type.STRING, "resultId")
							}),
							new ModuleTermAdaptor() {
								public Object invoke(Intention intention, Predicate predicate) {
									return ((grl.adapters.astra.GRLModule) intention.getModule("Generator","grl")).candidate(
										(java.lang.String) intention.evaluate(predicate.getTerm(0))
									);
								}
								public Object invoke(BindingsEvaluateVisitor visitor, Predicate predicate) {
									return ((grl.adapters.astra.GRLModule) visitor.agent().getModule("Generator","grl")).candidate(
										(java.lang.String) visitor.evaluate(predicate.getTerm(0))
									);
								}
							}
						)
					),
					new Declaration(
						new Variable(Type.BOOLEAN, "isValid"),
						"Generator", new int[] {37,8,58,5},
						new ModuleTerm("grl", Type.BOOLEAN,
							new Predicate("valid", new Term[] {
								new Variable(Type.STRING, "resultId")
							}),
							new ModuleTermAdaptor() {
								public Object invoke(Intention intention, Predicate predicate) {
									return ((grl.adapters.astra.GRLModule) intention.getModule("Generator","grl")).valid(
										(java.lang.String) intention.evaluate(predicate.getTerm(0))
									);
								}
								public Object invoke(BindingsEvaluateVisitor visitor, Predicate predicate) {
									return ((grl.adapters.astra.GRLModule) visitor.agent().getModule("Generator","grl")).valid(
										(java.lang.String) visitor.evaluate(predicate.getTerm(0))
									);
								}
							}
						)
					),
					new If(
						"Generator", new int[] {39,8,58,5},
						new BooleanTermFormula(
							new Variable(Type.BOOLEAN, "isValid")
						),
						new Block(
							"Generator", new int[] {39,21,52,9},
							new Statement[] {
								new Declaration(
									new Variable(Type.STRING, "label"),
									"Generator", new int[] {40,12,52,9},
									new ModuleTerm("grl", Type.STRING,
										new Predicate("field", new Term[] {
											new Variable(Type.STRING, "resultId"),
											Primitive.newPrimitive("label")
										}),
										new ModuleTermAdaptor() {
											public Object invoke(Intention intention, Predicate predicate) {
												return ((grl.adapters.astra.GRLModule) intention.getModule("Generator","grl")).field(
													(java.lang.String) intention.evaluate(predicate.getTerm(0)),
													(java.lang.String) intention.evaluate(predicate.getTerm(1))
												);
											}
											public Object invoke(BindingsEvaluateVisitor visitor, Predicate predicate) {
												return ((grl.adapters.astra.GRLModule) visitor.agent().getModule("Generator","grl")).field(
													(java.lang.String) visitor.evaluate(predicate.getTerm(0)),
													(java.lang.String) visitor.evaluate(predicate.getTerm(1))
												);
											}
										}
									)
								),
								new Declaration(
									new Variable(Type.STRING, "confidence"),
									"Generator", new int[] {41,12,52,9},
									new ModuleTerm("grl", Type.STRING,
										new Predicate("field", new Term[] {
											new Variable(Type.STRING, "resultId"),
											Primitive.newPrimitive("confidence")
										}),
										new ModuleTermAdaptor() {
											public Object invoke(Intention intention, Predicate predicate) {
												return ((grl.adapters.astra.GRLModule) intention.getModule("Generator","grl")).field(
													(java.lang.String) intention.evaluate(predicate.getTerm(0)),
													(java.lang.String) intention.evaluate(predicate.getTerm(1))
												);
											}
											public Object invoke(BindingsEvaluateVisitor visitor, Predicate predicate) {
												return ((grl.adapters.astra.GRLModule) visitor.agent().getModule("Generator","grl")).field(
													(java.lang.String) visitor.evaluate(predicate.getTerm(0)),
													(java.lang.String) visitor.evaluate(predicate.getTerm(1))
												);
											}
										}
									)
								),
								new ModuleCall("console",
									"Generator", new int[] {43,12,43,84},
									new Predicate("println", new Term[] {
										Primitive.newPrimitive("[Generator] Candidate valid. Requesting assessment...")
									}),
									new DefaultModuleCallAdaptor() {
										public boolean inline() {
											return true;
										}

										public boolean invoke(Intention intention, Predicate predicate) {
											return ((astra.lang.Console) intention.getModule("Generator","console")).println(
												(java.lang.String) intention.evaluate(predicate.getTerm(0))
											);
										}
									}
								),
								new ModuleCall("console",
									"Generator", new int[] {44,12,44,66},
									new Predicate("println", new Term[] {
										Operator.newOperator('+',
											Primitive.newPrimitive("[Generator]   label      = "),
											new Variable(Type.STRING, "label")
										)
									}),
									new DefaultModuleCallAdaptor() {
										public boolean inline() {
											return true;
										}

										public boolean invoke(Intention intention, Predicate predicate) {
											return ((astra.lang.Console) intention.getModule("Generator","console")).println(
												(java.lang.String) intention.evaluate(predicate.getTerm(0))
											);
										}
									}
								),
								new ModuleCall("console",
									"Generator", new int[] {45,12,45,71},
									new Predicate("println", new Term[] {
										Operator.newOperator('+',
											Primitive.newPrimitive("[Generator]   confidence = "),
											new Variable(Type.STRING, "confidence")
										)
									}),
									new DefaultModuleCallAdaptor() {
										public boolean inline() {
											return true;
										}

										public boolean invoke(Intention intention, Predicate predicate) {
											return ((astra.lang.Console) intention.getModule("Generator","console")).println(
												(java.lang.String) intention.evaluate(predicate.getTerm(0))
											);
										}
									}
								),
								new Send("Generator", new int[] {48,12,48,95},
									new Performative("request"),
									Primitive.newPrimitive("assessor"),
									new Predicate("review_request", new Term[] {
										new Variable(Type.STRING, "candidateId"),
										new Variable(Type.STRING, "resultId"),
										new Variable(Type.STRING, "label"),
										new Variable(Type.STRING, "confidence")
									})
								),
								new ModuleCall("console",
									"Generator", new int[] {51,12,51,74},
									new Predicate("println", new Term[] {
										Primitive.newPrimitive("[Generator] Waiting for assessor verdict...")
									}),
									new DefaultModuleCallAdaptor() {
										public boolean inline() {
											return true;
										}

										public boolean invoke(Intention intention, Predicate predicate) {
											return ((astra.lang.Console) intention.getModule("Generator","console")).println(
												(java.lang.String) intention.evaluate(predicate.getTerm(0))
											);
										}
									}
								)
							}
						),
						new Block(
							"Generator", new int[] {52,15,58,5},
							new Statement[] {
								new ModuleCall("grl",
									"Generator", new int[] {54,12,54,35},
									new Predicate("reject", new Term[] {
										new Variable(Type.STRING, "candidateId")
									}),
									new DefaultModuleCallAdaptor() {
										public boolean inline() {
											return true;
										}

										public boolean invoke(Intention intention, Predicate predicate) {
											return ((grl.adapters.astra.GRLModule) intention.getModule("Generator","grl")).reject(
												(java.lang.String) intention.evaluate(predicate.getTerm(0))
											);
										}
									}
								),
								new BeliefUpdate('+',
									"Generator", new int[] {55,12,57,9},
									new Predicate("candidate_rejected", new Term[] {
										new Variable(Type.STRING, "candidateId")
									})
								),
								new ModuleCall("console",
									"Generator", new int[] {56,12,56,83},
									new Predicate("println", new Term[] {
										Primitive.newPrimitive("[Generator] Candidate invalid. REJECTED immediately.")
									}),
									new DefaultModuleCallAdaptor() {
										public boolean inline() {
											return true;
										}

										public boolean invoke(Intention intention, Predicate predicate) {
											return ((astra.lang.Console) intention.getModule("Generator","console")).println(
												(java.lang.String) intention.evaluate(predicate.getTerm(0))
											);
										}
									}
								)
							}
						)
					)
				}
			),
			false
		));
		addRule(new Rule(
			"Generator", new int[] {61,9,63,32},
			new MessageEvent(
				new Performative("inform"),
				new Variable(Type.STRING, "sender",false),
				new Predicate("verdict", new Term[] {
					new Variable(Type.STRING, "candidateId",false),
					new Variable(Type.STRING, "decision",false),
					new Variable(Type.STRING, "explanation",false)
				})
			),
			new Comparison("==",
				new Variable(Type.STRING, "decision"),
				Primitive.newPrimitive("ENDORSED")
			),
			new Block(
				"Generator", new int[] {63,31,74,5},
				new Statement[] {
					new ModuleCall("console",
						"Generator", new int[] {65,8,65,79},
						new Predicate("println", new Term[] {
							Operator.newOperator('+',
								Primitive.newPrimitive("[Generator] Assessment from "),
								Operator.newOperator('+',
									new Variable(Type.STRING, "sender"),
									Primitive.newPrimitive(": ENDORSED")
								)
							)
						}),
						new DefaultModuleCallAdaptor() {
							public boolean inline() {
								return true;
							}

							public boolean invoke(Intention intention, Predicate predicate) {
								return ((astra.lang.Console) intention.getModule("Generator","console")).println(
									(java.lang.String) intention.evaluate(predicate.getTerm(0))
								);
							}
						}
					),
					new ModuleCall("console",
						"Generator", new int[] {66,8,66,63},
						new Predicate("println", new Term[] {
							Operator.newOperator('+',
								Primitive.newPrimitive("[Generator]   reason: "),
								new Variable(Type.STRING, "explanation")
							)
						}),
						new DefaultModuleCallAdaptor() {
							public boolean inline() {
								return true;
							}

							public boolean invoke(Intention intention, Predicate predicate) {
								return ((astra.lang.Console) intention.getModule("Generator","console")).println(
									(java.lang.String) intention.evaluate(predicate.getTerm(0))
								);
							}
						}
					),
					new ModuleCall("grl",
						"Generator", new int[] {69,8,69,31},
						new Predicate("accept", new Term[] {
							new Variable(Type.STRING, "candidateId")
						}),
						new DefaultModuleCallAdaptor() {
							public boolean inline() {
								return true;
							}

							public boolean invoke(Intention intention, Predicate predicate) {
								return ((grl.adapters.astra.GRLModule) intention.getModule("Generator","grl")).accept(
									(java.lang.String) intention.evaluate(predicate.getTerm(0))
								);
							}
						}
					),
					new BeliefUpdate('+',
						"Generator", new int[] {70,8,74,5},
						new Predicate("candidate_accepted", new Term[] {
							new Variable(Type.STRING, "candidateId")
						})
					),
					new BeliefUpdate('+',
						"Generator", new int[] {71,8,74,5},
						new Predicate("assessment_received", new Term[] {
							new Variable(Type.STRING, "candidateId"),
							Primitive.newPrimitive("ENDORSED")
						})
					),
					new ModuleCall("console",
						"Generator", new int[] {73,8,73,80},
						new Predicate("println", new Term[] {
							Primitive.newPrimitive("[Generator] Candidate ACCEPTED after peer assessment.")
						}),
						new DefaultModuleCallAdaptor() {
							public boolean inline() {
								return true;
							}

							public boolean invoke(Intention intention, Predicate predicate) {
								return ((astra.lang.Console) intention.getModule("Generator","console")).println(
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
			"Generator", new int[] {77,9,79,33},
			new MessageEvent(
				new Performative("inform"),
				new Variable(Type.STRING, "sender",false),
				new Predicate("verdict", new Term[] {
					new Variable(Type.STRING, "candidateId",false),
					new Variable(Type.STRING, "decision",false),
					new Variable(Type.STRING, "explanation",false)
				})
			),
			new Comparison("==",
				new Variable(Type.STRING, "decision"),
				Primitive.newPrimitive("CONTESTED")
			),
			new Block(
				"Generator", new int[] {79,32,90,5},
				new Statement[] {
					new ModuleCall("console",
						"Generator", new int[] {81,8,81,80},
						new Predicate("println", new Term[] {
							Operator.newOperator('+',
								Primitive.newPrimitive("[Generator] Assessment from "),
								Operator.newOperator('+',
									new Variable(Type.STRING, "sender"),
									Primitive.newPrimitive(": CONTESTED")
								)
							)
						}),
						new DefaultModuleCallAdaptor() {
							public boolean inline() {
								return true;
							}

							public boolean invoke(Intention intention, Predicate predicate) {
								return ((astra.lang.Console) intention.getModule("Generator","console")).println(
									(java.lang.String) intention.evaluate(predicate.getTerm(0))
								);
							}
						}
					),
					new ModuleCall("console",
						"Generator", new int[] {82,8,82,63},
						new Predicate("println", new Term[] {
							Operator.newOperator('+',
								Primitive.newPrimitive("[Generator]   reason: "),
								new Variable(Type.STRING, "explanation")
							)
						}),
						new DefaultModuleCallAdaptor() {
							public boolean inline() {
								return true;
							}

							public boolean invoke(Intention intention, Predicate predicate) {
								return ((astra.lang.Console) intention.getModule("Generator","console")).println(
									(java.lang.String) intention.evaluate(predicate.getTerm(0))
								);
							}
						}
					),
					new ModuleCall("grl",
						"Generator", new int[] {85,8,85,31},
						new Predicate("reject", new Term[] {
							new Variable(Type.STRING, "candidateId")
						}),
						new DefaultModuleCallAdaptor() {
							public boolean inline() {
								return true;
							}

							public boolean invoke(Intention intention, Predicate predicate) {
								return ((grl.adapters.astra.GRLModule) intention.getModule("Generator","grl")).reject(
									(java.lang.String) intention.evaluate(predicate.getTerm(0))
								);
							}
						}
					),
					new BeliefUpdate('+',
						"Generator", new int[] {86,8,90,5},
						new Predicate("candidate_rejected", new Term[] {
							new Variable(Type.STRING, "candidateId")
						})
					),
					new BeliefUpdate('+',
						"Generator", new int[] {87,8,90,5},
						new Predicate("assessment_received", new Term[] {
							new Variable(Type.STRING, "candidateId"),
							Primitive.newPrimitive("CONTESTED")
						})
					),
					new ModuleCall("console",
						"Generator", new int[] {89,8,89,80},
						new Predicate("println", new Term[] {
							Primitive.newPrimitive("[Generator] Candidate REJECTED after peer assessment.")
						}),
						new DefaultModuleCallAdaptor() {
							public boolean inline() {
								return true;
							}

							public boolean invoke(Intention intention, Predicate predicate) {
								return ((astra.lang.Console) intention.getModule("Generator","console")).println(
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
			astra.core.Agent agent = new Generator().newInstance(name);
			if (!agent.isRunnable()) {
				java.lang.System.out.println("WARNING: No +!main(...) rule has been defined for main agent type: Generator");
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
