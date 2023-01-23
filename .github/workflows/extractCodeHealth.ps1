 Write-Host "Extracting results from the upgrade-assistant output"
 $runner = @{"Name"="UA";"Location"="GitHub";}
 $jsonBase = @{}
                     
                     
 $resultList = New-Object System.Collections.ArrayList
                     
 $ratchetConfig = Get-Content .\.github\workflows\rule_parameters.json -Raw | ConvertFrom-Json
 Write-Host "Reading Input config for ratcheting evaluator."
 
 foreach($i in $ratchetConfig)
 {
     Write-Host "#########"
     Write-Host "Selecting Ratcheting Tool " $i.runnerType                            
     Write-Host "Checking if the rule is enabled"  $i.ruleName  $i.ruleCondition
                     
     if (!$i.isEnabled)
     {
         Write-Host "Skipping as the rule is disabled in config " 
     }
     else
     {
         Write-Host "Count of " $i.ruleCondition
         $tempResult = jq --arg rule $i.ruleCondition '[.runs[].results[] | select(.ruleId==$rule) | {ruleId: .ruleId,message: .message.text, filePath: .locations[].physicalLocation.artifactLocation.uri,lineNumber: .locations[].physicalLocation.region.startLine}] | . | length' .\AnalysisReport.sarif
         $resultList.Add(@{"Name" = $i.ruleName; "Type" = $i.ruleType; "Rule" = $i.ruleCondition; "ResultCount" = $tempResult;})
                             
         Write-Host "Writing output artifacts.... "
         jq --arg rule $i.ruleCondition '[.runs[].results[] |select(.ruleId==$rule) | {ruleId: .ruleId,message: .message.text, filePath: .locations[].physicalLocation.artifactLocation.uri,lineNumber: .locations[].physicalLocation.region.startLine}]' .\AnalysisReport.sarif > .\$($i.ruleCondition)_baseline.json

     }        
 }
 $jsonBase.Add("Data", $resultList)
 $jsonBase.Add("Runner", $runner)
                     
 $jsonBase | ConvertTo-Json -Depth 10 | Out-File .\runnerResults.json
                   
