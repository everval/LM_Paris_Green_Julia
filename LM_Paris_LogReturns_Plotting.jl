display("Starting...")

using Pkg
Pkg.activate(pwd())

using LongMemory, MarketData, StatsPlots, DataFrames, TimeSeries, CSV
include("LM_Paris_Functions.jl")

generalmarket = ["AAPL", "MSFT", "GOOG", "AMZN", "BAC", "JPM", "NVO", "PFE", "NVDA", "INTC", "WBD", "NFLX", "DIS", "META", "PRU"]
energy = ["CVX", "XOM", "BP", "SHEL", "COP", "TTE", "TSLA", "F", "PLUG", "FSLR", "SPWR", "BEP", "VWS.CO", "EDPFY", "ORRON.ST"]

energy2 = ["GE", "CSIQ", "DNN", "CWEN", "GPRE", "SEDG", "SU", "ENPH", "NEE", "IFX.DE", "FRHLF", "GLPEF", "PARXF", "REP.DE", "TPL"]

markets = energy2

fechas = [Date(2013, 1, 1) Date(2016, 11, 4) Date(2020, 1, 29) Date(2023, 2, 28)]

## Loading data
nm = length(markets)

begin

    theme(:ggplot2)
    lp = @layout [grid(5, 3)]
    plot(layout=lp)

    for ii = 1:nm
        println("Market: ", markets[ii])
        ### Loading data
        actual = yahoo(markets[ii], YahooOpt(period1=DateTime(fechas[1]))).AdjClose

        lt = log_returns(actual) .^ 2

        plot!(lt, subplot=ii, label=markets[ii], color=:blue, linewidth=1, line=:dot, xticks = false, yticks = false)
        vline!([fechas[2]], subplot=ii, color=:red, linewidth=1, line=:dash, label=false)
        vline!([fechas[3]], subplot=ii, color=:red, linewidth=1, line=:dash, label=false)


    end

    plot!(size=(600, 800))

end

#begin
#ii = 15
#plot!(lt[values(values(lt.<100))], subplot=ii, label=markets[ii], color=:blue, linewidth=1, line=:dot, xticks = false, yticks = false)
#vline!([fechas[2]], subplot=ii, color=:red, linewidth=1, line=:dash, label=false)
#vline!([fechas[3]], subplot=ii, color=:red, linewidth=1, line=:dash, label=false)
#end

plot!(size=(650, 850))

#png("Figures/Energy_LogReturns.png")
png("Figures/Energy2_LogReturns.png")
#png("Figures/General_LogReturns.png")