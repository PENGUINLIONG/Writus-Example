param (
    [Parameter(Mandatory=$true,
            ValueFromPipeline=$false,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage="Uri to publish file to.")]
    [ValidateNotNullOrEmpty()]
    [string] $Uri,
    [Parameter(Mandatory=$true,
            ValueFromPipeline=$false,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage="Path to directories to be published.")]
    [ValidateNotNullOrEmpty()]
    [string] $InFile,
    [Parameter(Mandatory=$false,
            ValueFromPipeline=$false,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage="MIME of resource.")]
    [string] $ContentType
)

function Get-Mime([string] $Path) {
    $Ext = [System.IO.Path]::GetExtension($Path);
    return @{
        ".md" = "text/markdown";
        ".json" = "application/json";
        ".jpg" = "image/jpeg";
        ".jpeg" = "image/jpeg";
        ".png" = "image/png";
    }.Item($Ext);
}

# Writus use TLS 1.2. Powershell use 1.0 by default.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;

$Token = "PASSWORD";
if ([string]::IsNullOrEmpty($ContentType)) {
    $ContentType = Get-Mime -Path $InFile
}
if ([string]::IsNullOrEmpty($ContentType)) {
    return; # throw exception.
}
Invoke-WebRequest -Uri $Uri -Method Put -Headers @{
    "Authorization" = "Bearer $Token";
    "Content-Type" = "$ContentType";
} -InFile $InFile
