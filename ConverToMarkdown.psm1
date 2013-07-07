function Add-ConvertToMarkdown {

	$sb = {    
filter cvt2md {

    $UseSpacesForCodeBlocks=$true
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
   $psISE.CurrentFile.Editor.Text -split "`r`n" | cvt2md | clip
   write-host -foreground Green "Copied to clipboard"
}
    Remove-PesterMenu
    [void]$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("ConvertTo-Markdown", $sb, "CTRL+Shift+M") 
}

function Get-PesterMenu {

    $psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | 
        Where {$_.DisplayName -Match "ConvertTo-Markdown"}
}

function Remove-PesterMenu {

    $menu = Get-PesterMenu
    if($menu) {
        [void]$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Remove($menu)
    }
}

Add-ConvertToMarkdown