$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$moduleRoot = Resolve-Path "$here\..\MyTools"

# You can source a function by calling '. functionName'
function SourceClasses {
    $classesRoot = "$moduleRoot\Classes"
    
    Write-Verbose 'Sourcing classes ...'
    # Order matters!
    . "$classesRoot\Size\PrefixType.ps1"
    . "$classesRoot\Size\UnitType.ps1"
    . "$classesRoot\Size\Prefix.ps1"
    . "$classesRoot\Size\Unit.ps1"
    Write-Verbose 'Classes are sourced.'
}

function SourcePrivate {
    $privateRoot = "$moduleRoot\Private"

    Write-Verbose 'Sourcing private ...'
    . "$privateRoot\Size\Configuration.ps1"
    Write-Verbose 'Private is sourced.'
}