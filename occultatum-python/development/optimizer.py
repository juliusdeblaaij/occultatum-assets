import pyomo.environ as pyomo

model = pyomo.ConcreteModel()

"""
The goal of this model is to maximize the utility U of agricultural activities.
The utility is defined as:
U = Z - R Sigma(I)
where Z = expected income (i.e. the average annual income)
R = the risk aversion coefficient (range 0, 1.65)
Sigma(I) = the standard deviation of income according to states of nature defined under two
different sources of variation: yield (due to climatic conditions) and prices

Constraints to be optimized:

Worker sustainance:
- There are N workers.
- Each worker consumes per year:
    - 175 Liters of cereals
    - 72 kg meat
    - 130 Liters of dairy
- Each worker has 4380 working hours per year (365 days * 12 hours/day).

Cereal production labor requirements (per hectare):
- Ploughing: 30 hours
- Sowing: 3 hours
- Harvest: 24 hours

For now, ignore meat and dairy needs.

Key constraint:
- The total cereal yield must be at least the total cereal consumption required by all workers (N * 175 Liters).
- The total labor required for cereal production (ploughing + sowing + harvest per hectare * number of hectares) must not exceed the total available worker hours (N * 4380).

The optimization should determine whether the cereal yield exceeds the workers' cereal requirement, given the labor constraints.
"""

# Parameters
N = 10  # number of workers (example value, can be changed)
cereal_consumption_per_worker = 175  # Liters/year
worker_hours_per_year = 4380  # hours/year

ploughing_hours_per_hectare = 30
sowing_hours_per_hectare = 3
harvest_hours_per_hectare = 24

cereal_yield_per_hectare = 1000  # Liters/hectare/year (example value, adjust as needed)
risk_aversion = 1.0  # example value, can be changed

# Decision variable: number of hectares to cultivate
model.hectares = pyomo.Var(domain=pyomo.NonNegativeReals)

# Constraint: total cereal yield >= total worker requirement
def cereal_requirement_rule(m):
    return cereal_yield_per_hectare * m.hectares >= N * cereal_consumption_per_worker
model.cereal_requirement = pyomo.Constraint(rule=cereal_requirement_rule)

# Constraint: total labor required <= total available worker hours
def labor_constraint_rule(m):
    total_labor_per_hectare = ploughing_hours_per_hectare + sowing_hours_per_hectare + harvest_hours_per_hectare
    return total_labor_per_hectare * m.hectares <= N * worker_hours_per_year
model.labor_constraint = pyomo.Constraint(rule=labor_constraint_rule)

# Objective: maximize utility U = Z - R * Sigma(I)
# For simplicity, assume Z = expected income = cereal_yield_per_hectare * hectares * price_per_liter
# Assume price_per_liter = 1 (can be parameterized), Sigma(I) = 0 for deterministic example
price_per_liter = 1
income = cereal_yield_per_hectare * model.hectares * price_per_liter
risk_term = risk_aversion * 0  # set to zero for now

model.obj = pyomo.Objective(expr=income - risk_term, sense=pyomo.maximize)

def solve_model():
    solver = pyomo.SolverFactory('scip')
    results = solver.solve(model, tee=True)
    
    if results.solver.termination_condition == pyomo.TerminationCondition.optimal:
        print("Optimal solution found:")
        print(f"Optimal hectares: {model.hectares.value}")
        print(f"Objective: {model.obj.expr()}")
    else:
        print("No optimal solution found.")

if __name__ == "__main__":
    solve_model()