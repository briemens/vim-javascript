" Vim syntax file
" Language:     JavaScript
" Maintainer:   vim-javascript community
" URL:          https://github.com/pangloss/vim-javascript

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'javascript'
endif

if !exists('g:javascript_conceal')
  let g:javascript_conceal = 0
endif

"" dollar sign is permittd anywhere in an identifier
setlocal iskeyword+=$

syntax sync fromstart

syntax match JavaScriptNoise           /[:,\;\.]\{1}/

"" Program Keywords
syntax keyword JavaScriptStorageClass   const var let contained
syntax keyword JavaScriptOperator       delete instanceof typeof void new in
syntax match JavaScriptOperator       /[\!\|\&\+\-\<\>\=\%\/\*\~\^\\]\{1}/
syntax keyword JavaScriptBooleanTrue    true
syntax keyword JavaScriptBooleanFalse   false
syntax keyword JavaScriptModules        import export contained
syntax keyword JavaScriptModuleWords    default from as contained
syntax keyword JavaScriptOf             of contained
syntax keyword JavaScriptArgsObj        arguments

syntax region JavaScriptImportContainer      start="^\s\?import \?" end=";\|$" contains=JavaScriptModules,JavaScriptModuleWords,JavaScriptLineComment,JavaScriptComment,JavaScriptStringS,JavaScriptStringD,JavaScriptTemplateString,JavaScriptNoise,JavaScriptBlock

syntax region JavaScriptExportContainer      start="^\s\?export \?" end="$" contains=JavaScriptModules,JavaScriptModuleWords,JavaScriptComment,JavaScriptTemplateString,JavaScriptStringD,JavaScriptStringS,JavaScriptRegexpString,JavaScriptNumber,JavaScriptFloat,JavaScriptThis,JavaScriptOperator,JavaScriptBooleanTrue,JavaScriptBooleanFalse,JavaScriptNull,JavaScriptFunction,JavaScriptArrowFunction,JavaScriptGlobalObjects,JavaScriptExceptions,JavaScriptDomErrNo,JavaScriptDomNodeConsts,JavaScriptHtmlEvents,JavaScriptDotNotation,JavaScriptBracket,JavaScriptParen,JavaScriptFuncCall,JavaScriptUndefined,JavaScriptNan,JavaScriptKeyword,JavaScriptStorageClass,JavaScriptPrototype,JavaScriptBuiltins,JavaScriptNoise,JavaScriptArgsObj,JavaScriptBlock,JavaScriptClassDefinition

"" JavaScript comments
syntax keyword JavaScriptCommentTodo    TODO FIXME XXX TBD contained
syntax region JavaScriptLineComment    start=+\/\/+ end=+$+ keepend contains=JavaScriptCommentTodo,@Spell extend
syntax region JavaScriptEnvComment     start="\%^#!" end="$" display
syntax region JavaScriptLineComment    start=+^\s*\/\/+ skip=+\n\s*\/\/+ end=+$+ keepend contains=JavaScriptCommentTodo,@Spell fold
syntax region JavaScriptCvsTag         start="\$\cid:" end="\$" oneline contained
syntax region JavaScriptComment        start="/\*"  end="\*/" contains=JavaScriptCommentTodo,JavaScriptCvsTag,@Spell fold extend

"" JSDoc / JSDoc Toolkit
if !exists("javascript_ignore_javaScriptdoc")
  syntax case ignore

  "" syntax coloring for javadoc comments (HTML)
  "syntax include @javaHtml <sfile>:p:h/html.vim
  "unlet b:current_syntax

  syntax region JavaScriptBlockComment    matchgroup=JavaScriptComment start="/\*\s*"  end="\*/" contains=JavaScriptDocTags,JavaScriptCommentTodo,JavaScriptCvsTag,@jsHtml,@Spell fold

  " tags containing a param
  syntax match JavaScriptDocTags         contained "@\(alias\|api\|augments\|borrows\|class\|constructs\|default\|defaultvalue\|emits\|exception\|exports\|extends\|fires\|kind\|link\|listens\|member\|member[oO]f\|mixes\|module\|name\|namespace\|requires\|template\|throws\|var\|variation\|version\)\>" nextgroup=JavaScriptDocParam skipwhite
  " tags containing type and param
  syntax match JavaScriptDocTags         contained "@\(arg\|argument\|cfg\|param\|property\|prop\)\>" nextgroup=JavaScriptDocType skipwhite
  " tags containing type but no param
  syntax match JavaScriptDocTags         contained "@\(callback\|define\|enum\|external\|implements\|this\|type\|typedef\|return\|returns\)\>" nextgroup=JavaScriptDocTypeNoParam skipwhite
  " tags containing references
  syntax match JavaScriptDocTags         contained "@\(lends\|see\|tutorial\)\>" nextgroup=JavaScriptDocSeeTag skipwhite
  " other tags (no extra syntax)
  syntax match JavaScriptDocTags         contained "@\(abstract\|access\|accessor\|author\|classdesc\|constant\|const\|constructor\|copyright\|deprecated\|desc\|description\|dict\|event\|example\|file\|file[oO]verview\|final\|function\|global\|ignore\|inheritDoc\|inner\|instance\|interface\|license\|localdoc\|method\|mixin\|nosideeffects\|override\|overview\|preserve\|private\|protected\|public\|readonly\|since\|static\|struct\|todo\|summary\|undocumented\|virtual\)\>"

  syntax region JavaScriptDocType         matchgroup=JavaScriptDocTypeBrackets start="{" end="}" oneline contained nextgroup=JavaScriptDocParam skipwhite contains=JavaScriptDocTypeRecord
  syntax match JavaScriptDocType         contained "\%(#\|\"\|\w\|\.\|:\|\/\)\+" nextgroup=JavaScriptDocParam skipwhite
  syntax region JavaScriptDocTypeRecord   start=/{/ end=/}/ contained extend contains=JavaScriptDocTypeRecord
  syntax region JavaScriptDocTypeRecord   start=/\[/ end=/\]/ contained extend contains=JavaScriptDocTypeRecord
  syntax region JavaScriptDocTypeNoParam  start="{" end="}" oneline contained
  syntax match JavaScriptDocTypeNoParam  contained "\%(#\|\"\|\w\|\.\|:\|\/\)\+"
  syntax match JavaScriptDocParam        contained "\%(#\|\$\|-\|'\|\"\|{.\{-}}\|\w\|\.\|:\|\/\|\[.{-}]\|=\)\+"
  syntax region JavaScriptDocSeeTag       contained matchgroup=JavaScriptDocSeeTag start="{" end="}" contains=JavaScriptDocTags

  syntax case match
endif   "" JSDoc end

syntax case match

"" Syntax in the JavaScript code
" syntax match   javaScriptIdentifier      /\k\+/
syntax match   javaScriptIdentifier      /\.\k\+/
syntax match JavaScriptFuncCall         /\k\+\%(\s*(\)\@=/
syntax match JavaScriptSpecial          "\v\\%(0|\\x\x\{2\}\|\\u\x\{4\}\|\c[A-Z]|.)" contained
syntax region JavaScriptTemplateVar      matchgroup=JavaScriptTemplateBraces start=+${+ end=+}+ contained contains=@jsExpression
syntax region JavaScriptStringD          start=+"+  skip=+\\\("\|$\)+  end=+"\|$+  contains=JavaScriptSpecial,@htmlPreproc,@Spell
syntax region JavaScriptStringS          start=+'+  skip=+\\\('\|$\)+  end=+'\|$+  contains=JavaScriptSpecial,@htmlPreproc,@Spell
syntax region JavaScriptTemplateString   start=+`+  skip=+\\\(`\|$\)+  end=+`+     contains=JavaScriptTemplateVar,JavaScriptSpecial,@htmlPreproc fold
syntax region JavaScriptTaggedTemplate   start=/\k\+\%([\n\s]\+\)\?`/ end=+`+ contains=JavaScriptTemplateString keepend
syntax region JavaScriptRegexpCharClass  start=+\[+ skip=+\\.+ end=+\]+ contained
syntax match JavaScriptRegexpBoundary   "\v%(\<@![\^$]|\\[bB])" contained
syntax match JavaScriptRegexpBackRef    "\v\\[1-9][0-9]*" contained
syntax match JavaScriptRegexpQuantifier "\v\\@<!%([?*+]|\{\d+%(,|,\d+)?})\??" contained
syntax match JavaScriptRegexpOr         "\v\<@!\|" contained
syntax match JavaScriptRegexpMod        "\v\(@<=\?[:=!>]" contained
syntax cluster jsRegexpSpecial    contains=JavaScriptSpecial,JavaScriptRegexpBoundary,JavaScriptRegexpBackRef,JavaScriptRegexpQuantifier,JavaScriptRegexpOr,JavaScriptRegexpMod
syntax region JavaScriptRegexpGroup      start="\\\@<!(" skip="\\.\|\[\(\\.\|[^]]\)*\]" end="\\\@<!)" contained contains=JavaScriptRegexpCharClass,@jsRegexpSpecial keepend
if v:version > 703 || v:version == 603 && has("patch1088")
  syntax region JavaScriptRegexpString     start=+\%(\%(\%(return\|case\)\s\+\)\@50<=\|\%(\%([)\]"']\|\d\|\w\)\s*\)\@50<!\)/\(\*\|/\)\@!+ skip=+\\.\|\[\%(\\.\|[^]]\)*\]+ end=+/[gimy]\{,4}+ contains=JavaScriptRegexpCharClass,JavaScriptRegexpGroup,@jsRegexpSpecial,@htmlPreproc oneline keepend
else
  syntax region JavaScriptRegexpString     start=+\%(\%(\%(return\|case\)\s\+\)\@<=\|\%(\%([)\]"']\|\d\|\w\)\s*\)\@<!\)/\(\*\|/\)\@!+ skip=+\\.\|\[\%(\\.\|[^]]\)*\]+ end=+/[gimy]\{,4}+ contains=JavaScriptRegexpCharClass,JavaScriptRegexpGroup,@jsRegexpSpecial,@htmlPreproc oneline keepend
endif
syntax match JavaScriptNumber           /\<-\=\d\+\(L\|[eE][+-]\=\d\+\)\=\>\|\<0[xX]\x\+\>/
syntax keyword JavaScriptNumber           Infinity
syntax match JavaScriptFloat            /\<-\=\%(\d\+\.\d\+\|\d\+\.\|\.\d\+\)\%([eE][+-]\=\d\+\)\=\>/
syntax match JavaScriptObjectKey        /\<[a-zA-Z_$][0-9a-zA-Z_$]*\>\(\s*:\)\@=/ contains=JavaScriptFunctionKey contained
syntax match JavaScriptFunctionKey      /\<[a-zA-Z_$][0-9a-zA-Z_$]*\>\(\s*:\s*function\s*\)\@=/ contained
syntax match JavaScriptDecorator        "@" display contains=JavaScriptDecoratorFunction nextgroup=JavaScriptDecoratorFunction skipwhite
syntax match JavaScriptDecoratorFunction "[a-zA-Z_][a-zA-Z0-9_.]*" display contained nextgroup=JavaScriptFunc skipwhite

exe 'syntax keyword JavaScriptNull      null      '.(exists('g:javascript_conceal_null')        ? 'conceal cchar='.g:javascript_conceal_null        : '')
exe 'syntax keyword JavaScriptReturn    return    '.(exists('g:javascript_conceal_return')      ? 'conceal cchar='.g:javascript_conceal_return      : '')
exe 'syntax keyword JavaScriptUndefined undefined '.(exists('g:javascript_conceal_undefined')   ? 'conceal cchar='.g:javascript_conceal_undefined   : '')
exe 'syntax keyword JavaScriptNan       NaN       '.(exists('g:javascript_conceal_NaN')         ? 'conceal cchar='.g:javascript_conceal_NaN         : '')
exe 'syntax keyword JavaScriptPrototype prototype '.(exists('g:javascript_conceal_prototype')   ? 'conceal cchar='.g:javascript_conceal_prototype   : '')
exe 'syntax keyword JavaScriptThis      this      '.(exists('g:javascript_conceal_this')        ? 'conceal cchar='.g:javascript_conceal_this        : '')
exe 'syntax keyword JavaScriptStatic    static    '.(exists('g:javascript_conceal_static')      ? 'conceal cchar='.g:javascript_conceal_static      : '')
exe 'syntax keyword JavaScriptSuper     super     '.(exists('g:javascript_conceal_super')       ? 'conceal cchar='.g:javascript_conceal_super       : '')

"" Statement Keywords
syntax keyword JavaScriptStatement      break continue with
syntax keyword JavaScriptConditional    if else switch
syntax keyword JavaScriptRepeat         do while for
syntax keyword JavaScriptLabel          case default
syntax keyword JavaScriptKeyword        yield
syntax keyword JavaScriptException      try catch throw finally
syntax keyword JavaScriptAsyncKeyword   async await

syntax keyword JavaScriptGlobalObjects   Array Boolean Date Function Iterator Number Object Symbol Map WeakMap Set RegExp String Proxy Promise Buffer ParallelArray ArrayBuffer DataView Float32Array Float64Array Int16Array Int32Array Int8Array Uint16Array Uint32Array Uint8Array Uint8ClampedArray JSON Math console document window Intl Collator DateTimeFormat NumberFormat

syntax keyword JavaScriptExceptions     Error EvalError InternalError RangeError ReferenceError StopIteration SyntaxError TypeError URIError

syntax keyword JavaScriptBuiltins       decodeURI decodeURIComponent encodeURI encodeURIComponent eval isFinite isNaN parseFloat parseInt uneval

syntax keyword JavaScriptFutureKeys     abstract enum int short boolean interface byte long char final native synchronized float package throws goto private transient debugger implements protected volatile double public

"" DOM/HTML/CSS specified things

" DOM2 Objects
syntax keyword JavaScriptGlobalObjects  DOMImplementation DocumentFragment Document Node NodeList NamedNodeMap CharacterData Attr Element Text Comment CDATASection DocumentType Notation Entity EntityReference ProcessingInstruction
syntax keyword JavaScriptExceptions     DOMException

" DOM2 CONSTANT
syntax keyword JavaScriptDomErrNo       INDEX_SIZE_ERR DOMSTRING_SIZE_ERR HIERARCHY_REQUEST_ERR WRONG_DOCUMENT_ERR INVALID_CHARACTER_ERR NO_DATA_ALLOWED_ERR NO_MODIFICATION_ALLOWED_ERR NOT_FOUND_ERR NOT_SUPPORTED_ERR INUSE_ATTRIBUTE_ERR INVALID_STATE_ERR SYNTAX_ERR INVALID_MODIFICATION_ERR NAMESPACE_ERR INVALID_ACCESS_ERR
syntax keyword JavaScriptDomNodeConsts  ELEMENT_NODE ATTRIBUTE_NODE TEXT_NODE CDATA_SECTION_NODE ENTITY_REFERENCE_NODE ENTITY_NODE PROCESSING_INSTRUCTION_NODE COMMENT_NODE DOCUMENT_NODE DOCUMENT_TYPE_NODE DOCUMENT_FRAGMENT_NODE NOTATION_NODE

" HTML events and internal variables
syntax case ignore
syntax keyword JavaScriptHtmlEvents     onblur onclick oncontextmenu ondblclick onfocus onkeydown onkeypress onkeyup onmousedown onmousemove onmouseout onmouseover onmouseup onresize
syntax case match

" Follow stuff should be highligh within a special context
" While it can't be handled with context depended with Regex based highlight
" So, turn it off by default
if exists("javascript_enable_domhtmlcss")

    " DOM2 things
    syntax match JavaScriptDomElemAttrs     contained /\%(nodeName\|nodeValue\|nodeType\|parentNode\|childNodes\|firstChild\|lastChild\|previousSibling\|nextSibling\|attributes\|ownerDocument\|namespaceURI\|prefix\|localName\|tagName\)\>/
    syntax match JavaScriptDomElemFuncs     contained /\%(insertBefore\|replaceChild\|removeChild\|appendChild\|hasChildNodes\|cloneNode\|normalize\|isSupported\|hasAttributes\|getAttribute\|setAttribute\|removeAttribute\|getAttributeNode\|setAttributeNode\|removeAttributeNode\|getElementById\|getElementsByClassName\|getElementsByTagName\|querySelector\|querySelectorAll\|getAttributeNS\|setAttributeNS\|removeAttributeNS\|getAttributeNodeNS\|setAttributeNodeNS\|getElementsByTagNameNS\|hasAttribute\|hasAttributeNS\)\>/ nextgroup=JavaScriptParen skipwhite
    " HTML things
    syntax match JavaScriptHtmlElemAttrs    contained /\%(className\|clientHeight\|clientLeft\|clientTop\|clientWidth\|dir\|id\|innerHTML\|lang\|length\|offsetHeight\|offsetLeft\|offsetParent\|offsetTop\|offsetWidth\|scrollHeight\|scrollLeft\|scrollTop\|scrollWidth\|style\|tabIndex\|title\)\>/
    syntax match JavaScriptHtmlElemFuncs    contained /\%(blur\|click\|focus\|scrollIntoView\|addEventListener\|dispatchEvent\|removeEventListener\|item\)\>/ nextgroup=JavaScriptParen skipwhite

    " CSS Styles in JavaScript
    syntax keyword JavaScriptCssStyles      contained color font fontFamily fontSize fontSizeAdjust fontStretch fontStyle fontVariant fontWeight letterSpacing lineBreak lineHeight quotes rubyAlign rubyOverhang rubyPosition
    syntax keyword JavaScriptCssStyles      contained textAlign textAlignLast textAutospace textDecoration textIndent textJustify textJustifyTrim textKashidaSpace textOverflowW6 textShadow textTransform textUnderlinePosition
    syntax keyword JavaScriptCssStyles      contained unicodeBidi whiteSpace wordBreak wordSpacing wordWrap writingMode
    syntax keyword JavaScriptCssStyles      contained bottom height left position right top width zIndex
    syntax keyword JavaScriptCssStyles      contained border borderBottom borderLeft borderRight borderTop borderBottomColor borderLeftColor borderTopColor borderBottomStyle borderLeftStyle borderRightStyle borderTopStyle borderBottomWidth borderLeftWidth borderRightWidth borderTopWidth borderColor borderStyle borderWidth borderCollapse borderSpacing captionSide emptyCells tableLayout
    syntax keyword JavaScriptCssStyles      contained margin marginBottom marginLeft marginRight marginTop outline outlineColor outlineStyle outlineWidth padding paddingBottom paddingLeft paddingRight paddingTop
    syntax keyword JavaScriptCssStyles      contained listStyle listStyleImage listStylePosition listStyleType
    syntax keyword JavaScriptCssStyles      contained background backgroundAttachment backgroundColor backgroundImage backgroundPosition backgroundPositionX backgroundPositionY backgroundRepeat
    syntax keyword JavaScriptCssStyles      contained clear clip clipBottom clipLeft clipRight clipTop content counterIncrement counterReset cssFloat cursor direction display filter layoutGrid layoutGridChar layoutGridLine layoutGridMode layoutGridType
    syntax keyword JavaScriptCssStyles      contained marks maxHeight maxWidth minHeight minWidth opacity MozOpacity overflow overflowX overflowY verticalAlign visibility zoom cssText
    syntax keyword JavaScriptCssStyles      contained scrollbar3dLightColor scrollbarArrowColor scrollbarBaseColor scrollbarDarkShadowColor scrollbarFaceColor scrollbarHighlightColor scrollbarShadowColor scrollbarTrackColor

    " Highlight ways
    syntax match JavaScriptDotNotation      "\." nextgroup=JavaScriptPrototype,JavaScriptDomElemAttrs,JavaScriptDomElemFuncs,JavaScriptHtmlElemAttrs,JavaScriptHtmlElemFuncs
    syntax match JavaScriptDotNotation      "\.style\." nextgroup=JavaScriptCssStyles

endif "DOM/HTML/CSS

"" end DOM/HTML/CSS specified things

"" Code blocks
syntax cluster jsExpression contains=JavaScriptComment,JavaScriptLineComment,JavaScriptBlockComment,JavaScriptTaggedTemplate,JavaScriptTemplateString,JavaScriptStringD,JavaScriptStringS,JavaScriptRegexpString,JavaScriptNumber,JavaScriptFloat,JavaScriptThis,JavaScriptStatic,JavaScriptSuper,JavaScriptOperator,JavaScriptBooleanTrue,JavaScriptBooleanFalse,JavaScriptNull,JavaScriptFunction,JavaScriptArrowFunction,JavaScriptGlobalObjects,JavaScriptExceptions,JavaScriptFutureKeys,JavaScriptDomErrNo,JavaScriptDomNodeConsts,JavaScriptHtmlEvents,JavaScriptDotNotation,JavaScriptBracket,JavaScriptParen,JavaScriptBlock,JavaScriptFuncCall,JavaScriptUndefined,JavaScriptNan,JavaScriptKeyword,JavaScriptStorageClass,JavaScriptPrototype,JavaScriptBuiltins,JavaScriptNoise,JavaScriptCommonJS,JavaScriptImportContainer,JavaScriptExportContainer,JavaScriptArgsObj,JavaScriptDecorator,JavaScriptAsyncKeyword,JavaScriptClassDefinition,JavaScriptArrowFunction,JavaScriptArrowFuncArgs,javaScriptIdentifier
" syntax cluster jsExpression contains=JavaScriptComment,JavaScriptLineComment,JavaScriptBlockComment,JavaScriptTaggedTemplate,JavaScriptTemplateString,JavaScriptStringD,JavaScriptStringS,JavaScriptRegexpString,JavaScriptNumber,JavaScriptFloat,JavaScriptThis,JavaScriptStatic,JavaScriptSuper,JavaScriptOperator,JavaScriptBooleanTrue,JavaScriptBooleanFalse,JavaScriptNull,JavaScriptFunction,JavaScriptArrowFunction,JavaScriptGlobalObjects,JavaScriptExceptions,JavaScriptFutureKeys,JavaScriptDomErrNo,JavaScriptDomNodeConsts,JavaScriptHtmlEvents,JavaScriptDotNotation,JavaScriptBracket,JavaScriptParen,JavaScriptBlock,JavaScriptFuncCall,JavaScriptUndefined,JavaScriptNan,JavaScriptKeyword,JavaScriptStorageClass,JavaScriptPrototype,JavaScriptBuiltins,JavaScriptNoise,JavaScriptCommonJS,JavaScriptImportContainer,JavaScriptExportContainer,JavaScriptArgsObj,JavaScriptDecorator,JavaScriptAsyncKeyword,JavaScriptClassDefinition,JavaScriptArrowFunction,JavaScriptArrowFuncArgs
syntax cluster jsAll        contains=@jsExpression,JavaScriptLabel,JavaScriptConditional,JavaScriptRepeat,JavaScriptReturn,JavaScriptStatement,JavaScriptTernaryIf,JavaScriptException
syntax region JavaScriptBracket    matchgroup=JavaScriptBrackets     start="\[" end="\]" contains=@jsAll,JavaScriptParensErrB,JavaScriptParensErrC,JavaScriptBracket,JavaScriptParen,JavaScriptBlock,@htmlPreproc fold
syntax region JavaScriptParen      matchgroup=JavaScriptParens       start="("  end=")"  contains=@jsAll,JavaScriptOf,JavaScriptParensErrA,JavaScriptParensErrC,JavaScriptParen,JavaScriptBracket,JavaScriptBlock,@htmlPreproc fold extend
syntax region JavaScriptClassBlock matchgroup=JavaScriptClassBraces  start="{"  end="}"  contains=JavaScriptFuncName,JavaScriptClassMemberName,JavaScriptClassMethodDefinitions,JavaScriptOperator,JavaScriptArrowFunction,JavaScriptArrowFuncArgs,JavaScriptComment,JavaScriptBlockComment,JavaScriptLineComment,JavaScriptGenerator contained fold
syntax region JavaScriptFuncBlock  matchgroup=JavaScriptFuncBraces   start="{"  end="}"  contains=@jsAll,JavaScriptParensErrA,JavaScriptParensErrB,JavaScriptParen,JavaScriptBracket,JavaScriptBlock,@htmlPreproc,JavaScriptClassDefinition,JavaScriptVariableDefinition fold extend
syntax region JavaScriptBlock      matchgroup=JavaScriptBraces       start="{"  end="}"  contains=@jsAll,JavaScriptParensErrA,JavaScriptParensErrB,JavaScriptParen,JavaScriptBracket,JavaScriptBlock,JavaScriptObjectKey,@htmlPreproc,JavaScriptClassDefinition fold extend
syntax region JavaScriptTernaryIf  matchgroup=JavaScriptTernaryIfOperator start=+?+  end=+:+  contains=@jsExpression,JavaScriptTernaryIf

"" catch errors caused by wrong parenthesis
syntax match JavaScriptParensError    ")\|}\|\]"
syntax match JavaScriptParensErrA     contained "\]"
syntax match JavaScriptParensErrB     contained ")"
syntax match JavaScriptParensErrC     contained "}"

syntax match JavaScriptFuncArgDestructuring contained /\({\|}\|=\|:\|\[\|\]\)/ extend fold
syntax region JavaScriptFuncArgDestructuringBlock  contained matchgroup=JavaScriptFuncArgDestructuringBlock start="{"  end="}"  containedin=JavaScriptFuncParens contains=JavaScriptFuncArgs,JavaScriptFuncArgCommas,JavaScriptFuncArgDestructuring fold

exe 'syntax match JavaScriptFunction /\<function\>/ nextgroup=JavaScriptGenerator,JavaScriptFuncName,JavaScriptFuncArgs skipwhite '.(exists('g:javascript_conceal_function') ? 'conceal cchar='.g:javascript_conceal_function : '')
exe 'syntax match JavaScriptArrowFunction /=>/ skipwhite nextgroup=JavaScriptFuncBlock contains=JavaScriptFuncBraces '.(exists('g:javascript_conceal_arrow_function') ? 'conceal cchar='.g:javascript_conceal_arrow_function : '')

syntax match JavaScriptGenerator       contained /\*/ nextgroup=JavaScriptFuncName,JavaScriptFuncArgs skipwhite skipempty
syntax match JavaScriptFuncName        contained /\<[a-zA-Z_$][0-9a-zA-Z_$]*[\r\n\t ]*(\@=/ nextgroup=JavaScriptFuncArgs skipwhite skipempty
syntax match JavaScriptClassMemberName contained containedin=JavaScriptClassBlock /\%(\<[a-zA-Z_$][0-9a-zA-Z_$]*\)[\r\n\t ]*=/ contains=JavaScriptOperator nextgroup=JavaScriptBlock skipwhite skipempty
" These versions of jsFuncName is for use in object declarations with no key
" syntax match JavaScriptFuncName        contained /\%(^[\r\n\t ]*\)\@<=[*\r\n\t ]*[a-zA-Z_$][0-9a-zA-Z_$]*[\r\n\t ]*(\@=/ nextgroup=JavaScriptFuncArgs skipwhite skipempty containedin=JavaScriptBlock contains=JavaScriptGenerator
" syntax match JavaScriptFuncName        contained /\%(,[\r\n\t ]*\)\@<=[*\r\n\t ]*[a-zA-Z_$][0-9a-zA-Z_$]*[\r\n\t ]*(\@=/ nextgroup=JavaScriptFuncArgs skipwhite skipempty containedin=JavaScriptBlock contains=JavaScriptGenerator
syntax region JavaScriptFuncArgs        contained matchgroup=JavaScriptFuncParens start='(' end=')' contains=JavaScriptFuncArgCommas,JavaScriptFuncArgRest,JavaScriptComment,JavaScriptLineComment,JavaScriptStringS,JavaScriptStringD,JavaScriptNumber,JavaScriptFuncArgDestructuring,JavaScriptArrowFunction,JavaScriptParen,JavaScriptArrowFuncArgs,JavaScriptFuncArgCommas,JavaScriptFuncArgs,JavaScriptFuncArgDestructuringBlock nextgroup=JavaScriptFuncBlock keepend skipwhite skipempty fold
syntax match JavaScriptFuncArgCommas   contained ','
syntax match JavaScriptFuncArgRest     contained /\%(\.\.\.[a-zA-Z_$][0-9a-zA-Z_$]*\))/ contains=JavaScriptFuncArgRestDots
syntax match JavaScriptFuncArgRestDots contained /\.\.\./

" Matches a single keyword argument with no parens
syntax match JavaScriptArrowFuncArgs  /\k\+\s*\%(=>\)\@=/ skipwhite contains=JavaScriptFuncArgs nextgroup=JavaScriptArrowFunction extend
" Matches a series of arguments surrounded in parens
syntax match JavaScriptArrowFuncArgs  /([^()]*)\s*\(=>\)\@=/ skipempty skipwhite contains=JavaScriptFuncArgs nextgroup=JavaScriptArrowFunction extend

syntax keyword JavaScriptClassKeywords extends class contained
syntax match JavaScriptClassNoise /\./ contained
syntax keyword JavaScriptClassMethodDefinitions get set static contained nextgroup=JavaScriptFuncName skipwhite skipempty
syntax match JavaScriptClassDefinition /\<class\>\%( [a-zA-Z_$][0-9a-zA-Z_$ \n.]*\)*/  contains=JavaScriptClassKeywords,JavaScriptClassNoise nextgroup=JavaScriptClassBlock skipwhite skipempty
syntax match JavaScriptClassName        /\<[a-zA-Z_$][0-9a-zA-Z_$]*/ contained containedin=JavaScriptClassDefinition nextgroup=JavaScriptClassBlock skipwhite skipempty


" syntax match JavaScriptVariableDefinition /\<const\>\%( [a-zA-Z_$][0-9a-zA-Z_$ \n.]*\)*/  contains=JavaScriptClassKeywords,JavaScriptClassNoise nextgroup=JavaScriptClassBlock skipwhite skipempty
" syntax match JavaScriptAssignment /\%(\ *=\ *\)/ contains=JavaScriptOperator,JavaScriptFunction,JavaScriptArrowFuncArgs
" syntax match JavaScriptVariableDefinition /\<const\>\%( [a-zA-Z_$][0-9a-zA-Z_$ \n.]*\)*/ contains=JavaScriptStorageClass,JavaScriptClassNoise nextgroup=JavaScriptOperator skipwhite skipempty
" syntax match JavaScriptVariableName        /\<[a-zA-Z_$][0-9a-zA-Z_$]*/ contained containedin=JavaScriptVariableDefinition nextgroup=JavaScriptOperator skipwhite skipempty
" syntax match JavaScriptFunctionVariableDefinition /\<const\>\%( [a-zA-Z_$][0-9a-zA-Z_$ \n.]*\)*\ *=\ *\%(function\)/ contains=JavaScriptStorageClass,JavaScriptClassNoise,JavaScriptFunction skipwhite skipempty
" syntax match JavaScriptFunctionVariableName        /\<[a-zA-Z_$][0-9a-zA-Z_$]*/ contained containedin=JavaScriptFunctionVariableDefinition nextgroup=JavaScriptFunction skipwhite skipempty

syntax match JavaScriptVariableDefinition /[ \t]*\(const\|let\|var\)\%( [a-zA-Z_$][0-9a-zA-Z_$ \n.]*\)*/ contains=JavaScriptStorageClass,JavaScriptClassNoise nextgroup=JavaScriptOperator skipwhite skipempty
syntax match JavaScriptVariableName        /\<[a-zA-Z_$][0-9a-zA-Z_$]*/ contained containedin=JavaScriptVariableDefinition nextgroup=JavaScriptOperator skipwhite skipempty
" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_javascript_syn_inits")
  if version < 508
    let did_javascript_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink JavaScriptFuncArgRest          Special
  HiLink JavaScriptComment              Comment
  HiLink JavaScriptLineComment          Comment
  HiLink JavaScriptEnvComment           PreProc
  HiLink JavaScriptBlockComment         Comment
  HiLink JavaScriptCommentTodo          Todo
  HiLink JavaScriptCvsTag               Function
  HiLink JavaScriptDocTags              Special
  HiLink JavaScriptDocSeeTag            Function
  HiLink JavaScriptDocType              Type
  HiLink JavaScriptDocTypeBrackets      jsDocType
  HiLink JavaScriptDocTypeRecord        jsDocType
  HiLink JavaScriptDocTypeNoParam       Type
  HiLink JavaScriptDocParam             Label
  HiLink JavaScriptStringS              String
  HiLink JavaScriptStringD              String
  HiLink JavaScriptTemplateString       String
  HiLink JavaScriptTaggedTemplate       StorageClass
  HiLink JavaScriptTernaryIfOperator    Conditional
  HiLink JavaScriptRegexpString         String
  HiLink JavaScriptRegexpBoundary       SpecialChar
  HiLink JavaScriptRegexpQuantifier     SpecialChar
  HiLink JavaScriptRegexpOr             Conditional
  HiLink JavaScriptRegexpMod            SpecialChar
  HiLink JavaScriptRegexpBackRef        SpecialChar
  HiLink JavaScriptRegexpGroup          jsRegexpString
  HiLink JavaScriptRegexpCharClass      Character
  HiLink JavaScriptCharacter            Character
  HiLink JavaScriptPrototype            Special
  HiLink JavaScriptConditional          Conditional
  HiLink JavaScriptBranch               Conditional
  HiLink JavaScriptLabel                Label
  HiLink JavaScriptReturn               Statement
  HiLink JavaScriptRepeat               Repeat
  HiLink JavaScriptStatement            Statement
  HiLink JavaScriptException            Exception
  HiLink JavaScriptKeyword              Keyword
  HiLink JavaScriptAsyncKeyword         Keyword
  HiLink JavaScriptArrowFunction        Define
  HiLink JavaScriptFunction             Type
  HiLink JavaScriptGenerator            jsFunction
  HiLink JavaScriptArrowFuncArgs        jsFuncArgs
  HiLink JavaScriptFuncName             Function
  HiLink JavaScriptClassMemberName      Identifier
  HiLink JavaScriptArgsObj              Special
  HiLink JavaScriptError                Error
  HiLink JavaScriptParensError          Error
  HiLink JavaScriptParensErrA           Error
  HiLink JavaScriptParensErrB           Error
  HiLink JavaScriptParensErrC           Error
  HiLink JavaScriptOperator             Operator
  HiLink JavaScriptOf                   Operator
  HiLink JavaScriptStorageClass         StorageClass
  HiLink JavaScriptClassKeywords        Define
  HiLink JavaScriptThis                 Special
  HiLink JavaScriptStatic               Special
  HiLink JavaScriptSuper                Special
  HiLink JavaScriptNan                  Number
  HiLink JavaScriptNull                 Type
  HiLink JavaScriptUndefined            Type
  HiLink JavaScriptNumber               Number
  HiLink JavaScriptFloat                Float
  HiLink JavaScriptBooleanTrue          Boolean
  HiLink JavaScriptBooleanFalse         Boolean
  HiLink JavaScriptNoise                Noise
  HiLink JavaScriptBrackets             Noise
  HiLink JavaScriptParens               Noise
  HiLink JavaScriptBraces               Noise
  HiLink JavaScriptFuncBraces           Noise
  HiLink JavaScriptFuncParens           Noise
  HiLink JavaScriptClassBraces          Noise
  HiLink JavaScriptClassNoise           Noise
  HiLink JavaScriptSpecial              Special
  HiLink JavaScriptTemplateVar          Special
  HiLink JavaScriptTemplateBraces       jsBraces
  HiLink JavaScriptGlobalObjects        Special
  HiLink JavaScriptExceptions           Special
  HiLink JavaScriptFutureKeys           Special
  HiLink JavaScriptBuiltins             Special
  HiLink JavaScriptModules              Include
  HiLink JavaScriptModuleWords          Include
  HiLink JavaScriptDecorator            Special
  HiLink JavaScriptFuncArgRestDots      Noise
  HiLink JavaScriptFuncArgDestructuring Noise

  HiLink JavaScriptDomErrNo             Constant
  HiLink JavaScriptDomNodeConsts        Constant
  HiLink JavaScriptDomElemAttrs         Label
  HiLink JavaScriptDomElemFuncs         PreProc

  HiLink JavaScriptHtmlEvents           Special
  HiLink JavaScriptHtmlElemAttrs        Label
  HiLink JavaScriptHtmlElemFuncs        PreProc

  HiLink JavaScriptCssStyles            Label

  HiLink JavaScriptClassMethodDefinitions Type
  HiLink javaScriptIdentifier                   Identifier

  delcommand HiLink
endif

" Define the htmlJavaScript for HTML syntax html.vim
syntax cluster  htmlJavaScript       contains=@jsAll,JavaScriptBracket,JavaScriptParen,JavaScriptBlock
syntax cluster  javaScriptExpression contains=@jsAll,JavaScriptBracket,JavaScriptParen,JavaScriptBlock,@htmlPreproc

" Vim's default html.vim highlights all javascript as 'Special'
hi! def link javaScript              NONE

let b:current_syntax = "javascript"
if main_syntax == 'javascript'
  unlet main_syntax
endif
