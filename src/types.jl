export en_US, zh_CN, zh_HK,
    zh_TW,
    zh_SG,
    zh_MO,
    ja_JP, ko_KR,
    Question,
    TextQuestion,
    RegexQuestion,
    DropDownQuestion,
    ChoiceQuestion,
    QuestionForm,
    RateQuestion,
    CountryOrRegionQuestion,
    Survey

@enum LOCALE begin
    en_US
    zh_CN
    zh_HK
    zh_TW
    zh_SG
    zh_MO
    ja_JP
    ko_KR
end

const STRING_TO_LOCALE = Dict(string(each)=>each for each in instances(LOCALE))

abstract type Question end

@option "text" struct TextQuestion <: Question
    type::Reflect
    short::Bool = true
    description::String
end

@option "regex" struct RegexQuestion <: Question
    type::Reflect
    description::String
    pattern::Regex
end

@option "year" struct YearQuestion <: Question
    type::Reflect
    description::String
    upper::Int
    lower::Int
end

@option "dropdown" struct DropDownQuestion
    type::Reflect
    description::String
    options::Vector{String}
    translate_options::Bool = true
end

@option "choice" struct ChoiceQuestion <: Question
    type::Reflect
    description::String
    choices::Vector{String}
    multi_choice::Bool = false
    none_of_the_above::Bool = false # non of the above, but don't ask for input text
    ask_for_other_answer::Bool = false # special option ask for input text
    translate_choices::Bool = true
end

@option "click" struct ClickQuestion <: Question
    type::Reflect
    description::String
end

@option "country" struct CountryOrRegionQuestion <: Question
    type::Reflect
    description::String
    countries::Vector{String} = country_name.(each_country())
    ask_for_other_answer::Bool = true
    prefer_not_to_answer::Bool = true
    translate_countries::Bool = true
end

"""
Type for question form that contains a question for each row.

# Example

the following requires participant to select one of the column at each row.

|   |  Question A  |  Question B |
|---| ------------ | ----------- |
| A |              |             |
| B |              |             |
"""
@option "form" struct QuestionForm <: Question
    type::Reflect
    description::String
    column_titles::Vector{String}
    row_titles::Vector{String}
    multi_select::Bool = false # allow selecting multiple answer for each row
    allow_empty::Bool = false # allow empty answer per row
    translate_rows::Bool = true
    translate_cols::Bool = true
end

@option "rate" struct RateQuestion <: Question
    type::Reflect
    description::String
    max_rate::Int = 5
end

@option struct Survey
    intro::String
    lang::LOCALE = en_US
    questions::Vector{Question} = Question[]
    closing::Maybe{String}
end


# to_dict

function Configurations.to_dict(::Type{Survey}, x::LOCALE)
    return string(x)
end

function Configurations.to_dict(::Type{<:Question}, x::Regex)
    return x.pattern
end

# from_dict

function Configurations.from_dict(::Type{Survey}, ::Type{LOCALE}, x::String)
    haskey(STRING_TO_LOCALE, x) || throw(ArgumentError("LOCALE $x is not supported"))
    return STRING_TO_LOCALE[x]
end

function Configurations.from_dict(::Type{Survey}, ::Type{Question}, x::AbstractDict{String, Any})
    types = subtypes(Question)
    idx = findfirst(isequal(x["type"]), type_alias.(types))
    idx === nothing && throw(ArgumentError("invalid type $(x["type"])"))
    return from_dict(types[idx], x)
end

function Configurations.from_dict(::Type{<:Question}, ::Type{Regex}, x::String)
    return Regex(x)
end

function Base.show(io::IO, ::MIME"text/plain", question::Question)
    GarishPrint.pprint_struct(io, question)
end
