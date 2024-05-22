#!/bin/bash


# from : https://docs.npmjs.com/cli/v6/commands
_npm_secondary_commands()
{
  # replaced run-script with run (its alias)
  echo "access adduser audit bin bugs build bundle cache ci completion config dedupe deprecate dist-tag docs doctor edit explore fund help help-search hook init install install-ci-test install-test link logout ls org outdated owner pack ping prefix profile prune publish rebuild repo restart root run search shrinkwrap star stars start stop team test token uninstall unpublish update version view whoami"
}

_npm_get_scripts()
{
  if ! [ -e "$(pwd)/package.json" ]; then
    echo ""
    return
  fi

  # the -r signifies raw output written to standard output rather than a formatted JSON string with quotes
  echo "$(jq -r '.scripts|keys|join(" ")' package.json)"
}

_npm_scripts_completion()
{
  local cur
  _get_comp_words_by_ref -n : cur
  COMPREPLY=( $(compgen -W "$(_npm_get_scripts)" -- "$cur") )
  __ltrim_colon_completions "$cur"
}

_npm_multilevel_completion()
{
  local cur prev

  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  if [ "$COMP_CWORD" = "1" ]; then
    COMPREPLY=( $(compgen -W "$(_npm_secondary_commands)" -- "$cur") )
    return 0
  elif [ "$COMP_CWORD" = "2" ]; then
    case "$prev" in
      "run")
        _npm_scripts_completion
        ;;

      *)
        ;;
    esac
  fi
}

complete -F _npm_scripts_completion npm_run nr npmr
complete -F _npm_multilevel_completion npm

npm_run()
{
  npm run "$@"
}

alias nr=npm_run
alias npmr=npm_run


# the functions appear to be getting deprecated so backing them up here
# see: https://github.com/scop/bash-completion/blob/75309e9f254ee4e5e31e85e18c782e64707a6d22/bash_completion#L374
_my_get_comp_words_by_ref ()
{
    local exclude flag i OPTIND=1;
    local cur cword words=();
    local upargs=() upvars=() vcur vcword vprev vwords;
    while getopts "c:i:n:p:w:" flag "$@"; do
        case $flag in
            c)
                vcur=$OPTARG
            ;;
            i)
                vcword=$OPTARG
            ;;
            n)
                exclude=$OPTARG
            ;;
            p)
                vprev=$OPTARG
            ;;
            w)
                vwords=$OPTARG
            ;;
        esac;
    done;
    while [[ $# -ge $OPTIND ]]; do
        case ${!OPTIND} in
            cur)
                vcur=cur
            ;;
            prev)
                vprev=prev
            ;;
            cword)
                vcword=cword
            ;;
            words)
                vwords=words
            ;;
            *)
                echo "bash: $FUNCNAME(): \`${!OPTIND}': unknown argument" 1>&2;
                return 1
            ;;
        esac;
        let "OPTIND += 1";
    done;
    __get_cword_at_cursor_by_ref "$exclude" words cword cur;
    [[ -n $vcur ]] && {
        upvars+=("$vcur");
        upargs+=(-v $vcur "$cur")
    };
    [[ -n $vcword ]] && {
        upvars+=("$vcword");
        upargs+=(-v $vcword "$cword")
    };
    [[ -n $vprev ]] && {
        upvars+=("$vprev");
        upargs+=(-v $vprev "${words[cword - 1]}")
    };
    [[ -n $vwords ]] && {
        upvars+=("$vwords");
        upargs+=(-a${#words[@]} $vwords "${words[@]}")
    };
    (( ${#upvars[@]} )) && local "${upvars[@]}" && _upvars "${upargs[@]}"
}

_my__get_cword_at_cursor_by_ref ()
{
    local cword words=();
    __reassemble_comp_words_by_ref "$1" words cword;
    local i cur2;
    local cur="$COMP_LINE";
    local index="$COMP_POINT";
    for ((i = 0; i <= cword; ++i ))
    do
        while [[ "${#cur}" -ge ${#words[i]} && "${cur:0:${#words[i]}}" != "${words[i]}" ]]; do
            cur="${cur:1}";
            ((index--));
        done;
        if [[ "$i" -lt "$cword" ]]; then
            local old_size="${#cur}";
            cur="${cur#${words[i]}}";
            local new_size="${#cur}";
            index=$(( index - old_size + new_size ));
        fi;
    done;
    if [[ "${words[cword]:0:${#cur}}" != "$cur" ]]; then
        cur2=${words[cword]};
    else
        cur2=${cur:0:$index};
    fi;
    local "$2" "$3" "$4" && _upvars -a${#words[@]} $2 "${words[@]}" -v $3 "$cword" -v $4 "$cur2"
}

_my__reassemble_comp_words_by_ref ()
{
    local exclude i j ref;
    if [[ -n $1 ]]; then
        exclude="${1//[^$COMP_WORDBREAKS]}";
    fi;
    eval $3=$COMP_CWORD;
    if [[ -n $exclude ]]; then
        for ((i=0, j=0; i < ${#COMP_WORDS[@]}; i++, j++))
        do
            while [[ $i -gt 0 && -n ${COMP_WORDS[$i]} && ${COMP_WORDS[$i]//[^$exclude]} == ${COMP_WORDS[$i]} ]]; do
                [ $j -ge 2 ] && ((j--));
                ref="$2[$j]";
                eval $2[$j]=\${!ref}\${COMP_WORDS[i]};
                [ $i = $COMP_CWORD ] && eval $3=$j;
                (( $i < ${#COMP_WORDS[@]} - 1)) && ((i++)) || break 2;
            done;
            ref="$2[$j]";
            eval $2[$j]=\${!ref}\${COMP_WORDS[i]};
            [[ $i == $COMP_CWORD ]] && eval $3=$j;
        done;
    else
        eval $2=\( \"\${COMP_WORDS[@]}\" \);
    fi
}

_my_upvars ()
{
    if ! (( $# )); then
        echo "${FUNCNAME[0]}: usage: ${FUNCNAME[0]} [-v varname" "value] | [-aN varname [value ...]] ..." 1>&2;
        return 2;
    fi;
    while (( $# )); do
        case $1 in
            -a*)
                [[ -n ${1#-a} ]] || {
                    echo "bash: ${FUNCNAME[0]}: \`$1': missing" "number specifier" 1>&2;
                    return 1
                };
                printf %d "${1#-a}" >&/dev/null || {
                    echo "bash:" "${FUNCNAME[0]}: \`$1': invalid number specifier" 1>&2;
                    return 1
                };
                [[ -n "$2" ]] && unset -v "$2" && eval $2=\(\"\${@:3:${1#-a}}\"\) && shift $((${1#-a} + 2)) || {
                    echo "bash: ${FUNCNAME[0]}:" "\`$1${2+ }$2': missing argument(s)" 1>&2;
                    return 1
                }
            ;;
            -v)
                [[ -n "$2" ]] && unset -v "$2" && eval $2=\"\$3\" && shift 3 || {
                    echo "bash: ${FUNCNAME[0]}: $1: missing" "argument(s)" 1>&2;
                    return 1
                }
            ;;
            *)
                echo "bash: ${FUNCNAME[0]}: $1: invalid option" 1>&2;
                return 1
            ;;
        esac;
    done
}


# this function updates COMPREPLY
# it removes the input word from the start of the entries in COMPREPLY
# it only removes upto the last colon in the input word
# used after COMPREPLY=(...compgen...) which does the filtering
# used with _get_comp_words_by_ref exclude characters (:) from word breaks
# example:
#   if COMPREPLY=(foo foo:bar foo:baz foo:bar:baz foo:gru foo:bar:gru:)
#   input foo will do nothing (no colon in the input word)
#   input foo: will result in COMPREPLY=(foo bar baz bar:baz gru bar:gru:) -- after filtering should be: (bar baz bar:baz gru bar:gru:)
#   input foo:b will result in COMPREPLY=(foo bar baz bar:baz gru bar:gru:) -- after filtering should be: (bar baz bar:baz bar:gru:)
#   input foo:bar will result in COMPREPLY=(foo bar baz bar:baz gru bar:gru:) -- after filtering should be: (bar bar:baz bar:gru:)
#   input foo:bar: will result in COMPREPLY=(foo foo:bar foo:baz baz foo:gru gru:) -- after filtering should be: (baz gru:)
#   input foo:g will result in COMPREPLY=(foo bar baz bar:baz gru bar:gru:) -- after filtering should be: (gru)
_my__ltrim_colon_completions() {
  if [[ "$1" == *:* && ( ${BASH_VERSINFO[0]} -lt 4 || ( ${BASH_VERSINFO[0]} -ge 4 && "$COMP_WORDBREAKS" == *:* ) ) ]]; then
    local colon_word=${1%${1##*:}};
    local i=${#COMPREPLY[*]};
    while [ $((--i)) -ge 0 ]; do
      COMPREPLY[$i]=${COMPREPLY[$i]#"$colon_word"};
    done;
  fi
}

