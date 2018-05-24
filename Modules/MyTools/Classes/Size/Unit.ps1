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

    [string] Name() {
        if ($this.HasPrefix()) {
            return $this.Prefix.Name + $this.UnitType.Name
        }

        return $this.UnitType.Name
    }

    [string] Symbol() {
        if ($this.HasPrefix()) {
            return $this.Prefix.Symbol + $this.UnitType.Symbol
        }

        return $this.UnitType.Symbol
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

        # Since the bit and byte unit don't have a prefix, they will be compared the decimal way.
        return ($size -ge 1) -and ($size -le [PrefixType]::DECIMAL_BASE)
    }

    [string] ToString() {
        return $this.Symbol()
    }
}