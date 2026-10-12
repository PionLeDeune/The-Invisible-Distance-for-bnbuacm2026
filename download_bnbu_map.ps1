$ErrorActionPreference = 'Stop'

# Download the publicly linked BNBU campus map image.
# This script requests one official campus-map page and then one map image.
# It does not crawl the whole website or bypass access controls.

$officialPage = 'https://www.bnbu.edu.cn/campus_life/Campus_Map.htm'
$knownMapImage = 'https://www.uic.edu.hk/en/images/shouhuiditu2025.jpg'
$outputDir = Join-Path $PSScriptRoot 'assets'
$outputFile = Join-Path $outputDir 'bnbu-campus-map.jpg'

New-Item -ItemType Directory -Path $outputDir -Force | Out-Null

Write-Host 'Step 1/2: Reading the official BNBU campus map page...' -ForegroundColor Cyan
$candidateUrls = @()

try {
    $pageResponse = Invoke-WebRequest -Uri $officialPage -Headers @{ 'User-Agent' = 'Mozilla/5.0 (compatible; CampusMapProject/1.0)' } -UseBasicParsing -TimeoutSec 20
    $html = $pageResponse.Content

    # Find image-related URLs from the official page HTML.
    $attributePattern = '(?is)(?:src|data-src|data-original|href)\s*=\s*["'']([^"'']+)["'']'
    $attributeMatches = [regex]::Matches($html, $attributePattern)
    foreach ($match in $attributeMatches) {
        $rawUrl = [System.Net.WebUtility]::HtmlDecode($match.Groups[1].Value.Trim())
        if ([string]::IsNullOrWhiteSpace($rawUrl)) { continue }
        if ($rawUrl.StartsWith('data:', [System.StringComparison]::OrdinalIgnoreCase)) { continue }

        try {
            $absoluteUrl = ([System.Uri]::new([System.Uri]$officialPage, $rawUrl)).AbsoluteUri
        } catch {
            continue
        }

        if ($absoluteUrl -match '(?i)(map|campus|ditu|shouhui|地图|校园)' -and $absoluteUrl -match '(?i)\.(jpg|jpeg|png|webp)(\?|$)') {
            if ($candidateUrls -notcontains $absoluteUrl) { $candidateUrls += $absoluteUrl }
        }
    }
} catch {
    Write-Host 'Could not automatically inspect the current BNBU page. I will try the official map image URL published on the university website.' -ForegroundColor Yellow
}

# The current page may not expose the image directly in its HTML, so use the known official campus-map image as a fallback.
if ($candidateUrls -notcontains $knownMapImage) { $candidateUrls += $knownMapImage }

Write-Host 'Step 2/2: Trying to download the campus map image...' -ForegroundColor Cyan
$downloaded = $false
foreach ($url in $candidateUrls) {
    try {
        Write-Host "Trying: $url" -ForegroundColor Gray
        $tempFile = Join-Path $outputDir 'bnbu-campus-map.tmp'
        $response = Invoke-WebRequest -Uri $url -Headers @{ 'User-Agent' = 'Mozilla/5.0 (compatible; CampusMapProject/1.0)' } -UseBasicParsing -TimeoutSec 30 -OutFile $tempFile -PassThru

        $contentType = ''
        if ($response.Headers -and $response.Headers['Content-Type']) {
            $contentType = [string]$response.Headers['Content-Type']
        }
        $fileInfo = Get-Item $tempFile
        if ($fileInfo.Length -gt 10000 -and ($contentType -match '(?i)image/' -or $url -match '(?i)\.(jpg|jpeg|png|webp)(\?|$)')) {
            Move-Item -Path $tempFile -Destination $outputFile -Force
            Write-Host ''
            Write-Host 'Success! The map image was saved here:' -ForegroundColor Green
            Write-Host $outputFile -ForegroundColor Green
            Write-Host ''
            Write-Host 'Next step: open the assets folder in VS Code and confirm bnbu-campus-map.jpg is visible.'
            $downloaded = $true
            break
        } else {
            Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
            Write-Host 'This URL did not return a usable image. Trying the next one...' -ForegroundColor Yellow
        }
    } catch {
        Remove-Item (Join-Path $outputDir 'bnbu-campus-map.tmp') -Force -ErrorAction SilentlyContinue
        Write-Host "Download failed for this URL: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

if (-not $downloaded) {
    Write-Host ''
    Write-Host 'The automatic download did not succeed. No other settings were changed.' -ForegroundColor Red
    Write-Host 'Please open the official campus map page in your browser and send me a screenshot of what you see:' -ForegroundColor Yellow
    Write-Host $officialPage
    exit 1
}
