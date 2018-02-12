param (
    # Specifies a path to one or more locations.
    [Parameter(Mandatory=$true,
            Position=0,
            ParameterSetName="ParameterSetName",
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,
            HelpMessage="Path to directories to be published.")]
    [Alias("PSPath")]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Path
)

$BaseUri = "https://penguinliong.moe/api/v1";

$Path | ForEach-Object {
    Write-Output "Publishing $_...";
    # Upload `content.md` first to make sure directory is built.
    $ContentPath = Join-Path $_ "content.md";
    if (Test-Path $ContentPath) {
        Publish-File.ps1 -Uri "$BaseUri/posts/$Path" -InFile $ContentPath
    } else {
        Write-Output "Unable to find `content.md` in this directory. Skipped.";
        return;
    }
    # Upload metadata.
    $MetadataPath = Join-Path $Path "metadata.json";
    if (-not (Test-Path $MetadataPath)) {
        $Metadata = '{"author":"PENGUINLIONG","published":"' +
            (Get-Date).ToString("o") +
            '"}';
        [System.IO.File]::WriteAllLines($FilePath, $Metadata);
    }
    Publish-File.ps1 -Uri "$BaseUri/metadata/$Path" -InFile $MetadataPath
    # Upload all the resources.
    Get-ChildItem -Path $_ -File | ForEach-Object {
        $FileName = Split-Path $_ -Leaf;
        if ("content.md" -eq $FileName -or "metadata.json" -eq $FileName) {
            return;
        }
        $ResourcePath = $_ | Resolve-Path -Relative;
        Publish-File.ps1 -Uri "$BaseUri/resources/$ResourcePath" -InFile $_.FullName;
    }
}
