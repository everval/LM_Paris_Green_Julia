display("Starting...")

using Pkg
Pkg.activate(pwd())

using LongMemory, MarketData, StatsPlots, DataFrames, TimeSeries, CSV
include("LM_Paris_Functions.jl")

markets = ["MSFT"]

fechas = [Date(2013, 1, 1) Date(2016, 11, 4) Date(2020, 1, 29) Date(2023, 2, 28)]

## Loading data
nm = length(markets)

bds = [0.5, 0.8]

nbd = length(bds)

tablita = DataFrame("Symbol" => [], "GPH" => [], "GPH_BR_1" => [], "GPH_BR_2" => [], "LW" => [], "ELW" => [], "Period" => [], "Bandwidth" => [])

for ii = 1:nm 

    actual = yahoo(markets[ii], YahooOpt(period1=DateTime(fechas[1]))).AdjClose

    ### Computing returns
    lt = log_returns(actual) .^ 2

    ### PrePA
    prepa_lt = collect(skipmissing(values(to(from(lt, Date(fechas[1])), fechas[2]))))


    gphs_lt = zeros(nbd, 1)
    gph_br1_lt = zeros(nbd, 1)
    gph_br2_lt = zeros(nbd, 1)
    lw_lt = zeros(nbd, 1)
    elw_lt = zeros(nbd, 1)
    for jj = 1:nbd
        gphs_lt[jj] = gph_est_variance(values(prepa_lt); m=bds[jj])
        gph_br1_lt[jj] = gph_est_variance(values(prepa_lt); m=bds[jj], br=1)
        gph_br2_lt[jj] = gph_est_variance(values(prepa_lt); m=bds[jj], br=2)
        lw_lt[jj] = whittle_est_variance(values(prepa_lt); m=bds[jj])
        elw_lt[jj] = exact_whittle_est_variance(values(prepa_lt); m=bds[jj])
    end

    append!(tablita, DataFrame("Symbol" => markets[ii], "GPH" => gphs_lt[:], "GPH_BR_1" => gph_br1_lt[:], "GPH_BR_2" => gph_br2_lt[:], "LW" => lw_lt[:], "ELW" => elw_lt[:], "Period" => "PrePA", "Bandwidth" => bds[:]))

    ### PostPA
    postpa_lt = collect(skipmissing(values(to(from(lt, Date(fechas[2])), fechas[3]))))

    gphs_lt = zeros(nbd, 1)
    gph_br1_lt = zeros(nbd, 1)
    gph_br2_lt = zeros(nbd, 1)
    lw_lt = zeros(nbd, 1)
    elw_lt = zeros(nbd, 1)
    for jj = 1:nbd
        gphs_lt[jj] = gph_est_variance(values(postpa_lt); m=bds[jj])
        gph_br1_lt[jj] = gph_est_variance(values(postpa_lt); m=bds[jj], br=1)
        gph_br2_lt[jj] = gph_est_variance(values(postpa_lt); m=bds[jj], br=2)
        lw_lt[jj] = whittle_est_variance(values(postpa_lt); m=bds[jj])
        elw_lt[jj] = exact_whittle_est_variance(values(postpa_lt); m=bds[jj])
    end

    append!(tablita, DataFrame("Symbol" => markets[ii], "GPH" => gphs_lt[:], "GPH_BR_1" => gph_br1_lt[:], "GPH_BR_2" => gph_br2_lt[:], "LW" => lw_lt[:], "ELW" => elw_lt[:], "Period" => "PostPA", "Bandwidth" => bds[:]))

    ### Covid
    covid_lt = collect(skipmissing(values(to(from(lt, Date(fechas[3])), fechas[4]))))

    gphs_lt = zeros(nbd, 1)
    gph_br1_lt = zeros(nbd, 1)
    gph_br2_lt = zeros(nbd, 1)
    lw_lt = zeros(nbd, 1)
    elw_lt = zeros(nbd, 1)
    for jj = 1:nbd
        gphs_lt[jj] = gph_est_variance(values(covid_lt); m=bds[jj])
        gph_br1_lt[jj] = gph_est_variance(values(covid_lt); m=bds[jj], br=1)
        gph_br2_lt[jj] = gph_est_variance(values(covid_lt); m=bds[jj], br=2)
        lw_lt[jj] = whittle_est_variance(values(covid_lt); m=bds[jj])
        elw_lt[jj] = exact_whittle_est_variance(values(covid_lt); m=bds[jj])
    end

    append!(tablita, DataFrame("Symbol" => markets[ii], "GPH" => gphs_lt[:], "GPH_BR_1" => gph_br1_lt[:], "GPH_BR_2" => gph_br2_lt[:], "LW" => lw_lt[:], "ELW" => elw_lt[:], "Period" => "Covid", "Bandwidth" => bds[:]))

end

sort!(tablita, [:Bandwidth])
CSV.write("Results/LM_Paris_Variances_RandR.csv", tablita)

