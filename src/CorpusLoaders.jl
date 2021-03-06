module CorpusLoaders
using DataDeps
using WordTokenizers
using MultiResolutionIterators
using InternedStrings
using Glob
using StringEncodings

export Document, TaggedWord, SenseAnnotatedWord, PosTaggedWord
export title, sensekey, word
export load

export WikiCorpus, SemCor, Senseval3

function __init__()

    include("WikiCorpus_DataDeps.jl")
    include("SemCor_DataDeps.jl")
    include("SemEval2007Task7_DataDeps.jl")
    include("Senseval3_DataDeps.jl")
end

include("types.jl")
include("apply_subparsers.jl")
include("WikiCorpus.jl")
include("SemCor.jl")
include("SemEval2007Task7.jl")
include("Senseval3.jl")

end
