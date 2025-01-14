display("Starting...")

using Pkg
Pkg.activate(pwd())

using LongMemory, StatsPlots, DataFrames, TimeSeries, CSV
using Plots.PlotMeasures
include("LM_Paris_Functions.jl")
tablota = CSV.read("Results/LM_RandR_LogReturns_CommonBandwidth.csv", DataFrame)

# Confidence intervals
crit_vals = [1.645, 1.96, 2.575]
nticks = length(unique(tablota.Symbol)) - 1
bd = unique(tablota.Bandwidth)
all_markets = unique(tablota.Symbol)[1:end-1]

if length(all_markets) != nticks
    error("Error: Number of markets is not equal to the number of unique symbols")
end

tablita = DataFrame("Symbol" => [], "GPH" => [], "GPH_BR_1" => [], "GPH_BR_2" => [], "LW" => [], "ELW" => [], "Period" => [], "Bandwidth" => [], "Market" => [])

var_pre = collect(tablota[tablota.Symbol.=="Variance".&&tablota.Period.=="PrePA", :][1, 2:6])
var_post = collect(tablota[tablota.Symbol.=="Variance".&&tablota.Period.=="PostPA", :][1, 2:6])
var_covid = collect(tablota[tablota.Symbol.=="Variance".&&tablota.Period.=="Covid", :][1, 2:6])


for ii in 1:nticks
#ii = 31
    market = all_markets[ii]
    ind_market = tablota[tablota.Symbol.==market, :][1, 9]

    # PrePA
    pre = collect(tablota[tablota.Symbol.==market.&&tablota.Period.=="PrePA", :][1, 2:6])
    tstat_pre = abs.(pre ./ sqrt.(var_pre))
    stars_pre = (tstat_pre .> crit_vals[1]) * 1 + (tstat_pre .> crit_vals[2]) * 1 + (tstat_pre .> crit_vals[3]) * 1

    append!(tablita, DataFrame("Symbol" => market, "GPH" => stars_pre[1], "GPH_BR_1" => stars_pre[2], "GPH_BR_2" => stars_pre[3], "LW" => stars_pre[4], "ELW" => stars_pre[5], "Period" => "PrePA", "Bandwidth" => bd, "Market" => ind_market))

    # PostPA
    post = collect(tablota[tablota.Symbol.==market.&&tablota.Period.=="PostPA", :][1, 2:6])
    tstat_post = abs.(post ./ sqrt.(var_post))
    stars_post = (tstat_post .> crit_vals[1]) * 1 + (tstat_post .> crit_vals[2]) * 1 + (tstat_post .> crit_vals[3]) * 1

    append!(tablita, DataFrame("Symbol" => market, "GPH" => stars_post[1], "GPH_BR_1" => stars_post[2], "GPH_BR_2" => stars_post[3], "LW" => stars_post[4], "ELW" => stars_post[5], "Period" => "PostPA", "Bandwidth" => bd, "Market" => ind_market))

    # Covid
    covid = collect(tablota[tablota.Symbol.==market.&&tablota.Period.=="Covid", :][1, 2:6])
    tstat_covid = abs.(covid ./ sqrt.(var_covid))
    stars_covid = (tstat_covid .> crit_vals[1]) * 1 + (tstat_covid .> crit_vals[2]) * 1 + (tstat_covid .> crit_vals[3]) * 1

    append!(tablita, DataFrame("Symbol" => market, "GPH" => stars_covid[1], "GPH_BR_1" => stars_covid[2], "GPH_BR_2" => stars_covid[3], "LW" => stars_covid[4], "ELW" => stars_covid[5], "Period" => "Covid", "Bandwidth" => bd, "Market" => ind_market))

end

tablita

CSV.write("Results/LM_Paris_Routine_RandR_Stars.csv", tablita)

