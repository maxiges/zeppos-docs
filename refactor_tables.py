import os
import re

dir_path = "docs/reference/device-app-api/newAPI/ui/widget"
files = [
    "ARC.mdx", "BUTTON.mdx", "CANVAS.mdx", "CHECKBOX_GROUP.mdx", "CIRCLE.mdx",
    "CYCLE_IMAGE_TEXT_LIST.mdx", "CYCLE_LIST.mdx", "DIALOG.mdx", "FILL_RECT.mdx",
    "GRADIENT_POLYLINE.mdx", "GROUP.mdx", "HISTOGRAM.mdx", "IMG_ANIM.mdx", "IMG.mdx",
    "KEYBOARD.mdx", "PAGE_INDICATOR.mdx", "PAGE_SCROLLBAR.mdx", "PICK_DATE.mdx",
    "PICKER.mdx", "QRCODE.mdx", "RADIO_GROUP.mdx", "SCROLL_LIST.mdx",
    "SLIDE_SWITCH.mdx", "SPORT_DATA.mdx", "STROKE_RECT.mdx", "SYSTEM_KEYBOARD.mdx",
    "TEXT.mdx", "TIME_PICKER.mdx", "VIEW_CONTAINER.mdx", "VIRTUAL_CONTAINER.mdx"
]

header_patterns = [
    r"## Supported Property Access List",
    r"## Property Access Support List"
]

for file in files:
    file_path = os.path.join(dir_path, file)
    if not os.path.exists(file_path):
        print(f"Skipping {file}: file not found")
        continue
        
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()

    modified = False
    for pattern in header_patterns:
        # Match header, followed by a blank line, followed by table rows
        # Regex to capture header and table
        regex = rf"({pattern})\n\n((?:\|.*\|\n?)+)"
        match = re.search(regex, content)
        
        if match:
            header = match.group(1)
            table = match.group(2)
            
            # Avoid re-wrapping
            if "<details>" in content and f"</details>" in content:
                print(f"Skipping {file}: already wrapped")
                break
                
            new_content = content.replace(header + "\n\n" + table, 
                                          header + "\n\n<details>\n<summary>Click to view property support table</summary>\n\n" + table.rstrip() + "\n\n</details>\n")
            
            with open(file_path, "w", encoding="utf-8") as f:
                f.write(new_content)
            print(f"Updated {file}")
            modified = True
            break
    if not modified:
        print(f"No table found in {file}")
