$RCEditor = Get-Process -Name RCEditor | select Id -ExpandProperty Id

foreach ($Id in $RCE) { 
Stop-Process -Id $Id -Force
}

$Nimbus = Get-Process -Name Powel.CompositeWpf.Shells.WorkflowShell | select Id -ExpandProperty Id


foreach ($Id in $Nimbus) { 
Stop-Process -Id $Id -Force
}
