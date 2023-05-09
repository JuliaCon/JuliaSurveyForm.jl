using JuliaSurveyForm
using Configurations

surveys_dir(xs...) = pkgdir(JuliaSurveyForm, "surveys", xs...)

survey_en_US = from_toml(Survey, surveys_dir("JuliaSurvey.en_US.toml"))
survey_zh_CN = from_toml(Survey, surveys_dir("JuliaSurvey.zh_CN.toml"))

survey_zh_TW = JuliaSurveyForm.translate(survey_zh_CN, zh_TW)
survey_ja_JP = JuliaSurveyForm.translate(survey_zh_CN, ja_JP)
survey_ko_KR = JuliaSurveyForm.translate(survey_zh_CN, ko_KR)

JuliaSurveyForm.emit_toml(surveys_dir("JuliaSurvey.zh_TW.toml"), survey_zh_TW)
JuliaSurveyForm.emit_toml(surveys_dir("JuliaSurvey.ja_JP.toml"), survey_ja_JP)
JuliaSurveyForm.emit_toml(surveys_dir("JuliaSurvey.ko_KR.toml"), survey_ko_KR)

JuliaSurveyForm.emit_markdown("JuliaSurvey.zh_CN.md", survey_zh_CN)
JuliaSurveyForm.emit_markdown("JuliaSurvey.zh_TW.md", survey_zh_TW)
