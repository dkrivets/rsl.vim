" Vim syntax file
" Language: RSL 
" Version: 0.1
" Maintainer: Dmitry Krivets
" Latest Revision: 28 August 2015

if version < 600
	syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn sync fromstart
syn case ignore
set nofoldenable

" Working with block method and classes
syn cluster rslNotTop contains=rslConditional

syn region rslBlockParameterList start="\%(\%(\<do\>\|{\)\s*\)\@<=|" end="|" oneline display contains=rslBlockParameter


syn match  rslMethodDeclaration   "[^[:space:];#(]\+"	 contained contains=rslConstant,rslBoolean, rslFunction
syn match  rslClassDeclaration    "[^[:space:];#<]\+"	 contained contains=rslConstant,rslOperator 
", rlsFunction
syn match  rslDefine "\<macro\>"  nextgroup=rslMethodDeclaration skipwhite skipnl
syn match  rslClass	 "\<class\>"  nextgroup=rslClassDeclaration  skipwhite skipnl

syn region rslMethodBlock start="\<macro\>"	matchgroup=rslDefine end="\%(\<macro\_s\+\)\@<!\<end\>" contains=ALLBUT,@rslNotTop fold keepend
syn region rslBlock	      start="\<class\>"	matchgroup=rslClass  end="\<end\>"		                  contains=ALLBUT,@rslNotTop fold keepend
" if-else-elif
syn region rslConditionalExpression matchgroup=rslConditional start="\%(\%(^\|\.\.\.\=\|[{:,;([<>~\*/%&^|+=-]\|\%(\<[_[:lower:]][_[:alnum:]]*\)\@<![?!]\)\s*\)\@<=\%(if\|unless\)\>" end="\%(\%(\%(\.\@<!\.\)\|::\)\s*\)\@<!\<end\>" contains=ALLBUT,@rslNotTop fold
syn match  rslConditional "\<\%(else\|elif\)\>[?!]\@!" contained containedin=rslConditionalExpression
" Function
syn match rslFunction /\(macro\s\+\)\@<=\w\+/

"+syn match       rslType              /\<macro\>/
"+syn match       rslDeclaration       /^macro\>/
"+syn match       rslType              /\<class\>/
"+syn match       rslDeclaration       /^class\>/
" Regions
" syn region      goBlock             start="(class\|macro\|if)" end="end" transparent fold
syn region      rslParen             start='(' end=')' transparent




" Simple define
syn keyword rslDefine          var
syn keyword rslStatement       break return continue 
syn keyword	rslRepeat		       while for
syn keyword rslConstant        V_BOOL V_INT
syn keyword rslOperator        and or not
" Import
syn match   rslInclude         "\<import\>[?!]\@!"
syn keyword rslInclude   			 import



" Function
" Cast function
syn keyword rslFunction Asize CurToStrAlt Date DateSplit Decimal Double DoubleL 
syn keyword rslFunction DtTm DtTmSplit Floor Int MkStr Money MonName NumToStr Round 
syn keyword rslFunction RubToStr RubToStrAlt SetAutoMoneyFloor String Time TimeSplit ValType

" Стандартные процедуры вывода
syn keyword rslFunction Print PrintLn Message SetOutput SetColumn FlushColumn ClearColumn 
syn keyword rslFunction SetDefPrec SetOutHandler GetPRNInfo SetPRNInfo SetDefMoneyPrec 

" Стандартные процедуры ввода данных
syn keyword rslFunction GetInt GetDouble GetMoney GetString GetStringR GetDate GetTRUE GetTime

" Процедуры для работы со строками
syn keyword rslFunction CodeFor Index StrBrk StrFor StrLen StrLwr StrSet StrSplit StrSplit2 
syn keyword rslFunction StrSubst StrUpr SubStr ToANSI ToOEM Trim

" Параметры процедур
syn keyword rslFunction GetParm SetParm Parmcount

" Математические процедуры
syn keyword rslFunction Exp Log Log10 Pow Sqrt Abs Min Max Mod

" Процедуры управления файлами и каталогами
syn keyword rslFunction CopyFile GetCurDir GetFileInfo GetIniFileValue MakeDir RemoveDir RemoveFile RenameFile

" Процедура запуска внешних программ Run
syn keyword rslFunction Run

" Процедура удаленного запуска макропрограмм CallRemoteRsl
syn keyword rslFunction CallRemoteRsl

" Процедуры для работы с классами и объектами
syn keyword rslFunction CallR2M record ClrRmtOnRelease GenAttach GenClassName GenGetProp GenNumProps GenObject 
syn keyword rslFunction	GenPropID GenRun GenSetProp GetNamedChanel IsEqClass R2M

" Прочие процедуры
syn keyword rslFunction AddEvent BegAction EndAction CmdArgs CurrentLine ClassKind CheckBits DateShift 
syn keyword rslFunction InstLoadModule ErrBox ErrPrint ExecExp ExecMacro ExecMacro2 ExecMacroFile 
syn keyword rslFunction ExecMacroModule Exit FindPath GetEnv GetLangId GetLocaleInfo GetUIMode GetSysDir 
syn keyword rslFunction GetUserName GCollect IsSQL MemSize MergeFile ModuleFileName ModuleName MsgBoxEx 
syn keyword rslFunction PrintModule PrintSymModule PrintFiles PrintRefs PrintProps PrintGlobs PrintLocs 
syn keyword rslFunction PrintStack Random ReplaceMacro RunError SetExitFlag SplitFile StrongRef StartProg 
syn keyword rslFunction SysGetProperty SysPutProperty Trace UnderRCWHost Version ZeroValue

" Types
syn keyword rslBoolean  true false null
syn match rslType       "\(var \w\+\)\@<=:\(float\|real\|int\|string\|bool\|money\|numeric\|double\)"  
"syn keyword rslType    :date :time :datetime
syn keyword rslType     Variant MemAddr ProcRef MethodRef SpecVal
syn keyword rslType     local private

" Exception
syn keyword rslExeption OnError

" Object types
syn keyword rslType     Tbfile TRecHandler TStreamDoc Object
syn keyword rslType     TArray TDirList TRslChanel TRcwSite TRslEvHandler TRslEvSourse TRcwHost 
syn keyword rslType		  TRsAxServer TClrHost TStream TDbError RslTimer
syn keyword rslType     TControl addHandler


" MinMax and + - / *
syn match rslOperator   "[+\-/*=]"
syn match rslMinMax     "[<>]="
syn match rslMinMax     "!="
syn match rslMinMax     "=="

syn match rslNumber		  "-\=\<\d\+\>"
syn match rslFloat		  "-\=\<\d\+\.\d\+\>"
syn match rslFloat		  "-\=\<\d\+\.\d\+[eE]-\=\d\+\>"
syn match rslHexNumber	"\$[0-9a-fA-F]\+\>"


" String
syn region rslString start=/"/ skip=/\\"/ end=/"/ contains=rslEscapeSymbol,rslDoubleQuoteEscape
syn match  rslEscapeSymbol /\\[ntrb]/ contained
syn match  rslDoubleQuoteEscape /\\"/ contained

" Comments
syn keyword rslTodo              TODO FIXME XXX BUG
syn cluster rslCommentGroup      contains=rslTodo
" Multyline
syn region  rslComment start="/\*" end="\*/" contains=rslCommentGroup,@Spell fold
" Oneline
syn region  rslComment start=/\/\// end=/$/ contains=rslCommentGroup,@Spell fold 

hi def link rslStructure       Structure
hi def link rslStatement		   Statement
hi def link rslConditional	   Conditional
hi def link rslRepeat		       Repeat
hi def link rslType		         Type
hi def link rslConstant		     Constant
hi def link rslComment         Comment
hi def link rslTodo            Todo
hi def link rslString          String
hi def link rslFunction        Function
hi def link rslOperator        Operator
hi def link rslMinMax          Operator
hi def link rslNumber          Number
hi def link rslFloat           Float
hi def link rslHexNumber       Number
hi def link rslBoolean         Boolean
hi def link rslClass           Define
hi def link rslDefine          Define
hi def link rslExeption        Exception
hi def link rslEscapeSymbol    Special 
hi def link rslInclude         Include 

let b:current_syntax = "rsl"
