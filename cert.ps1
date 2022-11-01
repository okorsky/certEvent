param(
$RequestID
)

$certout = certutil -view -restrict "RequestID=$RequestID" -out "RequestID,DistinguishedName,NotBefore,NotAfter,Serialnumber,CertificateTemplate"

$templateName = [regex]::Match($certout,"Template:(.*?)Max").Groups[1].Value

add-content -path "d:\logevent.txt" -value "$((Get-Date).ToShortDateString()) RequestID: $RequestID and Temp: $TemplateName"

if (-not [System.Diagnostics.EventLog]::SourceExists("EOC")){
	New-EventLog -LogName Application -Source "EOC"
}
$certDetails = [regex]::Match($certout,"Row 1:(.*?)Maximum").Groups[1].Value
$certDetails = $certDetails.Replace("  ","`r`n")
if ($templateName.Contains("PKI")){
	Write-EventLog -LogName Application -Message "PKI Cert Issued`r`nDetails:$certDetails" -ID 6116 -Source "EOC"
}