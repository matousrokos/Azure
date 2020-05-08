$RCEditor = Get-Process -Name RCEditor | select Id

foreach ($Id in $RCE) { 
Stop-Process -Name RCEditor -Force
}

$Nimbus = Get-Process -Name Powel.CompositeWpf.Shells.WorkflowShell | select Id

foreach ($Id in $Nimbus) { 
Stop-Process -Name Powel.CompositeWpf.Shells.WorkflowShell -Force
}
