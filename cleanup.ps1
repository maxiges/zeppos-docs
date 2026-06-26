$dirPath = "docs\reference\device-app-api\newAPI\ui\widget"
$files = Get-ChildItem $dirPath -Filter *.mdx

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw
    $newContent = $content -replace "<details>[\s\S]*?<summary>.*?</summary>[\s\S]*?<\/details>", ""
    # This might remove too much or not enough if the table was broken.
    
    # Actually, let's just use a simpler approach to revert:
    # Git is better.
}
