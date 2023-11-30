using CSV, DataFrames, StatsPlots, TimeSeries
include("LM_Paris_Functions.jl")
tablita = CSV.read("Results/LM_Paris_Routine.csv", DataFrame)

generalmarket = ["AAPL", "MSFT", "GOOG", "AMZN", "BAC", "JPM", "NVO", "PFE", "NVDA", "INTC", "WBD", "NFLX", "DIS", "META", "PRU"]
energy = ["CVX", "XOM", "BP", "SHEL", "COP", "TTE", "TSLA", "F", "PLUG", "FSLR", "SPWR", "BEP", "VWS", "EDPFY", "ORRON"]
markets = [generalmarket; energy]
fechas = [Date(2013, 1, 1) Date(2016, 11, 9) Date(2020, 1, 29) Date(2023, 2, 28)]

begin
    tablita_rt_pre = choose_options(tablita, "PrePA", "Returns")
    tablita_rt_post = choose_options(tablita, "PostPA", "Returns")
    tablita_rt_covid = choose_options(tablita, "Covid", "Returns")

    tablita_lt_pre = choose_options(tablita, "PrePA", "LogReturns")
    tablita_lt_post = choose_options(tablita, "PostPA", "LogReturns")
    tablita_lt_covid = choose_options(tablita, "Covid", "LogReturns")

end


begin
    theme(:ggplot2)
    @df tablita_lt_pre violin(markets, :LW, side=:left, label="PrePA")
    @df tablita_lt_post violin!(markets, :LW, side=:right, label="PostPA")
    @df tablita_rt_pre dotplot!(markets, :GPH, side=:left, label="", marker=(:black, stroke(0)), mode=:uniform)
    @df tablita_rt_post dotplot!(markets, :GPH, side=:right, label="", marker=(:gray, stroke(0)), mode=:uniform)
    plot!(ylims=(-0.2, 0.7), size=(1200, 500), legend=:topleft, title="Log-Returns, Exact Whittle Estimator, All Stocks", xrotation=90)
end

psize = (800, 300)

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

## Plots PRE-POST, GENERAL, LOG-RETURNS

begin
    theme(:ggplot2)
    p1 = @df tablita_lt_pre_general violin(generalmarket, :LW, side=:left, label="PrePA", linewidth=0)
    @df tablita_lt_post_general violin!(generalmarket, :LW, side=:right, label="PostPA", linewidth=0)
    plot!(ylims=(-0.2, 0.55), size=psize, legend=:topleft, title="Log-Returns, Exact Whittle Estimator, General Stocks", xrotation=0)
    xticks!(0.5:1:14.5, generalmarket)
    display(p1)
    png("Figures/LM_Paris_General_LW_PRE_LogReturns.png")
end

begin
    theme(:ggplot2)
    p1 = @df tablita_lt_pre_general violin(generalmarket, :GPH, side=:left, label="PrePA", linewidth=0)
    @df tablita_lt_post_general violin!(generalmarket, :GPH, side=:right, label="PostPA", linewidth=0)
    plot!(ylims=(-0.2, 0.65), size=psize, legend=:topleft, title="Log-Returns, GPH Estimator, General Stocks", xrotation=0)
    xticks!(0.5:1:14.5, generalmarket)
    display(p1)
    png("Figures/LM_Paris_General_GPH_PRE_LogReturns.png")
end


## Plots POST-COVID, GENERAL, LOG-RETURNS

begin
    theme(:ggplot2)
    p1 = @df tablita_lt_post_general violin(generalmarket, :LW, side=:left, label="PostPA", linewidth=0)
    @df tablita_lt_covid_general violin!(generalmarket, :LW, side=:right, label="PostPHEIC", linewidth=0)
    plot!(ylims=(-0.2, 0.6), size=psize, legend=:topleft, title="Log-Returns, Exact Whittle Estimator, General Stocks", xrotation=0)
    xticks!(0.5:1:14.5, generalmarket)
    display(p1)
    png("Figures/LM_Paris_General_LW_POST_LogReturns.png")
end

begin
    theme(:ggplot2)
    p1 = @df tablita_lt_post_general violin(generalmarket, :GPH, side=:left, label="PostPA", linewidth=0)
    @df tablita_lt_covid_general violin!(generalmarket, :GPH, side=:right, label="PostPHEIC", linewidth=0)
    plot!(ylims=(-0.2, 0.65), size=psize, legend=:topleft, title="Log-Returns, GPH Estimator, General Stocks", xrotation=0)
    xticks!(0.5:1:14.5, generalmarket)
    display(p1)
    png("Figures/LM_Paris_General_GPH_POST_LogReturns.png")
end


## Plots PRE-POST, ENERGY, LOG-RETURNS

begin
    theme(:ggplot2)
    p2 = @df tablita_lt_pre_energy violin(energy, :LW, side=:left, label="PrePA", linewidth=0)
    @df tablita_lt_post_energy violin!(energy, :LW, side=:right, label="PostPA", linewidth=0)
    plot!(ylims=(-0.2, 0.622), size=psize, legend=:topleft, title="Log-Returns, Exact Whittle Estimator, Energy Stocks", xrotation=0)
    xticks!(0.5:1:14.5, energy)
    display(p2)
    png("Figures/LM_Paris_Energy_LW_PRE_LogReturns.png")
end

begin
    theme(:ggplot2)
    p2 = @df tablita_lt_pre_energy violin(energy, :GPH, side=:left, label="PrePA", linewidth=0)
    @df tablita_lt_post_energy violin!(energy, :GPH, side=:right, label="PostPA", linewidth=0)
    plot!(ylims=(-0.1, 0.75), size=psize, legend=:topleft, title="Log-Returns, GPH Estimator, Energy Stocks", xrotation=0)
    xticks!(0.5:1:14.5, energy)
    display(p2)
    png("Figures/LM_Paris_Energy_GPH_PRE_LogReturns.png")
end


## Plots POST-COVID, ENERGY, LOG-RETURNS

begin
    theme(:ggplot2)
    p2 = @df tablita_lt_post_energy violin(energy, :LW, side=:left, label="PostPA", linewidth=0)
    @df tablita_lt_covid_energy violin!(energy, :LW, side=:right, label="PostPHEIC", linewidth=0)
    plot!(ylims=(-0.2, 0.8), size=psize, legend=:topleft, title="Log-Returns, Exact Whittle Estimator, Energy Stocks", xrotation=0)
    xticks!(0.5:1:14.5, energy)
    display(p2)
    png("Figures/LM_Paris_Energy_LW_POST_LogReturns.png")
end

begin
    theme(:ggplot2)
    p2 = @df tablita_lt_post_energy violin(energy, :GPH, side=:left, label="PostPA", linewidth=0)
    @df tablita_lt_covid_energy violin!(energy, :GPH, side=:right, label="PostPHEIC", linewidth=0)
    plot!(ylims=(-0.05, 0.8), size=psize, legend=:topleft, title="Log-Returns, GPH Estimator, Energy Stocks", xrotation=0)
    xticks!(0.5:1:14.5, energy)
    display(p2)
    png("Figures/LM_Paris_Energy_GPH_POST_LogReturns.png")
end

## Plots PRE-POST, GENERAL, RETURNS

begin
    theme(:ggplot2)
    p1 = @df tablita_rt_pre_general violin(generalmarket, :LW, side=:left, label="PrePA", linewidth=0)
    @df tablita_rt_post_general violin!(generalmarket, :LW, side=:right, label="PostPA", linewidth=0)
    plot!(ylims=(-0.2, 0.5), size=psize, legend=:topleft, title="Returns, Exact Whittle Estimator, General Stocks", xrotation=0)
    xticks!(0.5:1:14.5, generalmarket)
    display(p1)
    png("Figures/LM_Paris_General_LW_PRE_Returns.png")
end

begin
    theme(:ggplot2)
    p1 = @df tablita_rt_pre_general violin(generalmarket, :GPH, side=:left, label="PrePA", linewidth=0)
    @df tablita_rt_post_general violin!(generalmarket, :GPH, side=:right, label="PostPA", linewidth=0)
    plot!(ylims=(-0.2, 0.6), size=psize, legend=:topleft, title="Returns, GPH Estimator, General Stocks", xrotation=0)
    xticks!(0.5:1:14.5, generalmarket)
    display(p1)
    png("Figures/LM_Paris_General_GPH_PRE_Returns.png")
end


## Plots POST-COVID, GENERAL, RETURNS

begin
    theme(:ggplot2)
    p1 = @df tablita_rt_post_general violin(generalmarket, :LW, side=:left, label="PostPA", linewidth=0)
    @df tablita_rt_covid_general violin!(generalmarket, :LW, side=:right, label="PostPHEIC", linewidth=0)
    plot!(ylims=(-0.2, 0.62), size=psize, legend=:topleft, title="Returns, Exact Whittle Estimator, General Stocks", xrotation=0)
    xticks!(0.5:1:14.5, generalmarket)
    display(p1)
    png("Figures/LM_Paris_General_LW_POST_Returns.png")
end

begin
    theme(:ggplot2)
    p1 = @df tablita_rt_post_general violin(generalmarket, :GPH, side=:left, label="PostPA", linewidth=0)
    @df tablita_rt_covid_general violin!(generalmarket, :GPH, side=:right, label="PostPHEIC", linewidth=0)
    plot!(ylims=(-0.2, 0.7), size=psize, legend=:topleft, title="Returns, GPH Estimator, General Stocks", xrotation=0)
    xticks!(0.5:1:14.5, generalmarket)
    display(p1)
    png("Figures/LM_Paris_General_GPH_POST_Returns.png")
end


## Plots PRE-POST, ENERGY, RETURNS

begin
    theme(:ggplot2)
    p2 = @df tablita_rt_pre_energy violin(energy, :LW, side=:left, label="PrePA", linewidth=0)
    @df tablita_rt_post_energy violin!(energy, :LW, side=:right, label="PostPA", linewidth=0)
    plot!(ylims=(-0.15, 0.6), size=psize, legend=:topleft, title="Returns, Exact Whittle Estimator, Energy Stocks", xrotation=0)
    xticks!(0.5:1:14.5, energy)
    display(p2)
    png("Figures/LM_Paris_Energy_LW_PRE_Returns.png")
end

begin
    theme(:ggplot2)
    p2 = @df tablita_rt_pre_energy violin(energy, :GPH, side=:left, label="PrePA", linewidth=0)
    @df tablita_rt_post_energy violin!(energy, :GPH, side=:right, label="PostPA", linewidth=0)
    plot!(ylims=(-0.05, 0.7), size=psize, legend=:topleft, title="Returns, GPH Estimator, Energy Stocks", xrotation=0)
    xticks!(0.5:1:14.5, energy)
    display(p2)
    png("Figures/LM_Paris_Energy_GPH_PRE_Returns.png")
end


## Plots POST-COVID, ENERGY, RETURNS

begin
    theme(:ggplot2)
    p2 = @df tablita_rt_post_energy violin(energy, :LW, side=:left, label="PostPA", linewidth=0)
    @df tablita_rt_covid_energy violin!(energy, :LW, side=:right, label="PostPHEIC", linewidth=0)
    plot!(ylims=(-0.2, 0.7), size=psize, legend=:topleft, title="Returns, Exact Whittle Estimator, Energy Stocks", xrotation=0)
    xticks!(0.5:1:14.5, energy)
    display(p2)
    png("Figures/LM_Paris_Energy_LW_POST_Returns.png")
end

begin
    theme(:ggplot2)
    p2 = @df tablita_rt_post_energy violin(energy, :GPH, side=:left, label="PostPA", linewidth=0)
    @df tablita_rt_covid_energy violin!(energy, :GPH, side=:right, label="PostPHEIC", linewidth=0)
    plot!(ylims=(-0.05, 0.7), size=psize, legend=:topleft, title="Returns, GPH Estimator, Energy Stocks", xrotation=0)
    xticks!(0.5:1:14.5, energy)
    display(p2)
    png("Figures/LM_Paris_Energy_GPH_POST_Returns.png")
end

#### Tables
begin
    smaller_table_logreturns = choose_options_bdws(tablita, "LogReturns", [0.796 0.804])
    CSV.write("Results/LM_Paris_LogReturns_OptBandwidth.csv", smaller_table_logreturns)

    smaller_table_returns = choose_options_bdws(tablita, "Returns", [0.796 0.804])
    CSV.write("Results/LM_Paris_Returns_OptBandwidth.csv", smaller_table_returns)
end