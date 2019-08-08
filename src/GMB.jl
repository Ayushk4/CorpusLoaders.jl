struct GMB{S}
    filepaths::Vector{S}
end

function GMB(dirpath)
	@assert (isdir(dirpath))
	innerdirs = joinpath.(dirpath, readdir(dirpath))

	innerfiles = [joinpath.(dir, readdir(dir)) for dir in innerdirs]
	innerfiles = joinpath.(vcat(innerfiles...), "en.tags")

	GMB(innerfiles)
end

GMB() = GMB(datadep"gmb-1.1.0")

MultiResolutionIterators.levelname_map(::Type{GMB}) = [
    :doc=>1, :contextfile=>1, :context=>1, :document=>1,
    :sent=>2, :sentence=>2,
    :word=>3, :token=>3,
    :char=>4, :character=>4
    ]

function parse_gmbfile(line)
	println(line)
end

function parse_gmbfile(filename)
    local sent
    lines = @NestedVector(TaggedWord,2)()
    context = Document(intern(basename(filename)), lines)

    # structure

    function new_sentence(line)
        sent = @NestedVector(TaggedWord,1)()
        push!(lines, sent)
    end

	get_tagged(line) = push!(sent, parse_gmb_word(line))

	# parse
	for line in eachline(filename)
		if length(line) == 0 || isspace(line[1])
			new_sentence()
		else
			get_tagged(line)
		end
	end
	apply_subparsers(filename, subparsers)

    return context
end

function load(corpus::Senseval3, doc_buffersize=16)
    Channel(;ctype=Document{@NestedVector(TaggedWord, 2), String}, csize=doc_buffersize) do ch
        for fn in corpus.filepaths
            doc = parse_senseval3file(fn)
            put!(ch, doc)
        end
    end
end
