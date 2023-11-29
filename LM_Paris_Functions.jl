function plain_returns(t::TimeArray)
    rt = 100 .* diff(t)./lag(t)
    return rt
end

function log_returns(t::TimeArray)
    lt = 100 .* diff(log.(t))
    return lt
end

function choose_options(tablita, period, return_type)
    return tablita[(tablita.Period .== period) .& (tablita.ReturnType .== return_type), :]
end

function choose_options_market(tablita, period, return_type, market)
    return tablita[(tablita.Period.==period).&(tablita.ReturnType.==return_type).&(tablita.Market.==market), :]
end

function choose_options_market_bdws(tablita, period, return_type, market, band)
    return tablita[(tablita.Period.==period).& (tablita.ReturnType.==return_type) .& (tablita.Market.==market) .& (tablita.Bandwidth.>band[1]) .& (tablita.Bandwidth.<band[2]) , :]
end

function choose_options_bdws(tablita, return_type, band)
    return tablita[(tablita.ReturnType.==return_type) .& (tablita.Bandwidth.>band[1]) .& (tablita.Bandwidth.<band[2]), :]
end