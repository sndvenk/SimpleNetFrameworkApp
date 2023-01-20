$currentBaseline = Get-Content .\.github\workflows\current_baseline.json -Raw | ConvertFrom-Json
$newBaseline = Get-Content .\new_baseline.json -Raw | ConvertFrom-Json

#So we ask PowerShell what the differences are
Compare-object -ReferenceObject $currentBaseline `
    -DifferenceObject $newBaseline `
    -IncludeEqual `
    -Property @('ruleId','message','Lastname','filePath','lineNumber')
