display("Starting...")

using Pkg
Pkg.activate(pwd())

using LongMemory, MarketData, StatsPlots, DataFrames, TimeSeries, CSV
include("LM_Paris_Functions.jl")
tablota = CSV.read("Results/LM_Paris_Routine_RandR.csv", DataFrame)

bands = [0.25 0.85]

tablita = tablota[ (tablota.Bandwidth.>= bands[1]) .& (tablota.Bandwidth.<= bands[2]) , :]

generalmarket = ["AAPL", "MSFT", "GOOG"]
energy = ["ENPH", "NEE", "IFX.DE"]
markets = [generalmarket; energy]


generalmarket = ["AAPL", "MSFT", "GOOG", "AMZN", "BAC", "JPM", "NVO", "PFE", "NVDA", "INTC", "WBD", "NFLX", "DIS", "META", "PRU"]
#energy = ["ENPH", "NEE", "IFX.DE"]
energy = ["CVX", "XOM", "BP", "SHEL", "COP", "TTE", "TSLA", "F", "PLUG", "FSLR", "SPWR", "BEP", "VWS.CO", "EDPFY", "ORRON.ST", "GE", "CSIQ", "DNN", "CWEN", "GPRE", "SEDG", "SU", "ENPH", "NEE", "IFX.DE"]

markets = [generalmarket; energy]

begin
    tablita_rt_pre = choose_options(tablita, "PrePA", "Returns")
    tablita_rt_post = choose_options(tablita, "PostPA", "Returns")
    tablita_rt_covid = choose_options(tablita, "Covid", "Returns")

    tablita_lt_pre = choose_options(tablita, "PrePA", "LogReturns")
    tablita_lt_post = choose_options(tablita, "PostPA", "LogReturns")
    tablita_lt_covid = choose_options(tablita, "Covid", "LogReturns")
end

te = choose_options_market_bdws(tablita, "PostPA", "Returns", "Energy", [0.49, 0.501])

begin
    tablita_rt_pre_general = choose_options_market(tablita, "PrePA", "Returns", "General")
    tablita_rt_post_general = choose_options_market(tablita, "PostPA", "Returns", "General")
    tablita_rt_covid_general = choose_options_market(tablita, "Covid", "Returns", "General")

    tablita_lt_pre_general = choose_options_market(tablita, "PrePA", "LogReturns", "General")
    tablita_lt_post_general = choose_options_market(tablita, "PostPA", "LogReturns", "General")
    tablita_lt_covid_general = choose_options_market(tablita, "Covid", "LogReturns", "General")

    tablita_rt_pre_energy = choose_options_market(tablita, "PrePA", "Returns", "Energy")
    tablita_rt_post_energy = choose_options_market(tablita, "PostPA", "Returns", "Energy")
    tablita_rt_covid_energy = choose_options_market(tablita, "Covid", "Returns", "Energy")

    tablita_lt_pre_energy = choose_options_market(tablita, "PrePA", "LogReturns", "Energy")
    tablita_lt_post_energy = choose_options_market(tablita, "PostPA", "LogReturns", "Energy")
    tablita_lt_covid_energy = choose_options_market(tablita, "Covid", "LogReturns", "Energy")
end

yls = (-0.25, 0.6) 

begin
    theme(:ggplot2)
    p1 = @df tablita_lt_pre_general violin(generalmarket, :ELW, side=:left, label="PrePA")
    @df tablita_lt_post_general violin!(generalmarket, :ELW, side=:right, label="PostPA")
    plot!(ylims=yls, size=(1200, 500), legend=:topleft, title="Log-Returns, Exact Whittle Estimator, General Stocks")
    display(p1)
end


begin
    theme(:ggplot2)
    p2 = @df tablita_lt_pre_energy violin(energy, :ELW, side=:left, label="PrePA")
    @df tablita_lt_post_energy violin!(energy, :ELW, side=:right, label="PostPA")
    plot!(ylims=yls, size=(1200, 500), legend=:topleft, title="Log-Returns, Exact Whittle Estimator, Energy Stocks")
    display(p2)
end





#=
Est = "LW"

begin
theme(:ggplot2)
p0 = @df tablita_lt_pre violin(generalmarket, :LW, side=:left, label="PrePA")
@df tablita_lt_post violin!(generalmarket, :LW, side=:right, label="PostPA")
#@df tablita_rt_pre dotplot!(string.(":",markets), :GPH, side=:left, label = "", marker=(:black,stroke(0)), mode=:uniform)
#@df tablita_rt_post dotplot!(string.(":",markets), :GPH, side=:right, label = "", marker=(:gray,stroke(0)), mode=:uniform)
plot!(ylim = yls, legend=:topleft, title="Log-Returns, ELW Estimator, General Stocks")
display(p0)

p1 = @df tablita_lt_pre violin(energy, :LW, side=:left, label="PrePA")
    @df tablita_lt_post violin!(energy, :LW, side=:right, label="PostPA")
    #@df tablita_rt_pre dotplot!(string.(":",markets), :GPH, side=:left, label = "", marker=(:black,stroke(0)), mode=:uniform)
    #@df tablita_rt_post dotplot!(string.(":",markets), :GPH, side=:right, label = "", marker=(:gray,stroke(0)), mode=:uniform)
    plot!(ylim = yls,  legend=:topleft, title="Log-Returns, ELW Estimator, Energy Stocks")
    display(p1)

l = @layout [a ; b]
plot(p0, p1, layout = l, size = (1200, 500) )

end
=#