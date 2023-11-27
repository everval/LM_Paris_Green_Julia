function plain_returns(t::TimeArray)
    rt = 100 .* diff(t)./lag(t)
    return rt
end

function log_returns(t::TimeArray)
    lt = 100 .* diff(log.(t))
    return lt
end