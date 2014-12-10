# must come first
module PermutationsA

export PermList,getindex,setindex!,cycles,cyclelengths,sign,order,
       cycletype,div2,trans,randpermlist,permlist,matrix,
       permcycs, copy, idpermlist, isid, inv,
       distance, same, convert,ppow, list

using PermPlain

export PermCycs, randpermcycs

import Base: length, sign, copy, convert

import PermPlain: cycletype, cyclelengths, permlistisequal

include("permlist.jl")
include("permcycs.jl")
include("permallrep.jl")

end # module PermutationsA

# TODO:
# implement sparse cycle repr. eg, can act on integers
# could have bigint values.
# see pari/gp as well
# implement iterators, for mapping, etc.