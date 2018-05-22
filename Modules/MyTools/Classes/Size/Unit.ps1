class Unit {
    [Prefix]$Prefix
    
    [ValidateNotNull()]
    [UnitType]$UnitType

    Unit([UnitType]$unitType) {
        $this.UnitType = $unitType
    }

    Unit([Prefix]$prefix, [UnitType]$unitType) {
        $this.Prefix = $prefix
        $this.UnitType = $unitType
    }

    [bool] HasPrefix() {
        return $this.Prefix
    }

    [bool]IsBinary() {
        if ($this.HasPrefix()) {
            return $this.Prefix.PrefixType.IsBinary()
        }

        # Case for the bit and byte unit.
        return $false
    }

    [bool]IsDecimal() {
        if ($this.HasPrefix()) {
            return $this.Prefix.PrefixType.IsDecimal()
        }

        # Case for the bit and byte unit.
        return $false
    }

    [bool]IsMeaningFulFor([double]$size) {
        if ($this.IsBinary()) {
            return ($size -ge 1) -and ($size -le [PrefixType]::BINARY_BASE)
        }

        # Also the case for bit and byte unit.
        return ($size -ge 1) -and ($size -le [PrefixType]::DECIMAL_BASE)
    }

    [string] ToString() {
        if ($this.HasPrefix()) {
            return $this.Prefix.Symbol + $this.UnitType.Symbol
        }

        # For bit and byte, return the full name instead of the symbol.
        return $this.UnitType.Name
    }
}