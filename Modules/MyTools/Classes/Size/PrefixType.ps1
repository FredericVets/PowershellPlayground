class PrefixType {
    static [int] $BINARY_BASE = 1024
    static [int] $DECIMAL_BASE = 1000

    static [PrefixType]$BINARY = [PrefixType]::new('Binary', 1024)
    static [PrefixType]$DECIMAL = [PrefixType]::new('Decimal', 1000)

    [ValidateNotNullOrEmpty()]
    [string]$Name
    
    [int]$Base

    PrefixType([string]$name, [int]$base) {
        $this.Name = $name
        $this.Base = $base
    }
    
    [bool]IsBinary() {
        return $this.Base -eq [PrefixType]::BINARY_BASE
    }

    [bool]IsDecimal() {
        return $this.Base -eq [PrefixType]::DECIMAL_BASE
    }

    [string] ToString() {
        return $this.Name
    }
}