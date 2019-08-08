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

function parse_gmb_word(line)
	tokens_tags = split(line)
	length(tokens_tags) != 5 && throw("Error parsing line: \"$line\". Invalid Format.")
	return GMBWord(tokens_tags[5], tokens_tags[2], tokens_tags[1])
end

function parse_gmbfile(filename)
    local sent
    sentences = @NestedVector(GMBWord,2)()
    context = Document(intern(basename(filename)), sentences)

    # structure

    function new_sentence()
        sent = @NestedVector(GMBWord,1)()
        push!(sentences, sent)
    end

	get_tagged(line) = push!(sent, parse_gmb_word(line))

	new_sentence()

	# parse
	for line in eachline(filename)
		if length(line) == 0 || isspace(line[1])
			length(sent) == 0 || new_sentence()
		else
			get_tagged(line)
		end
	end
	isempty(sentences[end]) && deleteat!(sentences, lastindex(sentences))
    return context
end

function load(corpus::GMB, doc_buffersize=16)
    Channel(;ctype=Document{@NestedVector(GMBWord, 2), String}, csize=doc_buffersize) do ch
        for fn in corpus.filepaths
            doc = parse_gmbfile(fn)
            put!(ch, doc)
        end
    end
end
