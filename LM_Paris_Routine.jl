using LongMemory, MarketData, StatsPlots, DataFrames, TimeSeries, CSV
include("LM_Paris_Functions.jl")

### Defining markets and dates
markets = ["CVX", "XOM", "BP", "SHEL", "COP", "TTE", "TSLA", "F", "PLUG", "FSLR", "SPWR", "BEP"]
fechas = [Date(2013, 1, 1) Date(2016, 11, 9) Date(2020, 1, 29) Date(2023, 2, 28)]

## Loading data
nm = length(markets)

bds = 0.35:0.005:0.85

nbd = length(bds)

tablita = DataFrame("Symbol" => [], "GPH" => [], "LW" => [], "Period" => [], "Bandwidth" => [], "ReturnType" => [])

for ii = 1:nm
    println("Market: ", markets[ii])
    ### Loading data
    actual = yahoo(markets[ii], YahooOpt(period1=DateTime(fechas[1]))).AdjClose

    ### Computing returns
    rt = plain_returns(actual).^2
    lt = log_returns(actual).^2

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

    append!(tablita, DataFrame("Symbol" => markets[ii], "GPH" => gphs_rt[:], "LW" => lw_rt[:], "Period" => "PrePA", "Bandwidth" => bds[:], "ReturnType" => "Returns"))

    append!(tablita, DataFrame("Symbol" => markets[ii], "GPH" => gphs_lt[:], "LW" => lw_lt[:], "Period" => "PrePA", "Bandwidth" => bds[:], "ReturnType" => "LogReturns"))

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

    append!(tablita, DataFrame("Symbol" => markets[ii], "GPH" => gphs_rt[:], "LW" => lw_rt[:], "Period" => "PostPA", "Bandwidth" => bds[:], "ReturnType" => "Returns"))

    append!(tablita, DataFrame("Symbol" => markets[ii], "GPH" => gphs_lt[:], "LW" => lw_lt[:], "Period" => "PostPA", "Bandwidth" => bds[:], "ReturnType" => "LogReturns"))
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

    append!(tablita, DataFrame("Symbol" => markets[ii], "GPH" => gphs_rt[:], "LW" => lw_rt[:], "Period" => "Covid", "Bandwidth" => bds[:], "ReturnType" => "Returns"))

    append!(tablita, DataFrame("Symbol" => markets[ii], "GPH" => gphs_lt[:], "LW" => lw_lt[:], "Period" => "Covid", "Bandwidth" => bds[:], "ReturnType" => "LogReturns"))

end

CSV.write("LM_Paris_Routine.csv", tablita)

begin
tablita_rt_pre = choose_options(tablita, "PrePA", "Returns")
tablita_rt_post = choose_options(tablita, "PostPA", "Returns")
tablita_rt_covid = choose_options(tablita, "Covid", "Returns")

tablita_lt_pre = choose_options(tablita, "PrePA", "LogReturns")
tablita_lt_post = choose_options(tablita, "PostPA", "LogReturns")
tablita_lt_covid = choose_options(tablita, "Covid", "LogReturns")

end

theme(:ggplot2)
@df tablita_rt_pre violin(string.(":",markets), :LW, side=:left, label = "PrePA")
@df tablita_rt_post violin!(string.(":",markets), :LW, side=:right, label = "PostPA")
plot!(ylims = (-0.2, 0.8))
#@df tablita_rt_pre dotplot!(string.(":",markets), :GPH, side=:left, label = "", marker=(:black,stroke(0)), mode=:uniform)
#@df tablita_rt_post dotplot!(string.(":",markets), :GPH, side=:right, label = "", marker=(:gray,stroke(0)), mode=:uniform)



function choose_options(tablita, period, return_type)
    return tablita[(tablita.Period .== period) .& (tablita.ReturnType .== return_type), :]
end
