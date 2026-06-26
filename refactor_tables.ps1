$dirPath = "docs\reference\device-app-api\newAPI\ui\widget"
$files = @(
    "ARC.mdx", "BUTTON.mdx", "CANVAS.mdx", "CHECKBOX_GROUP.mdx", "CIRCLE.mdx",
    "CYCLE_IMAGE_TEXT_LIST.mdx", "CYCLE_LIST.mdx", "DIALOG.mdx", "FILL_RECT.mdx",
    "GRADIENT_POLYLINE.mdx", "GROUP.mdx", "HISTOGRAM.mdx", "IMG_ANIM.mdx", "IMG.mdx",
    "KEYBOARD.mdx", "PAGE_INDICATOR.mdx", "PAGE_SCROLLBAR.mdx", "PICK_DATE.mdx",
    "PICKER.mdx", "QRCODE.mdx", "RADIO_GROUP.mdx", "SCROLL_LIST.mdx",
    "SLIDE_SWITCH.mdx", "SPORT_DATA.mdx", "STROKE_RECT.mdx", "SYSTEM_KEYBOARD.mdx",
    "TEXT.mdx", "TIME_PICKER.mdx", "VIEW_CONTAINER.mdx", "VIRTUAL_CONTAINER.mdx"
)

$headerPatterns = @(
    "## Supported Property Access List",
    "## Property Access Support List"
)

foreach ($file in $files) {
    $filePath = Join-Path $dirPath $file
    if (-not (Test-Path $filePath)) {
        Write-Host "Skipping ${file}: file not found"
        continue
    }

    $content = Get-Content -Path $filePath -Raw
    $modified = $false

    foreach ($pattern in $headerPatterns) {
        # (?m) multiline mode, ^ matches start of line
        # Regex to match:
        # 1. Header (Supported ... List)
        # 2. Two newlines
        # 3. Table content (lines starting with |)
        
        $regex = "(?m)^($pattern)\r?\n\r?\n((^\|.*\r?\n)+)"
        
        if ($content -match $regex) {
            # Check if it already has <details>
            if ($content -match "<details>") {
                Write-Host "Skipping ${file}: already wrapped"
                $modified = $true
                break
            }
            
            $header = $matches[1]
            $newlines = $matches[2]
            $table = $matches[3]
            
            $newContent = $content -replace [regex]::Escape($matches[0]), ($header + "`n`n<details>`n<summary>Click to view property support table</summary>`n`n" + $table + "`n</details>`n")
            
            Set-Content -Path $filePath -Value $newContent
            Write-Host "Updated ${file}"
            $modified = $true
            break
        }
    }
    if (-not $modified) {
        Write-Host "No table found in ${file}"
    }
}
