$here = (Split-Path -Parent $MyInvocation.MyCommand.Path)

. "$here\..\..\SourceClasses.ps1"

Describe 'Classes.Size.Prefix' {
    It 'has a correct ToString() representation' {
        $p = [Prefix]::new(
            'whatever', 
            'si',
            1,
            [PrefixType]::new('whatever', 1024))

        $p | Should Be 'whatever'
    }
}