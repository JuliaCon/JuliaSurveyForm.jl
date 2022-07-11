module TargetMarkdown

using ..JuliaSurveyForm: 
    LOCALE,
    en_US, zh_CN, zh_TW, ja_JP, ko_KR,
    Survey,
    Question,
    TextQuestion,
    ClickQuestion,
    RegexQuestion,
    DropDownQuestion,
    YearQuestion,
    ChoiceQuestion,
    QuestionForm,
    RateQuestion,
    CountryOrRegionQuestion



const MULTI_CHOICE = Dict(
    en_US => "Please select all that apply.",
    zh_CN => "请选择所有适用的选项。",
    zh_TW => "請選擇所有適用的選項。",
    ja_JP => "該当するものをすべて選択してください。",
    ko_KR => "해당하는 것을 모두 선택해 주십시오.",
)

const NON_OF_THE_ABOVE = Dict(
    en_US => "None of the above.",
    zh_CN => "以上都不是。",
    zh_TW => "以上都不是。",
    ja_JP => "上記のどれでもない。",
    ko_KR => "위의 어느 것도.",
)

const PREFER_NOT_TO_ANSWER = Dict(
    en_US => "Prefer not to answer.",
    zh_CN => "我不愿意回答。",
    zh_TW => "我不願意回答。",
    ja_JP => "答えるのは気が進まない。",
    ko_KR => "나는 대답하기를 꺼린다.",
)

const OTHER_PLEASE_SPECIFY = Dict(
    en_US => "Other",
    zh_CN => "其他",
    zh_TW => "其他",
    ja_JP => "他の",
    ko_KR => "다른",
)

function emit_markdown(filename::String, survey::Survey)
    return open(filename, "w+") do f
        emit_markdown(f, survey)
    end
end

function emit_markdown(io::IO, survey::Survey)
    println(io, survey.intro)
    println(io)
    println(io)
    println(io, "---")
    println(io)
    println(io)

    for (idx, each) in enumerate(survey.questions)
        print(io, idx, ". ", strip(each.description))
        emit_markdown(io, each, survey.lang)

        println(io)
        println(io)
    end

    println(io)
    println(io)
    println(io, "---")
    println(io)
    println(io)
    println(io, survey.closing)
    return
end

emit_markdown(io::IO, x::TextQuestion, ::LOCALE) = nothing
emit_markdown(io::IO, x::ClickQuestion, ::LOCALE) = nothing

function emit_markdown(io::IO, x::RegexQuestion, lang::LOCALE)
    println(io, "*intput text pattern:", x.pattern, "*")
end

function emit_markdown(io::IO, x::DropDownQuestion, lang::LOCALE)
    println(io)
    for each in x.options
        println(io, "- [ ] ", each)
    end
end

function emit_markdown(io::IO, x::ChoiceQuestion, lang::LOCALE)
    if x.multi_choice
        println(io, MULTI_CHOICE[lang])
    else
        println(io)
    end

    for each in x.choices
        println(io, "- [ ] ", each)
    end

    if x.none_of_the_above
        println(io, "-[ ] ", NON_OF_THE_ABOVE[lang])
    end

    ask_for_other_answer(io, x, lang)
end

function emit_markdown(io::IO, x::QuestionForm, lang::LOCALE)
    println(io)
    println(io)

    max_row_len = maximum(printed_length, x.row_titles)
    print(io, "| ", " "^max_row_len, " |")
    for column_title in x.column_titles
        print(io, " ", column_title, " |")
    end
    println(io)

    print(io, "| ", "-"^max_row_len, " |")
    for column_title in x.column_titles
        print(io, " ", "-"^printed_length(column_title), " |")
    end
    println(io)

    for row_title in x.row_titles
        indent_after = " "^(max_row_len - printed_length(row_title))
        print(io, "| ", row_title, indent_after, " |")
        for column_title in x.column_titles
            print(io, " ", " "^printed_length(column_title), " |")
        end
        println(io)
    end
    return
end

function emit_markdown(io::IO, x::RateQuestion, lang::LOCALE)
    println(io)
    for rate in 1:x.max_rate
        println(io, "- [ ] ", rate)
    end
end

function emit_markdown(io::IO, x::CountryOrRegionQuestion, lang::LOCALE)
    println(io)
    for country in x.countries
        println(io, "- [ ] ", country)
    end

    ask_for_other_answer(io, x, lang)
    if x.prefer_not_to_answer
        println(io, "-[ ] ", PREFER_NOT_TO_ANSWER[lang])
    end
    return
end

function emit_markdown(io::IO, x::YearQuestion, lang::LOCALE)
    if lang == zh_CN
        print(io, "输入年份（从", x.lower, "年至", x.upper, "年）")
    elseif lang == zh_TW
        print(io, "輸入年份（從", x.lower, "年至", x.upper, "年）")
    elseif lang == ja_JP
        print(io, "年を入力してください（", x.lower, "年から", x.upper, "年まで）")
    elseif lang == ko_KR
        print(io, "연도 입력(", x.lower, "년부터 ", x.upper, "년까지)")
    else
        print(io, "enter year from ", x.lower, " to ", x.upper)
    end
    println(io)
end

function ask_for_other_answer(io, x::Question, lang::LOCALE)
    x.ask_for_other_answer || return
    if x.ask_for_other_answer
        println(io, "-[ ] $(OTHER_PLEASE_SPECIFY[lang])/SPECIFY")
    end
end

# TODO: handle other chars too
is_chinese_char(uchar::Char) = '\u4e00' ≤ uchar ≤ '\u9fa5'
function printed_length(s::String)
    count = 0
    for each in s
        if is_chinese_char(each)
            count += 2
        else
            count += 1
        end
    end
    return count
end

end # MarkdownTarget