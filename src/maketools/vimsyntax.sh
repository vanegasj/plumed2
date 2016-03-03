#! /bin/bash

actions=$(
eval "$1" manual --action 2>&1 | 
awk '{
  if(NR==1) next;
  if(NF!=1) exit;
  print $1
}' | awk '{
  if($1=="DISTANCE"){
    print $1 ",option:ATOMS,flag:COMPONENTS,flag:SCALED_COMPONENTS,flag:NUMERICAL_DERIVATIVES,flag:NOPBC"
  } else if($1=="MOVINGRESTRAINT"){
    print $1 ",option:ARG,option:VERSE,numbered:STEP,numbered:AT,numbered:KAPPA,flag:NUMERICAL_DERIVATIVES"
  } else print
}'
)

cat << \EOF
" Vim syntax file
" Language: PLUMED

if exists("b:current_syntax")
  finish
endif

set iskeyword=33-126

syntax match   plumedLabel "\v<LABEL\=\S*" contained
highlight link plumedLabel Type

EOF
for a in $actions ; do
action_name="${a%%,*}" 
action_name_=$(echo $action_name | sed s/-/_/g)

string=
for l in $(echo "$a" | sed 's/,/ /g')
do
  case "$l" in
  (flag:*)
# syntax match   plumedKeywordsDISTANCE "\v<COMPONENTS>" contained
    string='"\v<'${l#flag:}'>"' ;;
  (option:*)
# syntax match   plumedKeywordsDISTANCE "\v<ATOMS\=[^{ ]*" contained
    string='"\v<'${l#option:}'\=[^{ ]*"' ;;
  (numbered:*)
# syntax match   plumedKeywordsMOVINGRESTRAINT "\v<KAPPA[0-9]+\=[^{ ]*" contained
    string='"\v<'${l#numbered:}'[0-9]+\=[^{ ]*"' ;;
  esac
  test -n "$string" && echo "syntax match   plumedKeywords$action_name_ $string contained"
done

cat << \EOF | sed s/ACTION/$action_name/g | sed s/ACTNAME/$action_name_/g
syntax region plumedLineACTNAME matchgroup=plumedActionACTNAME start=/\v^\s*ACTION>/ excludenl end=/$/ contains=plumedComment,plumedKeywordsACTNAME,plumedLabel,plumedString
syntax region plumedLineACTNAME matchgroup=plumedActionACTNAME start=/\v^\s*ACTION\s+\.\.\.\s*((#.*)*$)@=/ end=/\v^\s*\.\.\.(\s+ACTION)?\s*((#.*)*$)@=/ contains=plumedComment,plumedKeywordsACTNAME,plumedLabel,plumedString
syntax region plumedLineACTNAME matchgroup=plumedActionACTNAME start=/\v^\s*\S+:\s+ACTION/ excludenl end=/$/ contains=plumedComment,plumedKeywordsACTNAME,plumedString
syntax region plumedLineACTNAME matchgroup=plumedActionACTNAME start=/\v^\s*\z(\S+\:)\s+ACTION\s+\.\.\.\s*((#.*)*$)@=/ end=/\v^\s*\.\.\.(\s+\z1)?\s*((#.*)*$)@=/ contains=plumedComment,plumedKeywordsACTNAME,plumedString
syntax region plumedLineACTNAME matchgroup=plumedActionACTNAME start=/\v^\s*\z(\S+\:)\s+\.\.\.\_s+ACTION>/ end=/\v^\s*\.\.\.(\s+\z1)?\s*((#.*)*$)@=/ contains=plumedComment,plumedKeywordsACTNAME,plumedString
highlight link plumedActionACTNAME Type
highlight link plumedKeywordsACTNAME Statement
EOF

done
cat << \EOF
" comments and strings last, with highest priority
syntax region  plumedString start=/\v\{/  end=/\v\}/
syntax region  plumedString start=/\v\(/  end=/\v\)/
highlight link plumedString String
syntax region  plumedComment start="\v^\S*ENDPLUMED" end="\%$"
syntax match   plumedComment excludenl "\v#.*$"
syntax match   plumedComment "\vAA(C.*$)@="
highlight link plumedComment Comment
EOF

# colors:
# Constant
# Identifier
# Statement
# PreProc
# Type
# Special
# Underlined
# Ignore
# Error
# Todo



