display("Structural change test...")

using Pkg
Pkg.activate(pwd())

using LongMemory, MarketData, StatsPlots, DataFrames, TimeSeries, CSV
include("LM_Paris_Functions.jl")

generalmarket = ["MSFT", "AAPL", "NVDA", "AMZN", "META", "GOOG", "LLY", "AVGO", "JPM", "UNH", "V", "PG", "COST", "MA", "JNJ", "HD", "MRK", "ABBV", "WMT", "NFLX", "BAC", "AMD", "KO", "ADBE", "CRM", "PEP", "QCOM", "ORCL", "TMO", "WFC"]

energy = ["CVX", "XOM", "BP", "SHEL", "COP", "TTE", "LIN", "ECOPETROL.CL", "PLUG", "FSLR", "SPWR", "BEP", "VWS.CO", "EDPFY", "ORRON.ST", "GE", "CSIQ", "DNN", "CWEN", "GPRE", "SEDG", "SU", "ENPH", "NEE", "IFX.DE", "FRHLF", "GLPEF", "PARXF", "REP.DE", "TPL"]

other = "TSLA"

markets = [generalmarket; energy; other]

fechas = [Date(2013, 1, 1) Date(2016, 11, 4) Date(2020, 1, 29) Date(2023, 2, 28)]

## Loading data
nm = length(markets)

bds = 0.3:0.005:0.85

nbd = length(bds)

tablita = DataFrame("Symbol" => [], "Index_Change" => [], "Date_Change" => [], "ReturnType" => [], "Market" => [])

for ii = 1:nm

    println("Market: ", markets[ii])
    ### Loading data
    if (markets[ii] ∈ generalmarket)
        ind_market = "General"
    elseif (markets[ii] ∈ energy)
        ind_market = "Energy"
    else
        ind_market = "Other"
    end

    actual = yahoo(markets[ii], YahooOpt(period1=DateTime(fechas[1]), period2=DateTime(fechas[3]))).AdjClose

    ### Computing returns
    rt = plain_returns(actual) .^ 2
    lt = log_returns(actual) .^ 2

    ### PrePA
    precovid_rt = collect(skipmissing(values(to(from(rt, Date(fechas[1])), fechas[3]))))
    precovid_lt = collect(skipmissing(values(to(from(lt, Date(fechas[1])), fechas[3]))))

    stchange = lm_change_test(precovid_rt; uplim=0.2, lowlim=0.2)
    datechange = timestamp(actual[stchange])

    append!(tablita, DataFrame("Symbol" => markets[ii], "Index_Change" => stchange, "Date_Change" => datechange, "ReturnType" => "LogReturns", "Market" => ind_market))

end
CSV.write("Results/LM_Structural_Change.csv", tablita)

display("It worked!")
display(tablita)

## Plotting
begin
    theme(:dao)
    display("Plotting...")

     boxplot([Date.(tablita[tablita.Market .== "Energy", :Date_Change]) Date.(tablita[tablita.Market .== "General", :Date_Change])], title="Change of Persistence Test", xlabel="", ylabel="", legend=:topleft, size=(800, 300), legendfontsize=12, titlefontsize=14, tickfontsize=12, titlefontfamily="Computer Modern", label="", legendfontfamily="Computer Modern", tickfontfamily="Computer Modern", permute=(:x, :y), alpha=0.5) 
     yticks!([1, 2], ["Energy", "General"])
     vline!([fechas[1]], color=:gray, linewidth=2, line=:dot, label="")
    vline!([fechas[2]], color=:red, linewidth=2, line=:dash, label="Paris Agreement")
    vline!([fechas[3]], color=:gray, linewidth=2, line=:dot, label=false)

    png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_Structural_Changes_Sectors.png")
end

begin
    theme(:dao)
    display("Plotting...")

     boxplot( Date.(tablita[!, :Date_Change]), title="Change of Persistence Test", xlabel="", ylabel="", legend=:topleft, size=(800, 300), legendfontsize=12, titlefontsize=14, tickfontsize=12, titlefontfamily="Computer Modern", label="", legendfontfamily="Computer Modern", tickfontfamily="Computer Modern", permute=(:x, :y), alpha=0.5) 
     yticks!([1], ["All"])
     vline!([fechas[1]], color=:gray, linewidth=2, line=:dot, label="")
    vline!([fechas[2]], color=:red, linewidth=2, line=:dash, label="Paris Agreement")
    vline!([fechas[3]], color=:gray, linewidth=2, line=:dot, label=false)

    png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_Structural_Changes_All.png")
end
