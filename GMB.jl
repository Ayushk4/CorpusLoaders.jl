struct GMB{S}
    filepaths::Vector{S}
end

function GMB(dirpath)
    @assert(isdir(dirpath), dirpath)

	iterate through all and add 'em to a list. then make 'em gmb

    if "brown1" ∈ readdir(dirpath) && "brown2" ∈ readdir(dirpath)
        tagfile_paths = joinpath.(dirpath, ["brown1", "brown2"], "tagfiles")

        paths = joinpath.(tagfile_paths[1], readdir(tagfile_paths[1]))
        append!(paths, joinpath.(tagfile_paths[2], readdir(tagfile_paths[2])))

    elseif "tagfiles" ∈ readdir(dirpath)
        paths = joinpath.(dirpath,"tagfiles", readdir(joinpath(dirpath, "tagfiles")))
    else
        paths = joinpath.(dirpath, readdir(dirpath))
    end
    SemCor(paths)
end

GMB() = GMB(datadep"Groningen Meaning Bank 1.0.0")

MultiResolutionIterators.levelname_map(::Type{SemCor}) = [
    :doc=>1, :contextfile=>1, :context=>1, :document=>1,
    :para=>2, :paragraph=>2,
    :sent=>3, :sentence=>3,
    :word=>4, :token=>4,
    :char=>5, :character=>5
	]

function parse_gmbfile(filename)
end

function load(corpus::SemCor, doc_buffersize=16)
    Channel(;ctype=Document{@NestedVector(TaggedWord, 3), String}, csize=doc_buffersize) do ch
        for fn in corpus.filepaths
            doc = parse_semcorfile(fn)
            put!(ch, doc)
        end
    end
end
