" Script Variables
let s:configName = 'xftp-config.json'
let s:configFile = ''
let s:config = ''

" Check whether the sftp-config.json file dose exist.
function CheckConfigFileExists()
	" Get current working directory and the edit file parent directory.
	let l:cwd = getcwd()
	let l:expandStr = '%:p'
	
	while 1
		let l:expandStr = l:expandStr . ':h'
		let l:pd = expand(l:expandStr)
		let s:configFile = l:pd . '/' . s:configName
		if filereadable(s:configFile)
			return 1
		endif

		if l:pd ==# l:cwd
			break
		endif
	endwhile	
	return 0
endfunction

" SFTP put file to remote file
function SftpPutFile()
	if CheckConfigFileExists()
		echom "sftp-config.json file found!"
		try
			let s:config = json_decode(join(readfile(s:configFile), ''))
			let l:putExp = findfile('plugin/sftp-put.exp', &runtimepath)
			let l:args = [
						\	s:config.user, s:config.password, s:config.host, 
						\ s:config.port, s:config.remote_path, expand('%')
						\]	
			echo join(l:args, '')
			if !empty(l:putExp)
			 let l:cmd = "!" . l:putExp . " " . (join(l:args, ' ')) ""
			 silent execute l:cmd
			 execute "redraw!" 
			else 
				echo "sftp-vim: stf-put.exp file missed."
			endif
		catch
			echo "sftp-vim: Parsing sftp-config.json failed!"
			echo "caught" v:exception
		endtry
	else
		echom "No sftp-config.json file found!"
	endif 	
endfunction

nnoremap <leader>s :call SftpPutFile()<cr>
