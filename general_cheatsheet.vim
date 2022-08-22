""" Distraction Free Mode
nnoremap <c-z> :action ToggleDistractionFreeMode<CR>

""" Terminal
nnoremap <c-t> :action ActivateTerminalToolWindow<CR>
nnoremap <leader>t :action Terminal.OpenInTerminal<CR>

""" Navigation
nnoremap <leader>vs :action SplitVertically<CR>
nnoremap <leader>us :action Unsplit<CR>
nnoremap <leader>mg :action MoveEditorToOppositeTabGroup<CR>
nnoremap <leader>op :action MoveTabRight<CR>
nnoremap <c-p> :action PreviousTab<CR>
nnoremap <c-n> :action NextTab<CR>

nnoremap <c-p> :action JumpToLastWindow<CR>
nnoremap <c-x> :action HideAllWindows<CR>

""""" Editing source code
nnoremap [[ :action MethodUp<CR>
nnoremap ]] :action MethodDown<CR>
nnoremap cr :action CollapseRegion<CR>
nnoremap er :action ExpandRegion<CR>
nnoremap <leader>cr :action CollapseAllRegions<CR>
nnoremap <leader>er :action ExpandAllRegions<CR>
nnoremap <leader>c :action CommentByLineComment<CR>
nnoremap ,r :action Refactorings.QuickListPopupAction<CR>
nnoremap ,f :action RecentFiles<CR>
nnoremap ,l :action RecentLocations<CR>
nnoremap ,h :action LocalHistory.ShowHistory<CR>
nnoremap ge :action GotoNextError<CR>
nnoremap gE :action GotoPreviousError<CR>
nnoremap <leader>s :write<CR>

""" Searching and Source Code Navigation
nnoremap <c-s> :action FileStructurePopup<CR>

""" Running and Debugging
nnoremap <leader>r :action ContextRun<CR>
nnoremap <leader>c :action RunClass<CR>  """ run current file
nnoremap <leader>f :action ChooseRunConfiguration<CR>
"nnoremap <leader>t :action ActivateRunToolWindow<CR>
nnoremap <leader>u :action Rerun<CR>
"nnoremap <leader>f :action RerunFailedTests<CR>
nnoremap <leader>b :action ToggleLineBreakpoint<CR>
nnoremap <leader>d :action ContextDebug<CR>
nnoremap <leader>n :action ActivateDebugToolWindow<CR>

nmap <leader>dr <Action>PublishGroup.Upload<CR>
nmap <leader>ds <Action>QuickJavaDoc<CR>
"" -- Map IDE actions to IdeaVim -- https://jb.gg/abva4t
nnoremap <leader>e :e ~/.ideavimrc<CR>

" regular vim actions
nmap np :pu<CR>

" ReplaceWithRegister
[count]["x]gr{motion}   Replace {motion} text with the contents of 
						register x.
                        
[count]["x]grr          Replace [count] lines with the contents of 
						register x
						To replace from the cursor position to the
						end of the line use ["x]gr$
																						
{Visual}["x]gr          Replace the selection with the contents of 
						register x"]"]"]]

" surround
nmap cs - change current surround (cs"')
nmap ds - remove current surround (ds")
nmap ysiw - add surround to iw 
nmap yss - add to whole line (yss])


" === pycharm ===
CMD-y   		definition pop up
CMD-SHIFT-F12   hide all side panels
CMD-E 	 		recent edited files
CMD-up 			file navigation\create new files
CMD-SHIFT-v		clipboard history



" "nnoremap <c-/> :action FindInPath<CR>
"nnoremap <c-a> :action GotoAction<CR>
"nnoremap <c-f> :action GotoFile<CR>
"nnoremap <leader>u :action FindUsages<CR>
"nnoremap <leader>s :action GotoRelated<CR>
"nnoremap <leader>h :action CallHierarchy<CR>
"nnoremap <leader>b :action ShowNavBar<CR>
"nnoremap <c-o> :action GotoSymbol<CR>
"nnoremap gc :action GotoClass<CR>
"nnoremap gi :action GotoImplementation<CR>
"nnoremap gd :action GotToDeclaration<CR>
"nnoremap gp :action GotToSuperMethod<CR>
"nnoremap gt :action GotoTest<CR>
"nnoremap gb :action Back<CR>
"nnoremap gf :action Forward<CR>
