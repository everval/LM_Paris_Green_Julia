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
  tablita_lt_pre_general = choose_options_market(tablita, "PrePA", "LogReturns", "General")
  tablita_lt_post_general = choose_options_market(tablita, "PostPA", "LogReturns", "General")
  tablita_lt_covid_general = choose_options_market(tablita, "Covid", "LogReturns", "General")

  tablita_lt_pre_energy = choose_options_market(tablita, "PrePA", "LogReturns", "Energy")
  tablita_lt_post_energy = choose_options_market(tablita, "PostPA", "LogReturns", "Energy")
  tablita_lt_covid_energy = choose_options_market(tablita, "Covid", "LogReturns", "Energy")
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
tlpre = tablita_lt_pre_energy
tlpre = tlpre[tlpre.Bandwidth.∈[bands], :]

tlpoe = tablita_lt_post_energy
tlpoe = tlpoe[tlpoe.Bandwidth.∈[bands], :]

tlcve = tablita_lt_covid_energy
tlcve = tlcve[tlcve.Bandwidth.∈[bands], :]

begin
  theme(:dao)
  p1 = @df tlpre violin(energy, :Estimate, side=:right, label="PrePA", alpha=0.65, color=:brown,permute = (:x, :y))
  @df tlpoe violin!(energy, :Estimate, side=:left, label="PostPA", alpha=0.65, color=:green,permute = (:x, :y))
#  @df tlcve violin!(energy[1:30], :Estimate, side=:right, label="Covid", alpha = 0.5, color = :red, permute = (:x, :y))
  @df tlpre dotplot!(energy[1:30], :Estimate, side = :right, label = "", mode = :density,permute = (:x, :y),alpha=0.5, color=:brown)
  @df tlpoe dotplot!(energy[1:30], :Estimate, side = :left, label = "", mode = :density,permute = (:x, :y),alpha=0.5, color=:green)
#  @df tlcve dotplot!(energy[1:30], :Estimate, side = :right, label = "", mode = :uniform, permute = (:x, :y),alpha=0.5, color=:red)
  violin!(xlims=yls, size=thissize, legend=:topright, title="Energy Stocks (Log-Returns)", legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, yrotation=xrt, bottom_margin=2px, left_margin=5px, permute = (:x, :y))
  #png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_Energy_LogReturns_Paris_Multiverse_All.png")
  yticks!(p1,collect(0.5:1:30),unique(tlpre.Symbol))
#  display(p1)

end

## General Stocks[30:-1:1]

tlprg = tablita_lt_pre_general
tlprg = tlprg[tlprg.Bandwidth.∈[bands], :]

tlpog = tablita_lt_post_general
tlpog = tlpog[tlpog.Bandwidth.∈[bands], :]

tlcvg = tablita_lt_covid_general
tlcvg = tlcvg[tlcvg.Bandwidth.∈[bands], :]

begin
  theme(:dao)
  p2 = @df tlprg violin(generalmarket, :Estimate, side=:right, label="PrePA", alpha=0.65, color= :blue,permute = (:x, :y))
  @df tlpog violin!(generalmarket, :Estimate, side=:left, label="PostPA", alpha=0.65, color=:black,permute = (:x, :y))
#  @df tlcvg violin!(generalmarket, :Estimate, side=:right, label="Covid", alpha = 0.5, color = :green,permute = (:x, :y))
  @df tlprg dotplot!(generalmarket, :Estimate, side = :right, label = "", mode = :density,permute = (:x, :y),alpha=0.5, color=:blue)
  @df tlpog dotplot!(generalmarket, :Estimate, side = :left, label = "", mode = :density,permute = (:x, :y),alpha=0.5, color=:black)
#  @df tlcvg dotplot!(generalmarket, :Estimate, side = :right, label = "", mode = :uniform, permute = (:x, :y),alpha=0.5, color=:green)

  violin!(xlims=yls, size=thissize, legend=:topright, title="General Stocks (Log-Returns)", legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, yrotation=xrt, bottom_margin=2px, left_margin=5px,permute = (:x, :y))
  #png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_General_LogReturns_Paris_Multiverse_All.png")
  yticks!(p2,collect(0.5:1:30),unique(tlprg.Symbol))
#  display(p2)
end

pl = @layout [a b]
display(plot(p2, p1, layout=pl))
png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_LogReturns_Paris_Multiverse_All.png")

##### COVID
#####


begin
  theme(:dao)
  p3 = @df tlpoe violin(energy, :Estimate, side=:right, label="PostPA", alpha=0.65, color=:green,permute = (:x, :y))
  @df tlcve violin!(energy, :Estimate, side=:left, label="Covid", alpha = 0.65, color = :red, permute = (:x, :y))
#  @df tlpre dotplot!(energy[1:30], :Estimate, side = :right, label = "", mode = :density,permute = (:x, :y),alpha=0.5, color=:blue)
  @df tlpoe dotplot!(energy, :Estimate, side = :right, label = "", mode = :density,permute = (:x, :y),alpha=0.5, color=:green)
  @df tlcve dotplot!(energy, :Estimate, side = :left, label = "", mode = :uniform, permute = (:x, :y),alpha=0.5, color=:red)
  violin!(xlims=yls, size=thissize, legend=:topright, title="Energy Stocks (Log-Returns)", legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, yrotation=xrt, bottom_margin=2px, left_margin=5px, permute = (:x, :y))
  #png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_Energy_LogReturns_Paris_Multiverse_All.png")
  yticks!(p3,collect(0.5:1:30),unique(tlpoe.Symbol))
#  display(p3)

end

begin
  theme(:dao)
  p4 = @df tlpog violin(generalmarket, :Estimate, side=:right, label="PostPA", alpha=0.65, color=:black,permute = (:x, :y))
  @df tlcvg violin!(generalmarket, :Estimate, side=:left, label="Covid", alpha = 0.65, color = :purple, permute = (:x, :y))
#  @df tlprg dotplot!(generalmarket, :Estimate, side = :right, label = "", mode = :density,permute = (:x, :y),alpha=0.5, color=:red)
  @df tlpog dotplot!(generalmarket, :Estimate, side = :right, label = "", mode = :density,permute = (:x, :y),alpha=0.5, color=:black)
  @df tlcvg dotplot!(generalmarket, :Estimate, side = :left, label = "", mode = :uniform, permute = (:x, :y),alpha=0.5, color=:purple)

  violin!(xlims=yls, size=thissize, legend=:topright, title="General Stocks (Log-Returns)", legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, yrotation=xrt, bottom_margin=2px, left_margin=5px,permute = (:x, :y))
  #png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_General_LogReturns_Paris_Multiverse_All.png")
  yticks!(p4,collect(0.5:1:30),unique(tlpog.Symbol))
#  display(p4)
end


pl = @layout [a b]
plot(p4, p3, layout=pl)
png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_LogReturns_Covid_Multiverse_All.png")