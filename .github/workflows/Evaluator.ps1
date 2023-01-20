$currentBaseline = Get-Content .\.github\workflows\current_baseline.json -Raw | ConvertFrom-Json
$newBaseline = Get-Content .\new_baseline.json -Raw | ConvertFrom-Json

#So we ask PowerShell what the differences are
Compare-object -ReferenceObject $currentBaseline `
    -DifferenceObject $newBaseline `
    -Property @('ruleId','message','Lastname','filePath','lineNumber')
    
if(Compare-object -ReferenceObject $currentBaseline `
    -DifferenceObject $newBaseline `
    -Property @('ruleId','message','Lastname','filePath','lineNumber'))
    
{
echo "New code which is written as part of this PR creates additional compatabilities with .Net Core!!"
echo "Hence this commit cannot be allowed!"
echo "Please check the output of the GitAction and rewrite the affected code!!"
Exit 1
}
