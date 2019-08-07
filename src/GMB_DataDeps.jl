using DataDeps

for (ver, ) in [("1.0.0",),
            ("1.1.0",),
            ("2.0.0",),
            ("2.1.0",),
            ("2.2.0",)]

    register(DataDep("gmb-$ver",
        """
        Website: https://gmb.let.rug.nl/about.php
        Data_Website: https://gmb.let.rug.nl/data.php
        Author: Johan Bos et. al.

        The Groningen Meaning Bank (GMB), developed at the University of Groningen,
        comprises thousands of texts in raw and tokenised format, tags for part of speech, named entities and lexical categories, among others.

        Please cite the following work if you use the corpora:
        Johan Bos, Valerio Basile, Kilian Evang, Noortje Venhuizen, Johannes Bjerva (2017): The Groningen Meaning Bank. In: Nancy Ide and James Pustejovsky (eds): Handbook of Linguistic Annotation, pp 463–496, Berlin: Springer.
        """,
        "https://gmb.let.rug.nl/releases/gmb-$ver.zip";
        post_fetch_method = fn -> begin
            unpack(fn)
            innerdir = joinpath("gmb-$ver", "data")
            innerfiles = readdir(innerdir)
            # Move everything to current directory, under same name
            mv.(joinpath.(innerdir, innerfiles), innerfiles)
            rm(innerdir, recursive=true)

            for file in innerfiles
                path = joinpath("gmb-$ver", file)
                docs = readdir(path)
                for doc in docs
                    doc_path = joinpath(path, doc)

                end
            end
        end
    ))
end
