GOOGLE_TRANS_LOCALE = Dict(
    zh_CN => "zh-cn",
    zh_TW => "zh-tw",
    zh_HK => "zh-tw",
    zh_MO => "zh-tw",
    zh_SG => "zh-tw",
    en_US => "en",
    es_ES => "es",
    ja_JP => "ja",
    ko_KR => "ko",
)

function translate(survey::Survey, dest::LOCALE)
    src_lang = GOOGLE_TRANS_LOCALE[survey.lang]
    dest_lang = GOOGLE_TRANS_LOCALE[dest]
    translator = googletrans.Translator()

    function translate_f(text)
        if text isa Vector
            origin = join(text, '\n')
        else
            origin = text
        end

        translated = translator.translate(origin; src=src_lang, dest=dest_lang).text
        translated_text = pyconvert(String, translated)

        if text isa Vector
            return String.(split(translated_text, '\n'))
        else
            return translated_text
        end
    end

    questions = Question[]
    @withprogress name="translating" for each in survey.questions
        push!(questions, translate(translate_f, each))
    end

    return Survey(;
        lang=dest,
        intro=translate_f(survey.intro),
        closing = translate_f(survey.closing),
        questions
    )
end

function translate(trans_f, question::TextQuestion)
    TextQuestion(;
        description=trans_f(question.description),
        short=question.short,
    )
end

function translate(trans_f, question::ClickQuestion)
    ClickQuestion(;
        description=trans_f(question.description),
    )
end

function translate(trans_f, question::RegexQuestion)
    RegexQuestion(;
        description=trans_f(question.description),
        pattern=question.pattern,
    )
end

function translate(trans_f, question::YearQuestion)
    YearQuestion(;
        description=trans_f(question.description),
        upper=question.upper,
        lower=question.lower,
    )
end



function translate(trans_f, question::DropDownQuestion)
    DropDownQuestion(;
        description=trans_f(question.description),
        options=question.translate_options ? trans_f(question.options) : question.options,
    )
end

function translate(trans_f, question::ChoiceQuestion)
    ChoiceQuestion(;
        description=trans_f(question.description),
        choices=question.translate_choices ? trans_f(question.choices) : question.choices,
        question.multi_choice,
        question.none_of_the_above,
        question.ask_for_other_answer,
    )
end

function translate(trans_f, question::CountryOrRegionQuestion)
    CountryOrRegionQuestion(;
        description=trans_f(question.description),
        countries=question.translate_countries ? trans_f(question.countries) : question.countries,
        question.ask_for_other_answer,
        question.prefer_not_to_answer,
    )
end

function translate(trans_f, question::QuestionForm)
    QuestionForm(;
        description=trans_f(question.description),
        column_titles=question.translate_cols ? trans_f(question.column_titles) : question.column_titles,
        row_titles=question.translate_rows ? trans_f(question.row_titles) : question.row_titles,
        question.multi_select,
        question.allow_empty,
    )
end

function translate(trans_f, question::RateQuestion)
    RateQuestion(;
        description=trans_f(question.description),
        max_rate=question.max_rate,
    )
end
