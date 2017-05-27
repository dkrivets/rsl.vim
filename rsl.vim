" Vim syntax file
" Language: RSL 
" Version: 0.1
" Maintainer: Dmitry Krivets
" Latest Revision: 28 August 2015
" Thanks authors of ruby.vim !

if exists("b:current_syntax")
  finish
endif

let s:keepcpo= &cpo
set cpo&vim

if has("folding") 
  setlocal foldmethod=syntax
endif

syn cluster rslNotTop       contains=@rslExtendedStringSpecial,@rslDeclaration,rslConditional,rslExceptional,rslMethodExceptional,rslTodo
syn cluster rslCommentGroup contains=rslTodo,@Spell

syn sync fromstart
syn case ignore
set nofoldenable

" Operators
"+  syn match  rslOperator "[~!^&|*/%+-]\|\%(class\s*\)\@<!<<\|<=>\|<=\|\%(<\|\<class\s\+\u\w*\s*\)\@<!<[^<]\@=\|===\|==\|=\~\|>>\|>=\|=\@<!>\|\*\*\|\.\.\.\|\.\.\|::"
"+  syn match  rslOperator "->\|-=\|/=\|\*\*=\|\*=\|&&=\|&=\|&&\|||=\||=\|||\|%=\|+=\|!\~\|!="
"+  syn region rslBracketOperator matchgroup=rslOperator start="\%(\w[?!]\=\|[]})]\)\@<=\[\s*" end="\s*]" contains=ALLBUT,@rslNotTop

" Expression Substitution and Backslash Notation
syn match rslStringEscape "\\\\\|\\[abefnrstv]\|\\\o\{1,3}\|\\x\x\{1,2}"						   contained display
syn match rslStringEscape "\%(\\M-\\C-\|\\C-\\M-\|\\M-\\c\|\\c\\M-\|\\c\|\\C-\|\\M-\)\%(\\\o\{1,3}\|\\x\x\{1,2}\|\\\=\S\)" contained display
syn match rslQuoteEscape  "\\[\\']"											   contained display

syn region rslInterpolation	      matchgroup=rslInterpolationDelimiter start="#{" end="}" contained contains=ALLBUT,@rslNotTop
syn match  rslInterpolation	      "#\%(\$\|@@\=\)\w\+"    display contained contains=rslInterpolationDelimiter,rslInstanceVariable,rslClassVariable,rslGlobalVariable,rslPredefinedVariable
syn match  rslInterpolationDelimiter "#\ze\%(\$\|@@\=\)\w\+" display contained
syn match  rslInterpolation	      "#\$\%(-\w\|\W\)"       display contained contains=rslInterpolationDelimiter,rslPredefinedVariable,rslInvalidVariable
syn match  rslInterpolationDelimiter "#\ze\$\%(-\w\|\W\)"    display contained
syn region rslNoInterpolation	      start="\\#{" end="}"            contained
syn match  rslNoInterpolation	      "\\#{"		      display contained
syn match  rslNoInterpolation	      "\\#\%(\$\|@@\=\)\w\+"  display contained
syn match  rslNoInterpolation	      "\\#\$\W"		      display contained

syn match rslDelimEscape	"\\[(<{\[)>}\]]" transparent display contained contains=NONE

syn region rslNestedParentheses    start="("  skip="\\\\\|\\)"  matchgroup=rslString end=")"	transparent contained
syn region rslNestedCurlyBraces    start="{"  skip="\\\\\|\\}"  matchgroup=rslString end="}"	transparent contained
syn region rslNestedAngleBrackets  start="<"  skip="\\\\\|\\>"  matchgroup=rslString end=">"	transparent contained
syn region rslNestedSquareBrackets start="\[" skip="\\\\\|\\\]" matchgroup=rslString end="\]"	transparent contained

syn cluster rslStringSpecial	      contains=rslInterpolation,rslNoInterpolation,rslStringEscape
syn cluster rslExtendedStringSpecial contains=@rslStringSpecial,rslNestedParentheses,rslNestedCurlyBraces,rslNestedAngleBrackets,rslNestedSquareBrackets

" Numbers and ASCII Codes
syn match rslASCIICode	"\%(\w\|[]})\"'/]\)\@<!\%(?\%(\\M-\\C-\|\\C-\\M-\|\\M-\\c\|\\c\\M-\|\\c\|\\C-\|\\M-\)\=\%(\\\o\{1,3}\|\\x\x\{1,2}\|\\\=\S\)\)"
syn match rslInteger	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<0[xX]\x\+\%(_\x\+\)*\>"								display
syn match rslInteger	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<\%(0[dD]\)\=\%(0\|[1-9]\d*\%(_\d\+\)*\)\>"						display
syn match rslInteger	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<0[oO]\=\o\+\%(_\o\+\)*\>"								display
syn match rslInteger	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<0[bB][01]\+\%(_[01]\+\)*\>"								display
syn match rslFloat	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<\%(0\|[1-9]\d*\%(_\d\+\)*\)\.\d\+\%(_\d\+\)*\>"					display
syn match rslFloat	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<\%(0\|[1-9]\d*\%(_\d\+\)*\)\%(\.\d\+\%(_\d\+\)*\)\=\%([eE][-+]\=\d\+\%(_\d\+\)*\)\>"	display

" Identifiers
syn match rslLocalVariableOrMethod "\<[_[:lower:]][_[:alnum:]]*[?!=]\=" contains=NONE display transparent
syn match rslBlockArgument	    "&[_[:lower:]][_[:alnum:]]"		 contains=NONE display transparent

"++ syn match  rslBlockParameter	  "\%(\h\|[^\x00-\x7F]\)\%(\w\|[^\x00-\x7F]\)*" contained
"++ syn region rslBlockParameterList start="\%(\%(\<do\>\|{\)\s*\)\@<=|" end="|" oneline display contains=rslBlockParameter

" Normal String and Shell Command Output
syn region rslString matchgroup=rslStringDelimiter start="\"" end="\"" skip="\\\\\|\\\"" contains=@rslStringSpecial,@Spell fold
syn region rslString matchgroup=rslStringDelimiter start="'"	end="'"  skip="\\\\\|\\'"  contains=rslQuoteEscape,@Spell    fold
syn region rslString matchgroup=rslStringDelimiter start="`"	end="`"  skip="\\\\\|\\`"  contains=@rslStringSpecial fold

" Generalized Single Quoted String, Symbol and Array of Strings
syn region rslString matchgroup=rslStringDelimiter start="%[qwi]\z([~`!@#$%^&*_\-+=|\:;"',.?/]\)" end="\z1" skip="\\\\\|\\\z1" fold
syn region rslString matchgroup=rslStringDelimiter start="%[qwi]{"				   end="}"   skip="\\\\\|\\}"	fold contains=rslNestedCurlyBraces,rslDelimEscape
syn region rslString matchgroup=rslStringDelimiter start="%[qwi]<"				   end=">"   skip="\\\\\|\\>"	fold contains=rslNestedAngleBrackets,rslDelimEscape
syn region rslString matchgroup=rslStringDelimiter start="%[qwi]\["				   end="\]"  skip="\\\\\|\\\]"	fold contains=rslNestedSquareBrackets,rslDelimEscape
syn region rslString matchgroup=rslStringDelimiter start="%[qwi]("				   end=")"   skip="\\\\\|\\)"	fold contains=rslNestedParentheses,rslDelimEscape
syn region rslString matchgroup=rslStringDelimiter start="%q "				   end=" "   skip="\\\\\|\\)"	fold

" Generalized Double Quoted String and Array of Strings and Shell Command Output
" Note: %= is not matched here as the beginning of a double quoted string
syn region rslString matchgroup=rslStringDelimiter start="%\z([~`!@#$%^&*_\-+|\:;"',.?/]\)"	    end="\z1" skip="\\\\\|\\\z1" contains=@rslStringSpecial fold
syn region rslString matchgroup=rslStringDelimiter start="%[QWIx]\z([~`!@#$%^&*_\-+=|\:;"',.?/]\)" end="\z1" skip="\\\\\|\\\z1" contains=@rslStringSpecial fold
syn region rslString matchgroup=rslStringDelimiter start="%[QWIx]\={"				    end="}"   skip="\\\\\|\\}"	 contains=@rslStringSpecial,rslNestedCurlyBraces,rslDelimEscape    fold
syn region rslString matchgroup=rslStringDelimiter start="%[QWIx]\=<"				    end=">"   skip="\\\\\|\\>"	 contains=@rslStringSpecial,rslNestedAngleBrackets,rslDelimEscape  fold
syn region rslString matchgroup=rslStringDelimiter start="%[QWIx]\=\["				    end="\]"  skip="\\\\\|\\\]"	 contains=@rslStringSpecial,rslNestedSquareBrackets,rslDelimEscape fold
syn region rslString matchgroup=rslStringDelimiter start="%[QWIx]\=("				    end=")"   skip="\\\\\|\\)"	 contains=@rslStringSpecial,rslNestedParentheses,rslDelimEscape    fold
syn region rslString matchgroup=rslStringDelimiter start="%[Qx] "				    end=" "   skip="\\\\\|\\)"   contains=@rslStringSpecial fold

syn match  rslMethodDeclaration   "[^[:space:];#(]\+"	 contained contains=rslConstant,rslBoolean,rslPseudoVariable,rslInstanceVariable,rslClassVariable,rslGlobalVariable
syn match  rslClassDeclaration    "[^[:space:];#<]\+"	 contained contains=rslConstant,rslOperator

syn cluster rslDeclaration contains=rslMethodDeclaration,rslClassDeclaration,rslFunction,rslBlockParameter

" Keywords
" Note: the following keywords have already been defined:
" begin case class def do end for if module unless until while
syn match   rslControl	       "\<\%(and\|break\|in\|next\|not\|or\|redo\|rescue\|retry\|return\)\>[?!]\@!"
syn match   rslKeyword	       "\<\%(this\|var\)\>[?!]\@!"
syn match   rslBoolean	       "\<\%(true\|false\)\>[?!]\@!"

" Expensive Mode - match 'end' with the appropriate opening keyword for syntax
" based folding and special highlighting of module/class/method definitions
syn match  rslDefine   "\<macro\>"    nextgroup=rslMethodDeclaration skipwhite skipnl
syn match  rslClass    "\<class\>"    nextgroup=rslClassDeclaration  skipwhite skipnl
syn match  rslFunction /\(macro\s\+\)\@<=\w\+/

syn region rslMethodBlock start="\<macro\>"	matchgroup=rslDefine end="\%(\<macro\_s\+\)\@<!\<end\>" contains=ALLBUT,@rslNotTop fold
syn region rslBlock	  start="\<class\>"	matchgroup=rslClass  end="\<end\>"		        contains=ALLBUT,@rslNotTop fold

" modifiers
syn match rslConditionalModifier "\<\%(if\|unless\)\>" display
syn match rslRepeatModifier	 "\<\%(while\|for\)\>" display

syn region rslDoBlock      matchgroup=rslControl start="\<do\>" end="\<end\>"                 contains=ALLBUT,@rslNotTop fold
" curly bracket block or hash literal
"++ syn region rslCurlyBlock	matchgroup=rslCurlyBlockDelimiter  start="{" end="}"				contains=ALLBUT,@rslNotTop fold
"++ syn region rslArrayLiteral	matchgroup=rslArrayDelimiter	    start="\%(\w\|[\]})]\)\@<!\[" end="]"	contains=ALLBUT,@rslNotTop fold

" statements without 'do'
syn region rslBlockExpression       matchgroup=rslControl     start="\<begin\>" end="\<end\>" contains=ALLBUT,@rslNotTop fold
syn region rslConditionalExpression matchgroup=rslConditional start="\%(\%(^\|\.\.\.\=\|[{:,;([<>~\*/%&^|+=-]\|\%(\<[_[:lower:]][_[:alnum:]]*\)\@<![?!]\)\s*\)\@<=\%(if\|unless\)\>" end="\%(\%(\%(\.\@<!\.\)\|::\)\s*\)\@<!\<end\>" contains=ALLBUT,@rslNotTop fold

syn match rslConditional "\<\%(else\|elif\)\>[?!]\@!" contained containedin=rslConditionalExpression,rslOperator

" statements with optional 'do'
syn region rslOptionalDoLine   matchgroup=rslRepeat start="\<for\>[?!]\@!" start="\%(\%(^\|\.\.\.\=\|[{:,;([<>~\*/%&^|+-]\|\%(\<[_[:lower:]][_[:alnum:]]*\)\@<![!=?]\)\s*\)\@<=\<\%(until\|while\)\>" matchgroup=rslOptionalDo end="\%(\<do\>\)" end="\ze\%(;\|$\)" oneline contains=ALLBUT,@rslNotTop
syn region rslRepeatExpression start="\<for\>[?!]\@!" start="\%(\%(^\|\.\.\.\=\|[{:,;([<>~\*/%&^|+-]\|\%(\<[_[:lower:]][_[:alnum:]]*\)\@<![!=?]\)\s*\)\@<=\<\%(until\|while\)\>" matchgroup=rslRepeat end="\<end\>" contains=ALLBUT,@rslNotTop nextgroup=rslOptionalDoLine fold

" Special Methods
syn keyword rslAccess    private local
  
" false positive with 'include?'
syn match   rslInclude   "\<import\>[?!]\@!"
syn keyword rslInclude   import

" Comments and Documentation
syn match   rslSharpBang    "\%^#!.*" display
"syn keyword rslTodo	    FIXME NOTE TODO OPTIMIZE XXX Cleanup AUTHOR VERSION contained
syn keyword rslTodo	    FIXME NOTE TODO OPTIMIZE contained
syn match   rslComment	    "\/\/.*"    contains=rslSharpBang,rslSpaceError,rslTodo,rslCommentTittle,@Spell
syn region  rslComment	    start="/\*" end="\*/" contains=rslSharpBang,rslSpaceError,rslTodo,@rslCommentGroup,@Spell fold
syn match   rslCommentTitle '*\s*\%([sS]:\|\h\w*#\)\=\u\w*\(\s\+\u\w*\)*:'hs=s+1 contained contains=@rslCommentGroup,rslTodo
",@vimCommentGroup

" Function
" Cast function
syn keyword rslFunction Asize CurToStrAlt Date DateSplit Decimal Double DoubleL containedin=ALL
syn keyword rslFunction DtTm DtTmSplit Floor Int MkStr Money MonName NumToStr Round containedin=ALL
syn keyword rslFunction RubToStr RubToStrAlt SetAutoMoneyFloor String Time TimeSplit ValType containedin=ALL

" Стандартные процедуры вывода
syn keyword rslFunction Print PrintLn Message SetOutput SetColumn FlushColumn ClearColumn containedin=ALL
syn keyword rslFunction SetDefPrec SetOutHandler GetPRNInfo SetPRNInfo SetDefMoneyPrec containedin=ALL

" Стандартные процедуры ввода данных
syn keyword rslFunction GetInt GetDouble GetMoney GetString GetStringR GetDate GetTRUE GetTime containedin=ALL

" Процедуры для работы со строками
syn keyword rslFunction CodeFor Index StrBrk StrFor StrLen StrLwr StrSet StrSplit StrSplit2 containedin=ALL
syn keyword rslFunction StrSubst StrUpr SubStr ToANSI ToOEM Trim containedin=ALL

" Параметры процедур
syn keyword rslFunction GetParm SetParm Parmcount containedin=ALL

" Математические процедуры
syn keyword rslFunction Exp Log Log10 Pow Sqrt Abs Min Max Mod containedin=ALL

" Процедуры управления файлами и каталогами
syn keyword rslFunction CopyFile GetCurDir GetFileInfo GetIniFileValue MakeDir RemoveDir RemoveFile RenameFile containedin=ALL

" Процедура запуска внешних программ Run
syn keyword rslFunction Run containedin=ALL

" Процедура удаленного запуска макропрограмм CallRemoteRsl
syn keyword rslFunction CallRemoteRsl containedin=ALL

" Процедуры для работы с классами и объектами
syn keyword rslFunction CallR2M record ClrRmtOnRelease GenAttach GenClassName GenGetProp GenNumProps GenObject containedin=ALL
syn keyword rslFunction	GenPropID GenRun GenSetProp GetNamedChanel IsEqClass R2M containedin=ALL

" Прочие процедуры
syn keyword rslFunction AddEvent BegAction EndAction CmdArgs CurrentLine ClassKind CheckBits DateShift containedin=ALL
syn keyword rslFunction InstLoadModule ErrBox ErrPrint ExecExp ExecMacro ExecMacro2 ExecMacroFile containedin=ALL
syn keyword rslFunction ExecMacroModule Exit FindPath GetEnv GetLangId GetLocaleInfo GetUIMode GetSysDir containedin=ALL
syn keyword rslFunction GetUserName GCollect IsSQL MemSize MergeFile ModuleFileName ModuleName MsgBoxEx containedin=ALL
syn keyword rslFunction PrintModule PrintSymModule PrintFiles PrintRefs PrintProps PrintGlobs PrintLocs containedin=ALL
syn keyword rslFunction PrintStack Random ReplaceMacro RunError SetExitFlag SplitFile StrongRef StartProg containedin=ALL
syn keyword rslFunction SysGetProperty SysPutProperty Trace UnderRCWHost Version ZeroValue containedin=ALL

" Types
syn keyword rslBoolean  null
syn match   rslType     "\(var\s\+\w\+\(\s\+\|\)\)\@<=:\(\s\+\|\)\(float\|real\|int\|string\|bool\|money\|numeric\|double\|date\|time\|datetime\)"  
syn match   rslType     "\(var\s\+\w\+\(\s\+\|\)\)\@<=:\(\s\+\|\)\w\+"  
syn keyword rslType     Variant MemAddr ProcRef MethodRef SpecVal
syn keyword rslType     local private

" Exception
syn keyword rslExeption OnError

" Object types
syn keyword rslType     Tbfile TRecHandler TStreamDoc Object
syn keyword rslType     TArray TDirList TRslChanel TRcwSite TRslEvHandler TRslEvSourse TRcwHost 
syn keyword rslType	TRsAxServer TClrHost TStream TDbError RslTimer
syn keyword rslType     TControl addHandler

hi def link rslClass			rslDefine
hi def link rslModule			rslDefine
hi def link rslMethodExceptional	rslDefine
hi def link rslDefine			Define
hi def link rslFunction	                Function
hi def link rslConditional		Conditional
hi def link rslConditionalModifier	rslConditional
hi def link rslExceptional		rslConditional
hi def link rslRepeat			Repeat
hi def link rslRepeatModifier		rslRepeat
hi def link rslOptionalDo		rslRepeat
hi def link rslControl			Statement
hi def link rslInclude			Include
hi def link rslInteger			Number
hi def link rslASCIICode		Character
hi def link rslFloat			Float
hi def link rslBoolean			Boolean
hi def link rslException		Exception
hi def link rslIdentifier		Identifier
hi def link rslConstant		        Type
hi def link rslBlockParameter		rslIdentifier
hi def link rslKeyword			Keyword
hi def link rslOperator			Operator
hi def link rslAccess			Statement

hi def link rslComment			Comment
hi def link rslDocumentation		Comment
hi def link rslTodo			Todo
hi def link rslCommentTitle             PreProc

hi def link rslQuoteEscape		rslStringEscape
hi def link rslStringEscape		Special
hi def link rslInterpolationDelimiter	Delimiter
hi def link rslNoInterpolation		rslString
hi def link rslSharpBang		PreProc
hi def link rslSymbolDelimiter		rslStringDelimiter
hi def link rslStringDelimiter		Delimiter
hi def link rslString			String

hi def link rslInvalidVariable		Error
hi def link rslError			Error
hi def link rslSpaceError		rslError
hi def link rslType		        Type

" Cleanup: {{{1
let &cpo = s:keepcpo
unlet s:keepcpo

let b:current_syntax = "rsl"
