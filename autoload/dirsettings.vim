"
" Plugin: dirsettings
"
" Version: 1.0
"
" Description:
"
"   This is a simple plugin that allows per directory settings for your
"   favourite editor VIM. This plugin is mainly inspired by the already
"   existing plugin named dirsettings, see:
"
"   http://www.vim.org/scripts/script.php?script_id=1860
"
"   But this plugin goes a little step further. It walks the whole directory
"   tree up to the root and on its way back it sources each ".vimdir" file it
"   founds. This allows to overwrite specific settings even in subdirectories
"   which inherit the settings of each parent directory.
"
"   See readme.rst for details.
"
" Author: Christian Hammerl <info@christian-hammerl.de>
"
function!dirsettings#init(event, ...)
	let fname = a:0 > 0 ? a:1 : '.vimdir'
	let augroup = a:0 > 1 ? a:2 : 'dirsettings'
	execute 'autocmd! ' . augroup
    call dirsettings#load(fname)
	execute 'doautocmd ' . a:event . ' *'
endfunction

function! dirsettings#load(fname, ...)
	let here = a:0 > 0 ? a:1 : expand("%:p:h")
	if (strlen(here) > 0)
		let fr = match(here, "/[^/]*$")
		if (fr > -1)
			call dirsettings#load(a:fname, strpart(here, 0, fr))
		endif
	endif
	if (filereadable(here . "/" . a:fname))
		exec 'source ' . here . "/" . a:fname
	endif
endfunction
