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

energy = ["CVX", "XOM", "BP", "SHEL", "COP", "TTE", "LIN", "ECOPETROL.CL", "PLUG", "FSLR", "SPWR", "BEP", "VWS.CO", "EDPFY", "TPL", "GE", "CSIQ", "DNN", "CWEN", "GPRE", "SEDG", "SU", "ENPH", "NEE", "IFX.DE", "FRHLF", "GLPEF", "PARXF", "REP.DE", "ORRON.ST"]

energy[energy .== "ECOPETROL.CL"] .= "ECOPETROL"

markets = [generalmarket; energy]

tablita = stack(tablita, [:GPH, :GPH_BR_1, :GPH_BR_2, :LW, :ELW])

DataFrames.rename!(tablita, [:variable, :value] .=> [:Estimator, :Estimate])
####

tablita[tablita.Symbol.=="ECOPETROL.CL", :Symbol] .= "ECOPETROL"

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
    thissize = (1000, 400)
    yls = (-0.2, 0.65)
    lsize = 12
    tsize = 16
    xsize = 12
    myfont = "Computer Modern"
    xrt = 20
end

## Log-

begin

    begin
        theme(:dao)
        p1 = @df tablita_lt_pre_general violin(generalmarket[1:15], :Estimate, side=:left, label="PrePA")
        @df tablita_lt_post_general violin!(generalmarket[1:15], :Estimate, side=:right, label="PostPA")
        violin!(ylims=yls, size=thissize, legend=:topleft, title="Log-Returns, General Stocks (1/2)", legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, xrotation=xrt, bottom_margin=37px)
        png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_General_LogReturns_Paris_Multiverse_All.png")
        display(p1)
    end

    begin
        theme(:dao)
        p1a = @df tablita_lt_pre_general violin(generalmarket[16:30], :Estimate, side=:left, label="PrePA")
        @df tablita_lt_post_general violin!(generalmarket[16:30], :Estimate, side=:right, label="PostPA")
        violin!(ylims=yls, size=thissize, legend=:topleft, title="Log-Returns, General Stocks (2/2)", legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, xrotation=xrt, bottom_margin=37px)
        png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_General2_LogReturns_Paris_Multiverse_All.png")
        display(p1a)
    end

    begin
        theme(:dao)
        p2 = @df tablita_lt_pre_energy violin(energy[1:15], :Estimate, side=:left, label="PrePA")
        @df tablita_lt_post_energy violin!(energy[1:15], :Estimate, side=:right, label="PostPA")
        violin!(ylims=yls, size=thissize, legend=:topleft, title="Log-Returns, Energy Stocks (1/2)", legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, xrotation=xrt, bottom_margin=28px)
        png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_Energy_LogReturns_Paris_Multiverse_All.png")
        display(p2)
     end

    begin
        theme(:dao)
        p2a = @df tablita_lt_pre_energy violin(energy[16:30], :Estimate, side=:left, label="PrePA")
        @df tablita_lt_post_energy violin!(energy[16:30], :Estimate, side=:right, label="PostPA")
        violin!(ylims=yls, size=thissize, legend=:topleft, title="Log-Returns, Energy Stocks (2/2)", legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, xrotation=xrt, bottom_margin=31px)
        png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_Energy2_LogReturns_Paris_Multiverse_All.png")
        display(p2a)
    end

    begin
        theme(:dao)
        p3 = @df tablita_lt_post_general violin(generalmarket[1:15], :Estimate, side=:left, label="PostPA")
        @df tablita_lt_covid_general violin!(generalmarket[1:15], :Estimate, side=:right, label="Covid")
        violin!(ylims=yls, size=thissize, legend=:topleft, title="Log-Returns, General Stocks (1/2)", legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, xrotation=xrt, bottom_margin=37px)
        png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_General_LogReturns_COVID_Multiverse_All.png")
        display(p3)
    end

    begin
        theme(:dao)
        p3a = @df tablita_lt_post_general violin(generalmarket[16:30], :Estimate, side=:left, label="PostPA")
        @df tablita_lt_covid_general violin!(generalmarket[16:30], :Estimate, side=:right, label="Covid")
        violin!(ylims=yls, size=thissize, legend=:topleft, title="Log-Returns, General Stocks (2/2)", legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, xrotation=xrt, bottom_margin=37px)
        png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_General2_LogReturns_COVID_Multiverse_All.png")
        display(p3a)
    end

    begin
        theme(:dao)
        p5 = @df tablita_lt_post_energy violin(energy[1:15], :Estimate, side=:left, label="PostPA")
        @df tablita_lt_covid_energy violin!(energy[1:15], :Estimate, side=:right, label="Covid")
        violin!(ylims=yls, size=thissize, legend=:topleft, title="Log-Returns, Energy Stocks (1/2)", legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, xrotation=xrt, bottom_margin=28px)
        png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_Energy_LogReturns_COVID_Multiverse_All.png")
        display(p5)
    end

    begin
        theme(:dao)
        p6 = @df tablita_lt_post_energy violin(energy[16:30], :Estimate, side=:left, label="PostPA")
        @df tablita_lt_covid_energy violin!(energy[16:30], :Estimate, side=:right, label="Covid")
        violin!(ylims=yls, size=thissize, legend=:topleft, title="Log-Returns, Energy Stocks (2/2)", legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, xrotation=xrt, bottom_margin=31px)
        png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_Energy2_LogReturns_COVID_Multiverse_All.png")
        display(p6)
    end

end

#### Tables
begin
    smaller_table_logreturns = choose_options_bdws(tablota, "LogReturns", [0.796 0.804])
    CSV.write("Results/LM_RandR_LogReturns_OptBandwidth.csv", smaller_table_logreturns)

    smaller_table_returns = choose_options_bdws(tablota, "Returns", [0.796 0.804])
    CSV.write("Results/LM_RandR_Returns_OptBandwidth.csv", smaller_table_returns)
end


### new thing
#=
begin
    theme(:dao)
    p7 = @df tablita_lt_pre_energy violin(energy[16:30], :Estimate, side=:left, label="PrePA", color = :lightblue)
    @df tablita_lt_post_energy violin!(energy[16:30], :Estimate, side=:right, label="PostPA", alpha=0.8, color = :darkgreen)
    @df tablita_lt_covid_energy violin!(energy[16:30], :Estimate, side=:right, label="Covid", alpha=0.5, color = :red)
    violin!(ylims=yls, size=thissize, legend=:topleft, title="Log-Returns, Energy Stocks (2/2)", legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, xrotation=xrt, bottom_margin=33px)
    #png("Figures/LM_Energy2_LogReturns_Paris_Multiverse_All.png")
    display(p7)
en
=#


### Returns

begin
    theme(:dao)
    p1 = @df tablita_rt_pre_general violin(generalmarket[1:15], :Estimate, side=:left, label="PrePA")
    @df tablita_rt_post_general violin!(generalmarket[1:15], :Estimate, side=:right, label="PostPA")
    violin!(ylims=yls, size=thissize, legend=:topleft, title="Returns, General Stocks (1/2)", legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, xrotation=xrt, bottom_margin=37px)
    png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_General_Returns_Paris_Multiverse_All.png")
end

begin
    theme(:dao)
    p1a = @df tablita_rt_pre_general violin(generalmarket[16:30], :Estimate, side=:left, label="PrePA")
    @df tablita_rt_post_general violin!(generalmarket[16:30], :Estimate, side=:right, label="PostPA")
    violin!(ylims=yls, size=thissize, legend=:topleft, title="Returns, General Stocks (2/2)", legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, xrotation=xrt, bottom_margin=37px)
    png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_General2_Returns_Paris_Multiverse_All.png")
end

begin
    theme(:dao)
    p2 = @df tablita_rt_pre_energy violin(energy[1:15], :Estimate, side=:left, label="PrePA")
    @df tablita_rt_post_energy violin!(energy[1:15], :Estimate, side=:right, label="PostPA")
    violin!(ylims=yls, size=thissize, legend=:topleft, title="Returns, Energy Stocks (1/2)", legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, xrotation=xrt, bottom_margin=28px)
    png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_Energy_Returns_Paris_Multiverse_All.png")
end

begin
    theme(:dao)
    p2a = @df tablita_rt_pre_energy violin(energy[16:30], :Estimate, side=:left, label="PrePA")
    @df tablita_rt_post_energy violin!(energy[16:30], :Estimate, side=:right, label="PostPA")
    violin!(ylims=yls, size=thissize, legend=:topleft, title="Returns, Energy Stocks (2/2)", legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, xrotation=xrt, bottom_margin=31px)
    png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_Energy2_Returns_Paris_Multiverse_All.png")
end

begin
    theme(:dao)
    p3 = @df tablita_rt_post_general violin(generalmarket[1:15], :Estimate, side=:left, label="PostPA")
    @df tablita_rt_covid_general violin!(generalmarket[1:15], :Estimate, side=:right, label="Covid")
    violin!(ylims=yls, size=thissize, legend=:topleft, title="Returns, General Stocks (1/2)", legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, xrotation=xrt, bottom_margin=37px)
    png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_General_Returns_COVID_Multiverse_All.png")
end

begin
    theme(:dao)
    p3a = @df tablita_rt_post_general violin(generalmarket[16:30], :Estimate, side=:left, label="PostPA")
    @df tablita_rt_covid_general violin!(generalmarket[16:30], :Estimate, side=:right, label="Covid")
    violin!(ylims=yls, size=thissize, legend=:topleft, title="Returns, General Stocks (2/2)", legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, xrotation=xrt, bottom_margin=37px)
    png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_General2_Returns_COVID_Multiverse_All.png")
end

begin
    theme(:dao)
    p5 = @df tablita_rt_post_energy violin(energy[1:15], :Estimate, side=:left, label="PostPA")
    @df tablita_rt_covid_energy violin!(energy[1:15], :Estimate, side=:right, label="Covid")
    violin!(ylims=yls, size=thissize, legend=:topleft, title="Returns, Energy Stocks (1/2)", legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, xrotation=xrt, bottom_margin=28px)
    png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_Energy_Returns_COVID_Multiverse_All.png")
end

begin
    theme(:dao)
    p6 = @df tablita_rt_post_energy violin(energy[16:30], :Estimate, side=:left, label="PostPA")
    @df tablita_rt_covid_energy violin!(energy[16:30], :Estimate, side=:right, label="Covid")
    violin!(ylims=yls, size=thissize, legend=:topleft, title="Returns, Energy Stocks (2/2)", legendfontsize=lsize, titlefontsize=tsize, tickfontsize=xsize, titlefontfamily=myfont, legendfontfamily=myfont, tickfontfamily=myfont, xrotation=xrt, bottom_margin=31px)
    png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/LM_Energy2_Returns_COVID_Multiverse_All.png")
end