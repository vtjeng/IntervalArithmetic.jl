# This file is part of the IntervalArithmetic.jl package; MIT licensed

module IntervalArithmetic

import CRlibm
import FastRounding
import RoundingEmulator

using LinearAlgebra
using Markdown
using StaticArrays
using SetRounding
using EnumX

import LinearAlgebra: ×, dot, norm
export ×, dot


import Base:
    +, -, *, /, //, muladd, fma,
    ^, sqrt, exp, log, exp2, exp10, log2, log10, inv, cbrt, hypot,
    zero, one, eps, typemin, typemax, abs, abs2, min, max,
    rad2deg, deg2rad,
    sin, cos, tan, cot, csc, sec, asin, acos, atan, acot, sinpi, cospi, sincospi,
    sinh, cosh, tanh, coth, csch, sech, asinh, acosh, atanh, acoth,
    union, intersect, isempty,
    convert, eltype, size,
    BigFloat, float, big,
    ∩, ∪, ⊆, ⊇, ∈, eps,
    floor, ceil, trunc, sign, round, copysign, flipsign, signbit,
    expm1, log1p,
    precision,
    isfinite, isnan, isinf, iszero,
    abs, abs2,
    show,
    isinteger, setdiff,
    parse, hash

import Base:  # for IntervalBox
    broadcast, length,
    getindex, setindex,
    iterate, eltype

import Base.MPFR: MPFRRoundingMode
import Base.MPFR: MPFRRoundUp, MPFRRoundDown, MPFRRoundNearest, MPFRRoundToZero, MPFRRoundFromZero

import .Broadcast: broadcasted

export
    Interval, BooleanInterval,
    interval, ±, .., @I_str,
    diam, radius, mid, scaled_mid, mag, mig, hull,
    emptyinterval, ∅, ∞, isempty, isinterior, isdisjoint, ⪽,
    precedes, strictprecedes, ≺, ⊂, ⊃, ⊇, contains_zero, isthinzero,
    isweaklyless, isstrictless, overlap, Overlap,
    ≛,
    entireinterval, isentire, nai, isnai, isthin, iscommon, isatomic,
    inf, sup, bounds, bisect, mince,
    eps, dist,
    midpoint_radius,
    RoundTiesToEven, RoundTiesToAway,
    IntervalRounding,
    PointwisePolicy,
    cancelminus, cancelplus, isbounded, isunbounded,
    pow, extended_div, nthroot,
    setformat

import Base: isdisjoint

export
    setindex   # re-export from StaticArrays for IntervalBox



## Multidimensional
export
    IntervalBox, symmetric_box

## Decorations
export
    interval, decoration, DecoratedInterval,
    com, dac, def, trv, ill

## Union type
export
    Region



function __init__()
    setrounding(BigFloat, RoundNearest)
end

function Base.setrounding(f::Function, ::Type{Rational{T}},
    rounding_mode::RoundingMode) where T
    return setrounding(f, float(Rational{T}), rounding_mode)
end

## Includes

include("intervals/intervals.jl")

include("multidim/multidim.jl")
include("bisect.jl")
include("decorations/decorations.jl")

include("rand.jl")
include("parsing.jl")
include("display.jl")
include("symbols.jl")

include("plot_recipes/plot_recipes.jl")

"""
    Region{T} = Union{Interval{T}, IntervalBox{T}}
"""
const Region{T} = Union{Interval{T}, IntervalBox{T}}


# These definitions has been put there because generated functions must be
# defined after all methods they use.
@generated function Interval{T}(x::AbstractIrrational) where T
    res = atomic(Interval{T}, x())  # Precompute the interval
    return :(return $res)  # Set body of the function to return the precomputed result
end

Interval{BigFloat}(x::AbstractIrrational) = atomic(Interval{BigFloat}, x)
Interval(x::AbstractIrrational) = Interval{Float64}(x)

end # module IntervalArithmetic
