# see Get-Help about_scopes

# Create a variable $foo = 'bar' in the interactive session (global scope)
# Then run this script .\ScriptScope.ps1

'Creating $foo in the script scope and setting it to bla'
$foo = 'bla'

"`$global:foo = $global:foo"
"`$script:foo = $script:foo"

'Inside a script, the local scope is the script scope.'
"`$foo = $foo"

'Change the global foo variable to azerty'
$global:foo = 'azerty'
"`$global:foo = $global:foo"

function ChangeFoo() {
	'Entering function scope.'
	'Inside a fnction, the local scope is the function scope.'
	$foo = 'qwerty'
	"`$foo = $foo"
	"`$local:foo = $local:foo"
	"`$global:foo = $global:foo"
	"`$script:foo = $script:foo"
	
	'Leaving function scope.'
}
ChangeFoo