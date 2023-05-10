using JuliaSurveyForm
using Configurations
using Test

surveys_dir(xs...) = pkgdir(JuliaSurveyForm, "surveys", xs...)

survey_en_US = from_toml(Survey, surveys_dir("JuliaSurvey.en_US.toml"))
survey_zh_CN = from_toml(Survey, surveys_dir("JuliaSurvey.zh_CN.toml"))
survey_es_ES = from_toml(Survey, surveys_dir("JuliaSurvey.es_ES.toml"))

# generates the reference translation
# survey_zh_CN = JuliaSurveyForm.translate(survey, zh_CN)

# translate to ja,ko from zh_CN
survey_zh_TW = JuliaSurveyForm.translate(survey_zh_CN, zh_TW)
survey_ja_JP = JuliaSurveyForm.translate(survey_zh_CN, ja_JP)
survey_ko_KR = JuliaSurveyForm.translate(survey_zh_CN, ko_KR)

# reformat zh_CN
# JuliaSurveyForm.emit_toml("JuliaSurvey.zh_CN.toml", survey_zh_CN)
JuliaSurveyForm.emit_toml(surveys_dir("JuliaSurvey.en_US.toml"), survey_en_US)
JuliaSurveyForm.emit_toml(surveys_dir("JuliaSurvey.es_ES.toml"), survey_es_ES)
JuliaSurveyForm.emit_toml(surveys_dir("JuliaSurvey.zh_CN.toml"), survey_zh_CN)
JuliaSurveyForm.emit_toml(surveys_dir("JuliaSurvey.zh_TW.toml"), survey_zh_TW)
JuliaSurveyForm.emit_toml(surveys_dir("JuliaSurvey.ja_JP.toml"), survey_ja_JP)
JuliaSurveyForm.emit_toml(surveys_dir("JuliaSurvey.ko_KR.toml"), survey_ko_KR)


JuliaSurveyForm.emit_markdown("JuliaSurvey.en_US.md", survey_en_US)
JuliaSurveyForm.emit_markdown("JuliaSurvey.es_ES.md", survey_es_ES)
JuliaSurveyForm.emit_markdown("JuliaSurvey.zh_CN.md", survey_zh_CN)
JuliaSurveyForm.emit_markdown("JuliaSurvey.zh_TW.md", survey_zh_TW)
JuliaSurveyForm.emit_markdown("JuliaSurvey.ja_JP.md", survey_ja_JP)
JuliaSurveyForm.emit_markdown("JuliaSurvey.ko_KR.md", survey_ko_KR)
