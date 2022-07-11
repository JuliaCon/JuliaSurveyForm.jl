module TargetTOML

using Configurations
using ..JuliaSurveyForm: Survey

function emit_toml(filename::String, survey::Survey)
    open(filename, "w+") do f
        emit_toml(f, survey)
    end
end

function print_quote_string(io::IO, key::String, text::String)
    println(io, key, " = \"", text, "\"")
end

function print_triple_quote_string(io::IO, key::String, text::String)
    println(io, key, " = \"\"\"")
    print(io, text)
    if last(text) != '\n'
        println(io) # make sure there is a new line before """
    end
    println(io, "\"\"\"")
end

function emit_toml(io::IO, survey::Survey)
    d = to_dict(survey)

    print_quote_string(io, "lang", d["lang"])
    print_triple_quote_string(io, "intro", d["intro"])
    isnothing(survey.closing) || print_triple_quote_string(io, "closing", d["closing"])

    for question in d["questions"]
        println(io, "[[questions]]")
        print_quote_string(io, "type", question["type"])
        print_triple_quote_string(io, "description", question["description"])

        for (key, value) in question
            key in ["type", "description"] && continue
            print(io, key, " = ")
            if value isa Vector
                println(io, "[")
                for each in value
                    println(io, "    \"", each, "\",")
                end
                println(io, "]")
            elseif value isa String
                print(io, "\"", value, "\"")
            elseif value isa Union{Bool, Int}
                println(io, value)
            else
                throw(ArgumentError("unsupported TOML type $(typeof(value))"))
            end
        end
        println(io)
        println(io)
    end
    return
end

end # TargetTOML
