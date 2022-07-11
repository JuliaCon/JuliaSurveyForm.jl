module JuliaSurveyForm

using Countries
using PythonCall
using GarishPrint
using Configurations
using ProgressLogging
using InteractiveUtils

include("types.jl")
include("translate.jl")
# backends
include("toml.jl")
include("markdown.jl")

const googletrans = PythonCall.pynew()
const emit_toml = TargetTOML.emit_toml
const emit_markdown = TargetMarkdown.emit_markdown

function __init__()
    PythonCall.pycopy!(googletrans, pyimport("googletrans"))
end

end
