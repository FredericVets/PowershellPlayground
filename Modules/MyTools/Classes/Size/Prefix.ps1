class Prefix {
    [ValidateNotNullOrEmpty()]
    [string]$Name

    [ValidateNotNullOrEmpty()]
    [string]$Symbol

    [int]$Exponent
    
    [ValidateNotNull()]
    [PrefixType]$PrefixType

    Prefix([string]$name, [string]$symbol, [int]$exponent, [PrefixType]$prefixType) {
        $this.Name = $name
        $this.Symbol = $symbol
        $this.Exponent = $exponent
        $this.PrefixType = $prefixType
    }

    [string] ToString() {
        return $this.Name
    }
}