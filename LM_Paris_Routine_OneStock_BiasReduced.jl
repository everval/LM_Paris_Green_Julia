display("Starting...")

using Pkg
Pkg.activate(pwd())

using LongMemory, MarketData, StatsPlots, DataFrames, TimeSeries, CSV
include("LM_Paris_Functions.jl")

generalmarket = [ "MSFT", "AAPL", "NVDA", "AMZN", "META", "GOOG", "LLY", "AVGO", "JPM", "TSLA", "UNH", "V", "PG", "COST", "MA", "JNJ", "HD", "MRK", "ABBV", "WMT", "NFLX", "BAC", "AMD", "KO", "ADBE", "CRM", "PEP", "QCOM", "ORCL", "TMO" ]
#=["AAPL", "MSFT", "GOOG", "AMZN", "BAC", "JPM", "NVO", "PFE", "NVDA", "INTC", "WBD", "NFLX", "DIS", "META", "PRU"]=#

energy = ["CVX", "XOM", "BP", "SHEL", "COP", "TTE", "TSLA", "ECOPETROL.CL", "PLUG", "FSLR", "SPWR", "BEP", "VWS.CO", "EDPFY", "ORRON.ST", "GE", "CSIQ", "DNN", "CWEN", "GPRE", "SEDG", "SU", "ENPH", "NEE", "IFX.DE", "FRHLF", "GLPEF", "PARXF", "REP.DE", "TPL"]

markets = [generalmarket; energy]

fechas = [Date(2013, 1, 1) Date(2016, 11, 4) Date(2020, 1, 29) Date(2023, 2, 28)]

## Loading data
nm = length(markets)

bds = 0.3:0.005:0.85

nbd = length(bds)

tablita = DataFrame("Symbol" => [], "GPH" => [], "GPH_BR_1" => [], "GPH_BR_2" => [], "LW" => [], "ELW" => [], "Period" => [], "Bandwidth" => [], "ReturnType" => [], "Market" => [])

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
    prepa_rt = collect(skipmissing(values(to(from(rt, Date(fechas[1])), fechas[2]))))
    prepa_lt = collect(skipmissing(values(to(from(lt, Date(fechas[1])), fechas[2]))))

    gphs_rt = zeros(nbd, 1)
    gphs_lt = zeros(nbd, 1)
    gph_br1_rt = zeros(nbd, 1)
    gph_br1_lt = zeros(nbd, 1)
    gph_br2_rt = zeros(nbd, 1)
    gph_br2_lt = zeros(nbd, 1)
    lw_rt = zeros(nbd, 1)
    lw_lt = zeros(nbd, 1)
    elw_rt = zeros(nbd, 1)
    elw_lt = zeros(nbd, 1)
    for jj = 1:nbd
        gphs_rt[jj] = gph_est(values(prepa_rt); m=bds[jj])
        gphs_lt[jj] = gph_est(values(prepa_lt); m=bds[jj])
        gph_br1_rt[jj] = gph_est(values(prepa_rt); m=bds[jj], br=1)
        gph_br1_lt[jj] = gph_est(values(prepa_lt); m=bds[jj], br=1)
        gph_br2_rt[jj] = gph_est(values(prepa_rt); m=bds[jj], br=2)
        gph_br2_lt[jj] = gph_est(values(prepa_lt); m=bds[jj], br=2)
        lw_rt[jj] = whittle_est(values(prepa_rt); m=bds[jj])
        lw_lt[jj] = whittle_est(values(prepa_lt); m=bds[jj])
        elw_rt[jj] = exact_whittle_est(values(prepa_rt); m=bds[jj])
        elw_lt[jj] = exact_whittle_est(values(prepa_lt); m=bds[jj])
    end

    append!(tablita, DataFrame("Symbol" => markets[ii], "GPH" => gphs_rt[:], "GPH_BR_1" => gph_br1_rt[:], "GPH_BR_2" => gph_br2_rt[:], "LW" => lw_rt[:], "ELW" => elw_rt[:], "Period" => "PrePA", "Bandwidth" => bds[:], "ReturnType" => "Returns", "Market" => ind_market))

    append!(tablita, DataFrame("Symbol" => markets[ii], "GPH" => gphs_lt[:], "GPH_BR_1" => gph_br1_lt[:], "GPH_BR_2" => gph_br2_lt[:], "LW" => lw_lt[:], "ELW" => elw_lt[:], "Period" => "PrePA", "Bandwidth" => bds[:], "ReturnType" => "LogReturns", "Market" => ind_market))

    ### PostPA

    postpa_rt = collect(skipmissing(values(to(from(rt, Date(fechas[2])), fechas[3]))))
    postpa_lt = collect(skipmissing(values(to(from(lt, Date(fechas[2])), fechas[3]))))

    gphs_rt = zeros(nbd, 1)
    gphs_lt = zeros(nbd, 1)
    gph_br1_rt = zeros(nbd, 1)
    gph_br1_lt = zeros(nbd, 1)
    gph_br2_rt = zeros(nbd, 1)
    gph_br2_lt = zeros(nbd, 1)
    lw_rt = zeros(nbd, 1)
    lw_lt = zeros(nbd, 1)
    elw_rt = zeros(nbd, 1)
    elw_lt = zeros(nbd, 1)
    for jj = 1:nbd
        gphs_rt[jj] = gph_est(values(postpa_rt); m=bds[jj])
        gphs_lt[jj] = gph_est(values(postpa_lt); m=bds[jj])
        gph_br1_rt[jj] = gph_est(values(postpa_rt); m=bds[jj], br=1)
        gph_br1_lt[jj] = gph_est(values(postpa_lt); m=bds[jj], br=1)
        gph_br2_rt[jj] = gph_est(values(postpa_rt); m=bds[jj], br=2)
        gph_br2_lt[jj] = gph_est(values(postpa_lt); m=bds[jj], br=2)
        lw_rt[jj] = whittle_est(values(postpa_rt); m=bds[jj])
        lw_lt[jj] = whittle_est(values(postpa_lt); m=bds[jj])
        elw_rt[jj] = exact_whittle_est(values(postpa_rt); m=bds[jj])
        elw_lt[jj] = exact_whittle_est(values(postpa_lt); m=bds[jj])
    end

    append!(tablita, DataFrame("Symbol" => markets[ii], "GPH" => gphs_rt[:], "GPH_BR_1" => gph_br1_rt[:], "GPH_BR_2" => gph_br2_rt[:], "LW" => lw_rt[:], "ELW" => elw_rt[:], "Period" => "PostPA", "Bandwidth" => bds[:], "ReturnType" => "Returns", "Market" => ind_market))

    append!(tablita, DataFrame("Symbol" => markets[ii], "GPH" => gphs_lt[:], "GPH_BR_1" => gph_br1_lt[:], "GPH_BR_2" => gph_br2_lt[:], "LW" => lw_lt[:], "ELW" => elw_lt[:], "Period" => "PostPA", "Bandwidth" => bds[:], "ReturnType" => "LogReturns", "Market" => ind_market))
    ### Covid

    covid_rt = collect(skipmissing(values(to(from(rt, Date(fechas[3])), fechas[4]))))
    covid_lt = collect(skipmissing(values(to(from(lt, Date(fechas[3])), fechas[4]))))

    gphs_rt = zeros(nbd, 1)
    gphs_lt = zeros(nbd, 1)
    gph_br1_rt = zeros(nbd, 1)
    gph_br1_lt = zeros(nbd, 1)
    gph_br2_rt = zeros(nbd, 1)
    gph_br2_lt = zeros(nbd, 1)
    lw_rt = zeros(nbd, 1)
    lw_lt = zeros(nbd, 1)
    elw_rt = zeros(nbd, 1)
    elw_lt = zeros(nbd, 1)
    for jj = 1:nbd
        gphs_rt[jj] = gph_est(values(covid_rt); m=bds[jj])
        gphs_lt[jj] = gph_est(values(covid_lt); m=bds[jj])
        gph_br1_rt[jj] = gph_est(values(covid_rt); m=bds[jj], br=1)
        gph_br1_lt[jj] = gph_est(values(covid_lt); m=bds[jj], br=1)
        gph_br2_rt[jj] = gph_est(values(covid_rt); m=bds[jj], br=2)
        gph_br2_lt[jj] = gph_est(values(covid_lt); m=bds[jj], br=2)
        lw_rt[jj] = whittle_est(values(covid_rt); m=bds[jj])
        lw_lt[jj] = whittle_est(values(covid_lt); m=bds[jj])
        elw_rt[jj] = exact_whittle_est(values(covid_rt); m=bds[jj])
        elw_lt[jj] = exact_whittle_est(values(covid_lt); m=bds[jj])
    end

    append!(tablita, DataFrame("Symbol" => markets[ii], "GPH" => gphs_rt[:], "GPH_BR_1" => gph_br1_rt[:], "GPH_BR_2" => gph_br2_rt[:], "LW" => lw_rt[:], "ELW" => elw_rt[:], "Period" => "Covid", "Bandwidth" => bds[:], "ReturnType" => "Returns", "Market" => ind_market))

    append!(tablita, DataFrame("Symbol" => markets[ii], "GPH" => gphs_lt[:], "GPH_BR_1" => gph_br1_lt[:], "GPH_BR_2" => gph_br2_lt[:], "LW" => lw_lt[:], "ELW" => elw_lt[:], "Period" => "Covid", "Bandwidth" => bds[:], "ReturnType" => "LogReturns", "Market" => ind_market))

end

display("It worked!")

## 

display("Plotting...")


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

## Log-

begin
    theme(:dao)
    p1 = @df tablita_lt_pre_general violin(generalmarket, :Estimate, side=:left, label="PrePA")
    @df tablita_lt_post_general violin!(generalmarket, :Estimate, side=:right, label="PostPA")
    plot!(ylims=yls, size=thissize, legend=:topleft, title="Log-Returns, General Stocks", legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, xrotation =xrt)
    display(p1)
end

begin
    theme(:dao)
    p2 = @df tablita_lt_pre_energy violin(energy, :Estimate, side=:left, label="PrePA")
    @df tablita_lt_post_energy violin!(energy, :Estimate, side=:right, label="PostPA")
    plot!(ylims=yls, size=thissize, legend=:topleft, title="Log-Returns, Energy Stocks (1/2)",legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, xrotation =xrt)
    display(p2)
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
    p5 = @df tablita_lt_post_energy violin(energy, :Estimate, side=:left, label="PostPA")
    @df tablita_lt_covid_energy violin!(energy, :Estimate, side=:right, label="Covid")
    plot!(ylims=yls, size=thissize, legend=:topleft, title="Log-Returns, Energy Stocks (1/2)",legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, xrotation =xrt)
    display(p5)
end
