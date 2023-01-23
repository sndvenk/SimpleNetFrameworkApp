$ratchetConfig = Get-Content .\.github\workflows\rule_parameters.json -Raw | ConvertFrom-Json
Write-Host "Comparing the Data with Baseline"
[bool] $hasError = $false
foreach($i in $ratchetConfig)
 {
     Write-Host "#########"
     Write-Host "Comparing the metrics of the rule"  $i.ruleName  $i.ruleCondition
                     
     if (!$i.isEnabled)
     {
         Write-Host "Skipping as the rule is disabled" 
     }
     else
     {
         $currentBaseline = Get-Content .\.github\workflows\$($i.ruleCondition)_baseline.json -Raw | ConvertFrom-Json
         $newBaseline = Get-Content .\$($i.ruleCondition)_baseline.json -Raw | ConvertFrom-Json
         
         #So we ask PowerShell what the differences are
            Compare-object -ReferenceObject $currentBaseline `
                -DifferenceObject $newBaseline `
                -Property @('ruleId','message','Lastname','filePath','lineNumber')
         if(Compare-object -ReferenceObject $currentBaseline `
            -DifferenceObject $newBaseline `
            -Property @('ruleId','message','Lastname','filePath','lineNumber'))

        {
            $hasError = $true
        }

     }        
 }
    
if($hasError)
{
    echo "New code which is written as part of this PR creates additional compatabilities with .Net Core!!"
    echo "Hence this commit cannot be allowed!"
    echo "Please check the output of the GitAction and rewrite the affected code!!"
    Exit 1
}
