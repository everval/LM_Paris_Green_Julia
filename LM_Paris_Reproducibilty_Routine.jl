display("Starting whole project...")

include("LM_Paris_LogReturns_Plotting_RandR.jl")
include("LM_Paris_Routine_RandR_BiasReduced.jl")
include("LM_Paris_Consolidate_Estimators_RandR_BiasReduced.jl")
include("LM_Paris_Routine_OneStock_BiasReduced.jl")
include("LM_Structural_Changes.jl")

display("Finished!")