let s:save_cpo = &cpo
set cpo&vim

if exists("g:loaded_potion_maker")
	finish
endif
let g:loaded_potion_maker = 1

command! PotionMakerHelloWorld lua require("potion-maker").sayHelloWorld()

let &cpo = s:save_cpo
unlet s:save_cpo
