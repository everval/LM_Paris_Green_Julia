display("Starting...")

using Pkg
Pkg.activate(pwd())

using LongMemory, MarketData, StatsPlots, DataFrames, TimeSeries, CSV
include("LM_Paris_Functions.jl")

generalmarket = ["MSFT", "AAPL", "NVDA", "AMZN", "META", "GOOG", "LLY", "AVGO", "JPM", "UNH", "V", "PG", "COST", "MA", "JNJ"]
generalmarket2 = ["HD", "MRK", "ABBV", "WMT", "NFLX", "BAC", "AMD", "KO", "ADBE", "CRM", "PEP", "QCOM", "ORCL", "TMO", "WFC"]

energy = ["CVX", "XOM", "BP", "SHEL", "COP", "TTE", "LIN", "ECOPETROL.CL", "PLUG", "FSLR", "SPWR", "BEP", "VWS.CO", "EDPFY", "TPL"]
energy2 = ["GE", "CSIQ", "DNN", "CWEN", "GPRE", "SEDG", "SU", "ENPH", "NEE", "IFX.DE", "FRHLF", "GLPEF", "PARXF", "REP.DE", "ORRON.ST"]


fechas = [Date(2013, 1, 1) Date(2016, 11, 4) Date(2020, 1, 29) Date(2023, 2, 28)]

## Loading data
lsize = 8
psize = (800, 800)
myfont = "Computer Modern"

begin
    markets = [generalmarket; generalmarket2]
    nm = length(markets)
    theme(:ggplot2)
    lp = @layout [grid(6, 5)]
    p1 = plot(layout=lp)

    for ii = 1:nm
        println("Market: ", markets[ii])
        actual = yahoo(markets[ii], YahooOpt(period1=DateTime(fechas[1]), period2=DateTime(fechas[4]))).AdjClose

        lt = log_returns(actual) .^ 2

        plot!(lt, subplot=ii, label=markets[ii], color=:blue, linewidth=1, line=:dot, xticks=false, yticks=false, size=psize, legendfontsize=lsize, legendfontfamily=myfont)
        vline!([fechas[2]], subplot=ii, color=:red, linewidth=1, line=:dash, label=false)
        vline!([fechas[3]], subplot=ii, color=:red, linewidth=1, line=:dash, label=false)

    end
    png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/General_LogReturns.png")
end

begin
    markets = [energy; energy2]
    nm = length(markets)
    theme(:ggplot2)
    lp = @layout [grid(6, 5)]
    plot(layout=lp)

    for ii = 1:nm
        println("Market: ", markets[ii])
        actual = yahoo(markets[ii], YahooOpt(period1=DateTime(fechas[1]), period2=DateTime(fechas[4]))).AdjClose

        lt = log_returns(actual) .^ 2

        if markets[ii] .!= "ECOPETROL.CL"
            plot!(lt, subplot=ii, label=markets[ii], color=:blue, linewidth=1, line=:dot, xticks=false, yticks=false, size=psize, legendfontsize=lsize, legendfontfamily=myfont)
            vline!([fechas[2]], subplot=ii, color=:red, linewidth=1, line=:dash, label=false)
            vline!([fechas[3]], subplot=ii, color=:red, linewidth=1, line=:dash, label=false)
        else
            markets[ii] = "ECOPETROL"
            plot!(lt, subplot=ii, label=markets[ii], color=:blue, linewidth=1, line=:dot, xticks=false, yticks=false, size=psize, legendfontsize=lsize, legendfontfamily=myfont)
            vline!([fechas[2]], subplot=ii, color=:red, linewidth=1, line=:dash, label=false)
            vline!([fechas[3]], subplot=ii, color=:red, linewidth=1, line=:dash, label=false)
        end

    end
    png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/Energy_LogReturns.png")
end

#=
begin
    markets = generalmarket2
    nm = length(markets)
    theme(:ggplot2)
    lp = @layout [grid(5, 3)]
    plot(layout=lp)

    for ii = 1:nm
        println("Market: ", markets[ii])
        actual = yahoo(markets[ii], YahooOpt( period1 = DateTime(fechas[1]) , period2 = DateTime(fechas[4]) ) ).AdjClose

        lt = log_returns(actual) .^ 2

        plot!(lt, subplot=ii, label=markets[ii], color=:blue, linewidth=1, line=:dot, xticks = false, yticks = false, size = psize, legendfontsize=lsize, legendfontfamily=myfont)
        vline!([fechas[2]], subplot=ii, color=:red, linewidth=1, line=:dash, label=false)
        vline!([fechas[3]], subplot=ii, color=:red, linewidth=1, line=:dash, label=false)


    end
    png("Figures/General2_LogReturns.png")
end
=#

#=
begin
    markets = energy2
    nm = length(markets)
    theme(:ggplot2)
    lp = @layout [grid(5, 3)]
    plot(layout=lp)

    for ii = 1:nm
        println("Market: ", markets[ii])
        actual = yahoo(markets[ii], YahooOpt( period1 = DateTime(fechas[1]) , period2 = DateTime(fechas[4]) ) ).AdjClose

        lt = log_returns(actual) .^ 2

        plot!(lt, subplot=ii, label=markets[ii], color=:blue, linewidth=1, line=:dot, xticks = false, yticks = false, size = psize, legendfontsize=lsize, legendfontfamily=myfont)
        vline!([fechas[2]], subplot=ii, color=:red, linewidth=1, line=:dash, label=false)
        vline!([fechas[3]], subplot=ii, color=:red, linewidth=1, line=:dash, label=false)


    end
    png("Figures/Energy2_LogReturns.png")
end
=#