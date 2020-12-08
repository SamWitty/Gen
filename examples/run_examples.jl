using Gen
using Test

include("decode/run.jl")
include("regression/static_mala_hmc.jl")
include("regression/static_map_optimize.jl")
include("regression/static_mh.jl")
include("regression/static_mh_collapsed.jl")
include("regression/quickstart.jl")
include("regression/dynamic_map_optimize_gibbs.jl")
include("regression/dynamic_mh.jl")
include("regression/dynamic_resimulation_mh.jl")
include("coal/coal.jl")
include("gp_structure/lightweight.jl")
include("gp_structure/incremental.jl")
include("mle/static_mle.jl")
