function ConvertClipboardTo-Markdown {
    param(
        [Switch]$UseSpacesForCodeBlocks,
        [Switch]$CopyToClipboard
    )

filter cvt2md {

    $codeBlocks = {
        param($code)

        if($UseSpacesForCodeBlocks) {
            return "    $($code)"
        }
@"
``````
$($code)
``````
"@
    }

    if([string]::IsNullOrEmpty($_.trim())) {return}

    if($_.trim().startswith("#")){
        $_
    } else {
@"
$(& $codeBlocks $($_))
"@
    }
}
    if((Get-Host).Name -notmatch "ise") {
        Add-Type -AN system.windows.forms
    }

    $result = $psISE.CurrentFile.Editor.Text -split "`r`n" | cvt2md

    if($CopyToClipboard) {
        $result | clip
        return
    }

    $result
}