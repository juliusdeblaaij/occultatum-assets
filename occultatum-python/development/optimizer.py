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

Key constraint:
- The total cereal yield must be at least the total cereal consumption required by all workers (N * 175 Liters).
- The total labor required for cereal production (ploughing + sowing + harvest per hectare * number of hectares) must not exceed the total available worker hours (N * 4380).

The optimization should determine whether the cereal yield exceeds the workers' cereal requirement, given the labor constraints.
"""

# Parameters
N = 3  # number of workers (example value, can be changed)
cereal_consumption_per_worker = 175  # Liters/year
milk_consumption_per_worker = 130  # Liters/year
meat_consumption_per_worker = 72  # kg/year
worker_hours_per_year = 4380  # hours/year  

ploughing_hours_per_hectare = 30
sowing_hours_per_hectare = 3
harvest_hours_per_hectare = 24

cereal_yield_per_hectare = 1000  # Liters/hectare/year (example value, adjust as needed)
risk_aversion = 1.0  # example value, can be changed

A = 25  # catchment area in hectares (hard limit)

# Decision variable: number of hectares to cultivate
model.hectares = pyomo.Var(domain=pyomo.NonNegativeReals)

# Scheduling parameters
weeks_per_activity = 4
hours_per_week = 7 * 12  # 7 days * 12 hours/day
max_activity_hours_per_worker = weeks_per_activity * hours_per_week  # 336 hours

# Decision variables for scheduling
model.hectares_ploughed = pyomo.Var(domain=pyomo.NonNegativeReals)
model.hectares_sown = pyomo.Var(domain=pyomo.NonNegativeReals)
model.hectares_harvested = pyomo.Var(domain=pyomo.NonNegativeReals)

# Ploughing labor constraint
def ploughing_labor_rule(m):
    return ploughing_hours_per_hectare * m.hectares_ploughed <= N * max_activity_hours_per_worker
model.ploughing_labor_constraint = pyomo.Constraint(rule=ploughing_labor_rule)

# Sowing labor constraint
def sowing_labor_rule(m):
    return sowing_hours_per_hectare * m.hectares_sown <= N * max_activity_hours_per_worker
model.sowing_labor_constraint = pyomo.Constraint(rule=sowing_labor_rule)

# Harvest labor constraint
def harvest_labor_rule(m):
    return harvest_hours_per_hectare * m.hectares_harvested <= N * max_activity_hours_per_worker
model.harvest_labor_constraint = pyomo.Constraint(rule=harvest_labor_rule)

# Scheduling order constraints
model.scheduling_harvest_leq_sown = pyomo.Constraint(expr=model.hectares_harvested <= model.hectares_sown)
model.scheduling_sown_leq_ploughed = pyomo.Constraint(expr=model.hectares_sown <= model.hectares_ploughed)

# Cereal yield constraint (use harvested area)
def cereal_requirement_rule(m):
    return cereal_yield_per_hectare * m.hectares_harvested >= N * cereal_consumption_per_worker
model.cereal_requirement = pyomo.Constraint(rule=cereal_requirement_rule)

# The total labor constraint (optional, can be kept for overall labor)
def labor_constraint_rule(m):
    total_labor = (ploughing_hours_per_hectare * m.hectares_ploughed +
                   sowing_hours_per_hectare * m.hectares_sown +
                   harvest_hours_per_hectare * m.hectares_harvested)
    return total_labor <= N * worker_hours_per_year
model.labor_constraint = pyomo.Constraint(rule=labor_constraint_rule)

# Area constraints: no activity can exceed catchment area
model.area_ploughed_limit = pyomo.Constraint(expr=model.hectares_ploughed <= A)
model.area_sown_limit = pyomo.Constraint(expr=model.hectares_sown <= A)
model.area_harvested_limit = pyomo.Constraint(expr=model.hectares_harvested <= A)

# Sheep age categories and numbers
num_sheep_young = 9
num_sheep_immature = 6
num_sheep_adult = 24

# Land requirements per sheep (hectares)
pasture_req_young = 0.017
meadow_req_young = 0.0126
pasture_req_immature = 0.089
meadow_req_immature = 0.0672
pasture_req_adult = 0.111
meadow_req_adult = 0.084

# Decision variables for total pasture and meadow allocated
model.pasture_allocated = pyomo.Var(domain=pyomo.NonNegativeReals)
model.meadow_allocated = pyomo.Var(domain=pyomo.NonNegativeReals)

# Constraints: total pasture/meadow allocated ≥ sum of requirements for all sheep
model.pasture_requirement = pyomo.Constraint(
    expr=model.pasture_allocated >= (
        num_sheep_young * pasture_req_young +
        num_sheep_immature * pasture_req_immature +
        num_sheep_adult * pasture_req_adult
    )
)
model.meadow_requirement = pyomo.Constraint(
    expr=model.meadow_allocated >= (
        num_sheep_young * meadow_req_young +
        num_sheep_immature * meadow_req_immature +
        num_sheep_adult * meadow_req_adult
    )
)

# Area constraints: pasture + meadow + arable ≤ catchment area
model.total_land_limit = pyomo.Constraint(
    expr=model.pasture_allocated + model.meadow_allocated +
         model.hectares_ploughed <= A
)

# Objective: maximize utility (use harvested area for income)
# For simplicity, assume Z = expected income = cereal_yield_per_hectare * hectares * price_per_liter
# Assume price_per_liter = 1 (can be parameterized), Sigma(I) = 0 for deterministic example
price_per_liter = 1
income = cereal_yield_per_hectare * model.hectares_harvested * price_per_liter
risk_term = risk_aversion * 0  # set to zero for now

model.obj = pyomo.Objective(expr=income - risk_term, sense=pyomo.maximize)

def solve_model():
    solver = pyomo.SolverFactory('scip')
    results = solver.solve(model, tee=True)
    
    if results.solver.termination_condition == pyomo.TerminationCondition.optimal:
        print("Optimal solution found:")
        print(f"Optimal hectares ploughed: {model.hectares_ploughed.value}")
        print(f"Optimal hectares sown: {model.hectares_sown.value}")
        print(f"Optimal hectares harvested: {model.hectares_harvested.value}")
        print(f"Objective: {model.obj.expr()}")
    else:
        print("No optimal solution found.")

if __name__ == "__main__":
    solve_model()