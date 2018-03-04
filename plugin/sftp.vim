" Script Variables
let s:configName = 'sftp-config.json'

" Check whether the sftp-config.json file dose exist.
function CheckConfigFileExists()
	" Get current working directory and the edit file parent directory.
	let l:cwd = getcwd()
	let l:expandStr = '%:p:h'
	let l:pd = expand(l:expandStr)
	
	while l:pd != l:cwd
		echo l:expandStr
		echo l:pd
		
		if filereadable(l:pd . '/' . s:configName)
			return 1
		endif
		let l:expandStr = l:expandStr . ':h'
		let l:pd = expand(l:expandStr)
	endwhile
	return filereadable(l:cwd . '/' . s:configName)
endfunction

" SFTP put file to remote file
function SftpPutFile()
	echo CheckConfigFileExists()
	echo " Boolean" . (CheckConfigFileExists() == 1)
	if CheckConfigFileExists()
		echom "sftp-config.json file found!"
	else
		echom "No sftp-config.json file found!"
	endif 	
endfunction

nnoremap <leader>s :call SftpPutFile()<cr>
