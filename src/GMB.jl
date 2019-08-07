struct GMB{S}
    filepaths::Array{Array{String, 1}}
end

MultiResolutionIterators.levelname_map(::Type{SemCor}) = [
	:corpus_part=>1, :part=>1, corpus_portion=>1,
    :doc=>2, :contextfile=>2, :context=>2, :document=>2,
    :para=>3, :paragraph=>3,
    :sent=>4, :sentence=>4,
    :word=>5, :token=>5,
    :char=>6, :character=>6
	]
