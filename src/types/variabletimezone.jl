struct Transition
    utc_datetime::DateTime  # Instant where new zone applies
    zone::FixedTimeZone
end

Base.isless(x::Transition,y::Transition) = isless(x.utc_datetime,y.utc_datetime)

"""
    VariableTimeZone

A `TimeZone` with an offset that changes over time.
"""
struct VariableTimeZone <: TimeZone
    name::String
    transitions::Vector{Transition}
    cutoff::Union{DateTime,Nothing}

    function VariableTimeZone(name::AbstractString, transitions::Vector{Transition}, cutoff::Union{DateTime,Nothing}=nothing)
        new(name, transitions, cutoff)
    end
end

name(tz::VariableTimeZone) = tz.name

function rename(tz::VariableTimeZone, name::AbstractString)
    VariableTimeZone(name, tz.transitions, tz.cutoff)
end

function Base.:(==)(a::VariableTimeZone, b::VariableTimeZone)
    a.name == b.name && a.transitions == b.transitions
end

function Base.hash(tz::VariableTimeZone, h::UInt)
    h = hash(tz.name, h)
    h = hash(tz.transitions, h)
    h = hash(tz.cutoff, h)
    return h
end