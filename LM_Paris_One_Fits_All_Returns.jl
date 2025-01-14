display("Starting...")

using Pkg
Pkg.activate(pwd())

using LongMemory, MarketData, StatsPlots, DataFrames, TimeSeries, CSV
using Plots.PlotMeasures
include("LM_Paris_Functions.jl")
tablota = CSV.read("Results/LM_Paris_Routine_RandR_Updated.csv", DataFrame)

bands = [0.45 0.85]
tablita = tablota[(tablota.Bandwidth.>=bands[1]).&(tablota.Bandwidth.<=bands[end]), :]


generalmarket = ["MSFT", "AAPL", "NVDA", "AMZN", "META", "GOOG", "LLY", "AVGO", "JPM", "UNH", "V", "PG", "COST", "MA", "JNJ", "HD", "MRK", "ABBV", "WMT", "NFLX", "BAC", "AMD", "KO", "ADBE", "CRM", "PEP", "QCOM", "ORCL", "TMO", "WFC"]

energy = ["CVX", "XOM", "BP", "SHEL", "COP", "TTE", "LIN", "ECOPETROL", "PLUG", "FSLR", "SPWR", "BEP", "VWS.CO", "EDPFY", "TPL", "GE", "CSIQ", "DNN", "CWEN", "GPRE", "SEDG", "SU", "ENPH", "NEE", "IFX.DE", "FRHLF", "GLPEF", "PARXF", "REP.DE", "ORRON"]

energy[energy.=="ECOPETROL.CL"] .= "ECOPETROL"

markets = [generalmarket; energy]

tablita = stack(tablita, [:GPH, :GPH_BR_1, :GPH_BR_2, :LW, :ELW])

DataFrames.rename!(tablita, [:variable, :value] .=> [:Estimator, :Estimate])
####

tablita[tablita.Symbol.=="ECOPETROL.CL", :Symbol] .= "ECOPETROL"
#tablita[tablita.Symbol.=="ORRON.ST", :Symbol] .= "ORRON"

begin
  tablita_rt_pre_general = choose_options_market(tablita, "PrePA", "Returns", "General")
  tablita_rt_post_general = choose_options_market(tablita, "PostPA", "Returns", "General")
  tablita_rt_covid_general = choose_options_market(tablita, "Covid", "Returns", "General")

  tablita_rt_pre_energy = choose_options_market(tablita, "PrePA", "Returns", "Energy")
  tablita_rt_post_energy = choose_options_market(tablita, "PostPA", "Returns", "Energy")
  tablita_rt_covid_energy = choose_options_market(tablita, "Covid", "Returns", "Energy")

end

begin
  thissize = (1000, 1200)
  yls = (-0.2, 0.65)
  lsize = 12
  tsize = 16
  xsize = 12
  myfont = "Computer Modern"
  xrt = 45
end

bands = 0.45:0.05:0.85


## Emnergy Stocks
trpre = tablita_rt_pre_energy
trpre = trpre[trpre.Bandwidth.∈[bands], :]

trpoe = tablita_rt_post_energy
trpoe = trpoe[trpoe.Bandwidth.∈[bands], :]

trcve = tablita_rt_covid_energy
trcve = trcve[trcve.Bandwidth.∈[bands], :]

begin
  theme(:dao)
  p1 = @df trpre violin(energy, :Estimate, side=:right, label="PrePA", alpha=0.65, color=:brown,permute = (:x, :y))
  @df trpoe violin!(energy, :Estimate, side=:left, label="PostPA", alpha=0.65, color=:green,permute = (:x, :y))
#  @df trcve violin!(energy[1:30], :Estimate, side=:right, label="Covid", alpha = 0.5, color = :red, permute = (:x, :y))
  @df trpre dotplot!(energy[1:30], :Estimate, side = :right, label = "", mode = :density,permute = (:x, :y),alpha=0.5, color=:brown)
  @df trpoe dotplot!(energy[1:30], :Estimate, side = :left, label = "", mode = :density,permute = (:x, :y),alpha=0.5, color=:green)
#  @df trcve dotplot!(energy[1:30], :Estimate, side = :right, label = "", mode = :uniform, permute = (:x, :y),alpha=0.5, color=:red)
  violin!(xlims=yls, size=thissize, legend=:topright, title="Energy Stocks (Returns)", legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, yrotation=xrt, bottom_margin=2px, left_margin=5px, permute = (:x, :y))
  #png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_Energy_LogReturns_Paris_Multiverse_All.png")
  yticks!(p1,collect(0.5:1:30),unique(trpre.Symbol))
#  display(p1)

end

## General Stocks[30:-1:1]

trprg = tablita_rt_pre_general
trprg = trprg[trprg.Bandwidth.∈[bands], :]

trpog = tablita_rt_post_general
trpog = trpog[trpog.Bandwidth.∈[bands], :]

trcvg = tablita_rt_covid_general
trcvg = trcvg[trcvg.Bandwidth.∈[bands], :]

begin
  theme(:dao)
  p2 = @df trprg violin(generalmarket, :Estimate, side=:right, label="PrePA", alpha=0.65, color= :blue,permute = (:x, :y))
  @df trpog violin!(generalmarket, :Estimate, side=:left, label="PostPA", alpha=0.65, color=:black,permute = (:x, :y))
#  @df trcvg violin!(generalmarket, :Estimate, side=:right, label="Covid", alpha = 0.5, color = :green,permute = (:x, :y))
  @df trprg dotplot!(generalmarket, :Estimate, side = :right, label = "", mode = :density,permute = (:x, :y),alpha=0.5, color=:blue)
  @df trpog dotplot!(generalmarket, :Estimate, side = :left, label = "", mode = :density,permute = (:x, :y),alpha=0.5, color=:black)
#  @df trcvg dotplot!(generalmarket, :Estimate, side = :right, label = "", mode = :uniform, permute = (:x, :y),alpha=0.5, color=:green)

  violin!(xlims=yls, size=thissize, legend=:topright, title="General Stocks (Returns)", legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, yrotation=xrt, bottom_margin=2px, left_margin=5px,permute = (:x, :y))
  #png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_General_LogReturns_Paris_Multiverse_All.png")
  yticks!(p2,collect(0.5:1:30),unique(trprg.Symbol))
#  display(p2)
end

pl = @layout [a b]
display(plot(p2, p1, layout=pl))
png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_Returns_Paris_Multiverse_All.png")

##### COVID
#####


begin
  theme(:dao)
  p3 = @df trpoe violin(energy, :Estimate, side=:right, label="PostPA", alpha=0.65, color=:green,permute = (:x, :y))
  @df trcve violin!(energy, :Estimate, side=:left, label="Covid", alpha = 0.65, color = :red, permute = (:x, :y))
#  @df trpre dotplot!(energy[1:30], :Estimate, side = :right, label = "", mode = :density,permute = (:x, :y),alpha=0.5, color=:blue)
  @df trpoe dotplot!(energy, :Estimate, side = :right, label = "", mode = :density,permute = (:x, :y),alpha=0.5, color=:green)
  @df trcve dotplot!(energy, :Estimate, side = :left, label = "", mode = :uniform, permute = (:x, :y),alpha=0.5, color=:red)
  violin!(xlims=yls, size=thissize, legend=:topright, title="Energy Stocks (Returns)", legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, yrotation=xrt, bottom_margin=2px, left_margin=5px, permute = (:x, :y))
  #png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_Energy_LogReturns_Paris_Multiverse_All.png")
  yticks!(p3,collect(0.5:1:30),unique(trpoe.Symbol))
#  display(p3)

end

begin
  theme(:dao)
  p4 = @df trpog violin(generalmarket, :Estimate, side=:right, label="PostPA", alpha=0.65, color=:black,permute = (:x, :y))
  @df trcvg violin!(generalmarket, :Estimate, side=:left, label="Covid", alpha = 0.65, color = :purple, permute = (:x, :y))
#  @df trprg dotplot!(generalmarket, :Estimate, side = :right, label = "", mode = :density,permute = (:x, :y),alpha=0.5, color=:red)
  @df trpog dotplot!(generalmarket, :Estimate, side = :right, label = "", mode = :density,permute = (:x, :y),alpha=0.5, color=:black)
  @df trcvg dotplot!(generalmarket, :Estimate, side = :left, label = "", mode = :uniform, permute = (:x, :y),alpha=0.5, color=:purple)

  violin!(xlims=yls, size=thissize, legend=:topright, title="General Stocks (Returns)", legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, yrotation=xrt, bottom_margin=2px, left_margin=5px,permute = (:x, :y))
  #png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_General_LogReturns_Paris_Multiverse_All.png")
  yticks!(p4,collect(0.5:1:30),unique(trpog.Symbol))
#  display(p4)
end


pl = @layout [a b]
plot(p4, p3, layout=pl)
png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_Returns_Covid_Multiverse_All.png")