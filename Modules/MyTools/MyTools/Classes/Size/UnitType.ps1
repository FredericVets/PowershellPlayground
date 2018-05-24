class UnitType {
    static [UnitType]$BIT = [UnitType]::new('bit', 'b')
    static [UnitType]$BYTE = [UnitType]::new('byte', 'B')

    [ValidateNotNullOrEmpty()]
    [string]$Name
    [ValidateNotNullOrEmpty()]
    [string]$Symbol

    UnitType([string]$name, [string]$symbol) {
        $this.Name = $name
        $this.Symbol = $symbol
    }

    [string] ToString() {
        return $this.Name
    }
}