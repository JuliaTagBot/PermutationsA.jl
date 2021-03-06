abstract AbstractPerm{T} <: AbstractMatrix{T}

export AbstractPerm
export plength, isid, topiv, numcycles, iscyclic

import Base: rank, sign, det, logdet, trace, ishermitian, issym,
iseven, istriu, istril, isposdef, null, getindex, transpose,
ctranspose, inv, pmap, isperm, one, zero, full, sparse, size, eltype

import Base: eig, eigfact, eigmax, eigmin, eigs, eigvals, eigvecs
import DataStructures: list

size(m::AbstractPerm) = (s = plength(m); (s,s))
eltype{T}(c::AbstractPerm{T}) = T

# this one is not called for some reason
#getindex{T}(m::AbstractPerm{T}, i::Real, j::Real) =  pmap(m,j) == i ? one(T) : zero(T)
# this one is called
getindex(m::AbstractPerm, i::Real, j::Real) =  pmap(m,i) == j ? one(eltype(m)) : zero(eltype(m))
\(p::AbstractPerm, k::Integer) = k / p

function mkerrf()
    for sym in (:plength, :isid, :isperm, :pmap, :sign, :list)
        @eval begin
            ($sym)(p::AbstractPerm) = error("AbstractPerm: `", $sym , "' not defined for ", typeof(p))
        end
    end
end

mkerrf()

# dense matrix
full(p::AbstractPerm) = (T=eltype(p); T[p[i,j] for i=1:plength(p), j=1:plength(p)])

# sparse matrix
function sparse{T}(m::AbstractPerm{T})
    n = plength(m)
    I = [1:n]
    J = T[ pmap(m,i) for i in 1:n] # should call a routine for this, so that PermCyc is efficient
#    J = (m.data)[I]
    V = ones(T,n)
    sparse(I,J,V)
end

zero(p::AbstractPerm) = error("zero not defined for type ", typeof(p))
ctranspose(m::AbstractPerm) = inv(m)
transpose(m::AbstractPerm) = inv(m)
inv(m::AbstractPerm) = m^-1
topiv(p::AbstractPerm) = PermPlain.perm2ipiv(list(p).data)
numcycles(p::AbstractPerm) = length(cyclelengths(p))
# We allow fixed points in this definition. See wikipedia
iscyclic(p::AbstractPerm) = numcycles(p) == 1

rank(p::AbstractPerm) = plength(p)
det(p::AbstractPerm) = sign(p)
logdet(p::AbstractPerm) = sign(p) > 0 ? 0 : error("AbstractPerm: DomainError: determinant is -1")
trace(p::AbstractPerm) = plength(p) - supportsize(p)
ishermitian(p::AbstractPerm) = isid(p)
issym(p::AbstractPerm) = isid(p)
iseven(p::AbstractPerm) = sign(p) == one(eltype(p))
istriu(p::AbstractPerm) = isid(p)
istril(p::AbstractPerm) = isid(p)
isposdef(p::AbstractPerm) = isid(p)
null(p::AbstractPerm) = zeros(Float64,plength(p),0) # for consistency



# These can be computed more efficiently without using full matrices
# lufact can be done very easily, but we have to break into the
# interface
for f in ( :eig, :eigfact, :eigmax, :eigmin, :eigs, :eigvals, :eigvecs)
    @eval begin
        ($f)(p::AbstractPerm) = ($f)(full(p))
    end
end
