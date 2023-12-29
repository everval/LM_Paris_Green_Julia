display("Starting...")

using Pkg
Pkg.activate(pwd())

using LongMemory, MarketData, StatsPlots, DataFrames, TimeSeries, CSV
include("LM_Paris_Functions.jl")

generalmarket = ["AAPL", "MSFT", "GOOG", "AMZN", "BAC", "JPM", "NVO", "PFE", "NVDA", "INTC", "WBD", "NFLX", "DIS", "META", "PRU"]
energy = ["CVX", "XOM", "BP", "SHEL", "COP", "TTE", "TSLA", "F", "PLUG", "FSLR", "SPWR", "BEP", "VWS.CO", "EDPFY", "ORRON.ST"]

markets = [generalmarket; energy]

fechas = [Date(2013, 1, 1) Date(2016, 11, 4) Date(2020, 1, 29) Date(2023, 2, 28)]

## Loading data
nm = length(markets)

bds = 0.3:0.005:0.85

nbd = length(bds)

tablita = DataFrame("Symbol" => [], "GPH" => [], "LW" => [], "Period" => [], "Bandwidth" => [], "ReturnType" => [], "Market" => [])

for ii = 1:nm
    println("Market: ", markets[ii])
    ### Loading data
    if (markets[ii] ∈ generalmarket)
        ind_market = "General"
    else
        ind_market = "Energy"
    end

    actual = yahoo(markets[ii], YahooOpt(period1=DateTime(fechas[1]))).AdjClose

    ### Computing returns
    rt = plain_returns(actual) .^ 2
    lt = log_returns(actual) .^ 2

    ### PrePA
    prepa_rt = to(from(rt, Date(fechas[1])), fechas[2])
    prepa_lt = to(from(lt, Date(fechas[1])), fechas[2])

    gphs_rt = zeros(nbd, 1)
    gphs_lt = zeros(nbd, 1)
    lw_rt = zeros(nbd, 1)
    lw_lt = zeros(nbd, 1)
    for jj = 1:nbd
        gphs_rt[jj] = gph_est(values(prepa_rt); m=bds[jj])
        gphs_lt[jj] = gph_est(values(prepa_lt); m=bds[jj])
        lw_rt[jj] = exact_whittle_est(values(prepa_rt); m=bds[jj])
        lw_lt[jj] = exact_whittle_est(values(prepa_lt); m=bds[jj])
    end

    append!(tablita, DataFrame("Symbol" => markets[ii], "GPH" => gphs_rt[:], "LW" => lw_rt[:], "Period" => "PrePA", "Bandwidth" => bds[:], "ReturnType" => "Returns", "Market" => ind_market))

    append!(tablita, DataFrame("Symbol" => markets[ii], "GPH" => gphs_lt[:], "LW" => lw_lt[:], "Period" => "PrePA", "Bandwidth" => bds[:], "ReturnType" => "LogReturns", "Market" => ind_market))

    ### PostPA

    postpa_rt = to(from(rt, Date(fechas[2])), fechas[3])
    postpa_lt = to(from(lt, Date(fechas[2])), fechas[3])

    gphs_rt = zeros(nbd, 1)
    gphs_lt = zeros(nbd, 1)
    lw_rt = zeros(nbd, 1)
    lw_lt = zeros(nbd, 1)
    for jj = 1:nbd
        gphs_rt[jj] = gph_est(values(postpa_rt); m=bds[jj])
        gphs_lt[jj] = gph_est(values(postpa_lt); m=bds[jj])
        lw_rt[jj] = exact_whittle_est(values(postpa_rt); m=bds[jj])
        lw_lt[jj] = exact_whittle_est(values(postpa_lt); m=bds[jj])
    end

    append!(tablita, DataFrame("Symbol" => markets[ii], "GPH" => gphs_rt[:], "LW" => lw_rt[:], "Period" => "PostPA", "Bandwidth" => bds[:], "ReturnType" => "Returns", "Market" => ind_market))

    append!(tablita, DataFrame("Symbol" => markets[ii], "GPH" => gphs_lt[:], "LW" => lw_lt[:], "Period" => "PostPA", "Bandwidth" => bds[:], "ReturnType" => "LogReturns", "Market" => ind_market))
    ### Covid

    covid_rt = to(from(rt, Date(fechas[3])), fechas[4])
    covid_lt = to(from(lt, Date(fechas[3])), fechas[4])

    gphs_rt = zeros(nbd, 1)
    gphs_lt = zeros(nbd, 1)
    lw_rt = zeros(nbd, 1)
    lw_lt = zeros(nbd, 1)
    for jj = 1:nbd
        gphs_rt[jj] = gph_est(values(covid_rt); m=bds[jj])
        gphs_lt[jj] = gph_est(values(covid_lt); m=bds[jj])
        lw_rt[jj] = exact_whittle_est(values(covid_rt); m=bds[jj])
        lw_lt[jj] = exact_whittle_est(values(covid_lt); m=bds[jj])
    end

    append!(tablita, DataFrame("Symbol" => markets[ii], "GPH" => gphs_rt[:], "LW" => lw_rt[:], "Period" => "Covid", "Bandwidth" => bds[:], "ReturnType" => "Returns", "Market" => ind_market))

    append!(tablita, DataFrame("Symbol" => markets[ii], "GPH" => gphs_lt[:], "LW" => lw_lt[:], "Period" => "Covid", "Bandwidth" => bds[:], "ReturnType" => "LogReturns", "Market" => ind_market))

end

CSV.write("Results/LM_Paris_Routine.csv", tablita)

begin
    tablita_rt_pre = choose_options(tablita, "PrePA", "Returns")
    tablita_rt_post = choose_options(tablita, "PostPA", "Returns")
    tablita_rt_covid = choose_options(tablita, "Covid", "Returns")

    tablita_lt_pre = choose_options(tablita, "PrePA", "LogReturns")
    tablita_lt_post = choose_options(tablita, "PostPA", "LogReturns")
    tablita_lt_covid = choose_options(tablita, "Covid", "LogReturns")

end

te = choose_options_market_bdws(tablita, "PrePA", "Returns", "Energy", [0.45, 0.46])

begin
theme(:ggplot2)
p0 = @df tablita_lt_pre violin(markets, :LW, side=:left, label="PrePA")
@df tablita_lt_post violin!(markets, :LW, side=:right, label="PostPA")
plot!(ylims=(-0.2, 0.7), size=(1200, 500), legend=:topleft, title="Log-Returns, Exact Whittle Estimator, General Stocks")
display(p0)
#@df tablita_rt_pre dotplot!(string.(":",markets), :GPH, side=:left, label = "", marker=(:black,stroke(0)), mode=:uniform)
#@df tablita_rt_post dotplot!(string.(":",markets), :GPH, side=:right, label = "", marker=(:gray,stroke(0)), mode=:uniform)
end

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

begin
    theme(:ggplot2)
    p1 = @df tablita_lt_pre_general violin(markets, :LW, side=:left, label="PrePA")
    @df tablita_lt_post_general violin!(markets, :LW, side=:right, label="PostPA")
    plot!(ylims=(-0.15, 0.5), size=(1200, 500), legend=:topleft, title="Log-Returns, Exact Whittle Estimator, General Stocks")
    display(p1)
end


begin
    theme(:ggplot2)
    p2 = @df tablita_lt_pre_energy violin(markets, :LW, side=:left, label="PrePA")
    @df tablita_lt_post_energy violin!(markets, :LW, side=:right, label="PostPA")
    plot!(ylims=(-0.15, 0.6), size=(1200, 500), legend=:topleft, title="Log-Returns, Exact Whittle Estimator, Energy Stocks")
    display(p2)
end

