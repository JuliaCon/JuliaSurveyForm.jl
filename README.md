# JuliaSurveyForm

[![CI][ci-img]][ci-url]
[![codecov][codecov-img]][codecov-url]

A package generates Julia-based survey form in many different languages and formats. This package
is motivated by creating Chinese translation for JuliaCon's Julia survey every year and I'd like
to automate this process with good text-diff using TOML and automated Google translate.

## Installation

<p>
JuliaSurveyForm is a &nbsp;
    <a href="https://julialang.org">
        <img src="https://raw.githubusercontent.com/JuliaLang/julia-logo-graphics/master/images/julia.ico" width="16em">
        Julia Language
    </a>
    &nbsp; package. To install JuliaSurveyForm,
    please <a href="https://docs.julialang.org/en/v1/manual/getting-started/">open
    Julia's interactive session (known as REPL)</a> and press <kbd>]</kbd> key in the REPL to use the package mode, then type the following command
</p>

```julia
pkg> add JuliaSurveyForm
```

## Usage

read the TOML file from `survey` directory

```julia
surveys_dir(xs...) = pkgdir(JuliaSurveyForm, "surveys", xs...)

survey_en_US = from_toml(Survey, surveys_dir("JuliaSurvey.en_US.toml"))
survey_zh_CN = from_toml(Survey, surveys_dir("JuliaSurvey.zh_CN.toml"))
```

then you can translate to other languages based on the version you import,
e.g we can translate from simplified Chinese to traditional Chinese,
or from Chinese to Japanese or Korean.

```julia
survey_zh_TW = JuliaSurveyForm.translate(survey_zh_CN, zh_TW)
survey_ja_JP = JuliaSurveyForm.translate(survey_zh_CN, ja_JP)
survey_ko_KR = JuliaSurveyForm.translate(survey_zh_CN, ko_KR)
```

then we can serialize the translated version into either markdown
or TOML file.

```julia
JuliaSurveyForm.emit_toml(surveys_dir("JuliaSurvey.zh_TW.toml"), survey_zh_TW)
JuliaSurveyForm.emit_toml(surveys_dir("JuliaSurvey.ja_JP.toml"), survey_ja_JP)
JuliaSurveyForm.emit_toml(surveys_dir("JuliaSurvey.ko_KR.toml"), survey_ko_KR)

JuliaSurveyForm.emit_markdown("JuliaSurvey.zh_CN.md", survey_zh_CN)
JuliaSurveyForm.emit_markdown("JuliaSurvey.zh_CN.md", survey_zh_CN)
```

# License

MIT License


[ci-img]: https://github.com/Roger-luo/JuliaSurveyForm.jl/workflows/CI/badge.svg
[ci-url]: https://github.com/Roger-luo/JuliaSurveyForm.jl/actions
[codecov-img]: https://codecov.io/gh/Roger-luo/JuliaSurveyForm.jl/branch/master/graph/badge.svg?token=U604BQGRV1
[codecov-url]: https://codecov.io/gh/Roger-luo/JuliaSurveyForm.jl
