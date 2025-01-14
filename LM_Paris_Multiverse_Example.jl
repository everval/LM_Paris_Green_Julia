display("Multiverse plot...")

using Pkg
Pkg.activate(pwd())

using StatsPlots, Random

Random.seed!(1234)

μ = 0.062
σ = 0.008

pvals = μ .+ randn(1000).* σ  

myfont = "Computer Modern"
lsize = 10

theme(:dao)

p1 = histogram(pvals, label ="P-values", legend=:topright, alpha=0.5, size=(650,300))
vline!([0.05], color=:red, label="Significance level", linewidth=4, linestyle=:dash, linealpha=1)
scatter!([0.03], [8], color=:black, label="Reported p-value", markersize=12, marker=:star5, markerstrokewidth=0, markerstrokecolor=:green, markeralpha=1, linealpha=0)


pvals2 = abs.(pvals.- 0.03)

p2 = histogram(pvals2, label ="P-values", legend=:topleft, alpha=0.5, size=(650,300))
vline!([0.05], color=:red, label="Significance level", linewidth=4, linestyle=:dash, linealpha=1)

pvals3 = abs.(pvals.- 0.042) 

p3 = histogram(pvals3, label ="P-values", legend=:topleft, alpha=0.5, size=(650,300))
vline!([0.05], color=:red, label="Significance level", linewidth=4, linestyle=:dash, linealpha=1)

l = @layout [a b c]
plot(p1, p2, p3, layout = l, size=(800,300), legendfontsize=lsize, legendfontfamily=myfont)


png("C:/Users/eduar/OneDrive - Aalborg Universitet/Research/CLIMATE/LM_Paris_Green_Paper/Volatility-persistence-brown-and-green-stocks-Paris-TandF-/figs/Multiverse_analysis_example_3_plots.png")