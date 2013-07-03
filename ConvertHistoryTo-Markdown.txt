function ConvertHistoryTo-Markdown {
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
    
@"
### $($_.Id)
$(& $codeBlocks $($_))
"@
}
    
    $result = Get-History | cvt2md
    if($CopyToClipboard) {
        $result | clip
        return
    }
    
    $result
}