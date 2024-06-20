display("Starting...")

using Pkg
Pkg.activate(pwd())

using LongMemory, MarketData, StatsPlots, DataFrames, TimeSeries, CSV
include("LM_Paris_Functions.jl")
tablota = CSV.read("Results/LM_Paris_Routine_RandR.csv", DataFrame)

bands = [0.25 0.85]
tablita = tablota[ (tablota.Bandwidth.>= bands[1]) .& (tablota.Bandwidth.<= bands[2]) , :]
#=
generalmarket = ["AAPL", "MSFT", "GOOG"]
energy = ["ENPH", "NEE", "IFX.DE"]
markets = [generalmarket; energy]
=#

generalmarket = ["AAPL", "MSFT", "GOOG", "AMZN", "BAC", "JPM", "NVO", "PFE", "NVDA", "INTC", "WBD", "NFLX", "DIS", "META", "PRU"]
#energy = ["ENPH", "NEE", "IFX.DE"]
energy = ["CVX", "XOM", "BP", "SHEL", "COP", "TTE", "TSLA", "F", "PLUG", "FSLR", "SPWR", "BEP", "VWS.CO", "EDPFY", "ORRON.ST", "GE", "CSIQ", "DNN", "CWEN", "GPRE", "SEDG", "SU", "ENPH", "NEE", "IFX.DE", "FRHLF", "GLPEF", "PARXF", "REP.DE", "TPL"]

markets = [generalmarket; energy]

tablita = stack(tablita,[:GPH, :GPH_BR_1, :GPH_BR_2, :LW, :ELW])

DataFrames.rename!(tablita, [:variable, :value] .=> [:Estimator, :Estimate])
####

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

thissize = (1000, 700)
yls = (-0.2, 0.65) 
lsize = 14
tsize = 20
xsize = 14
myfont = "Computer Modern"
xrt = 20

begin
    theme(:dao)
    p1 = @df tablita_lt_pre_general violin(generalmarket, :Estimate, side=:left, label="PrePA")
    @df tablita_lt_post_general violin!(generalmarket, :Estimate, side=:right, label="PostPA")
    plot!(ylims=yls, size=thissize, legend=:topleft, title="Log-Returns, General Stocks", legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, xrotation =xrt)
    display(p1)
end

begin
    theme(:dao)
    p2 = @df tablita_lt_pre_energy violin(energy[1:15], :Estimate, side=:left, label="PrePA")
    @df tablita_lt_post_energy violin!(energy[1:15], :Estimate, side=:right, label="PostPA")
    plot!(ylims=yls, size=thissize, legend=:topleft, title="Log-Returns, Energy Stocks (1/2)",legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, xrotation =xrt)
    display(p2)
end

begin
    theme(:dao)
    p3 = @df tablita_lt_pre_energy violin(energy[16:30], :Estimate, side=:left, label="PrePA")
    @df tablita_lt_post_energy violin!(energy[16:30], :Estimate, side=:right, label="PostPA")
    plot!(ylims=yls, size=thissize, legend=:topleft, title="Log-Returns, Energy Stocks (2/2)",legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, xrotation =xrt)
    display(p3)
end

begin
    theme(:dao)
    p4 = @df tablita_lt_post_general violin(generalmarket, :Estimate, side=:left, label="PostPA")
    @df tablita_lt_covid_general violin!(generalmarket, :Estimate, side=:right, label="Covid")
    plot!(ylims=yls, size=thissize, legend=:topleft, title="Log-Returns, General Stocks",legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, xrotation =xrt)   
    display(p4)
end


begin
    theme(:dao)
    p5 = @df tablita_lt_post_energy violin(energy[1:15], :Estimate, side=:left, label="PostPA")
    @df tablita_lt_covid_energy violin!(energy[1:15], :Estimate, side=:right, label="Covid")
    plot!(ylims=yls, size=thissize, legend=:topleft, title="Log-Returns, Energy Stocks (1/2)",legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, xrotation =xrt)
    display(p5)
end

begin
    theme(:dao)
    p6 = @df tablita_lt_post_energy violin(energy[16:30], :Estimate, side=:left, label="PostPA")
    @df tablita_lt_covid_energy violin!(energy[16:30], :Estimate, side=:right, label="Covid")
    plot!(ylims=yls, size=thissize, legend=:topleft, title="Log-Returns, Energy Stocks (2/2)",legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, xrotation = xrt)
    display(p6)
end