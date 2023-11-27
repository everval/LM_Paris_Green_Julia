using LongMemory, MarketData, StatsPlots, DataFrames, TimeSeries, CSV
include("LM_Paris_Functions.jl")

### Defining markets and dates
markets = ["CVX", "XOM", "BP", "SHEL", "COP", "TTE", "TSLA", "F", "PLUG", "FSLR", "SPWR", "BEP"]
fechas = [Date(2013, 1, 1) Date(2016, 11, 9) Date(2020, 1, 29) Date(2023, 2, 28)]

## Loading data
nm = length(markets)

bds = 0.30:0.005:0.85

nbd = length(bds)


### GPH estimation
begin
    tablon_pre_gph_rt = DataFrame()
    tablon_pre_gph_lt = DataFrame()
    tablon_pre_lw_rt = DataFrame()
    tablon_pre_lw_lt = DataFrame()

    tablon_post_gph_rt = DataFrame()
    tablon_post_gph_lt = DataFrame()
    tablon_post_lw_rt = DataFrame()
    tablon_post_lw_lt = DataFrame()

    tablon_covid_gph_rt = DataFrame()
    tablon_covid_gph_lt = DataFrame()
    tablon_covid_lw_rt = DataFrame()
    tablon_covid_lw_lt = DataFrame()
end

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

    tablon_pre_gph_rt[!, markets[ii]] = gphs_rt[:]
    tablon_pre_gph_lt[!, markets[ii]] = gphs_lt[:]
    tablon_pre_lw_rt[!, markets[ii]] = lw_rt[:]
    tablon_pre_lw_lt[!, markets[ii]] = lw_lt[:]

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

    tablon_post_gph_rt[!, markets[ii]] = gphs_rt[:]
    tablon_post_gph_lt[!, markets[ii]] = gphs_lt[:]
    tablon_post_lw_rt[!, markets[ii]] = lw_rt[:]
    tablon_post_lw_lt[!, markets[ii]] = lw_lt[:]

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

    tablon_covid_gph_rt[!, markets[ii]] = gphs_rt[:]
    tablon_covid_gph_lt[!, markets[ii]] = gphs_lt[:]
    tablon_covid_lw_rt[!, markets[ii]] = lw_rt[:]
    tablon_covid_lw_lt[!, markets[ii]] = lw_lt[:]

end


tablon_pre_gph_rt[!, markets[ii]] = gphs_rt[:]

tablita = DataFrame("Symbol" => [], "GPH" => [], "LW" => [], "Period" => [], "Bandwidth" => [], "ReturnType" => [])


append!(tablita, DataFrame("Symbol" => markets[ii], "GPH" => gphs_rt[:], "LW" => lw_rt[:], "Period" => "PrePA", "Bandwidth" => bds[:], "ReturnType" => "Returns"))

append!(tablita, DataFrame("Symbol" => markets[ii], "GPH" => gphs_lt[:], "LW" => lw_lt[:], "Period" => "PrePA", "Bandwidth" => bds[:], "ReturnType" => "LogReturns"))

@df tablon_pre_gph_rt violin(string.(":",markets[1]))


violin

theme(:ggplot2)
violin(tablon_covid_gph_lt[!,markets[1]])



