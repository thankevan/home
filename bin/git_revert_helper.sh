#!/bin/bash

#
# ---------
# not added
# ---------
#
# git stash
# reverts modifications on all previously commited files
# leaves new file
#
# git checkout -- <file> <file> <dir> <dir>
# reverts modifications on all specified files and directories
# does not work if non-commited files are specifically named
#
# git reset --hard
# same as git stash but doesn't leave you a way to pop back
#
#
# ------------------
# added/staged files
# ------------------
#
# git reset
# unadds all the files but they still exist with their modifications
#
# git stash
# stashes all the modifications and new files away in the stash cache, new files disappear
# be aware that git stash pop stages the new files but unstages the modified files
#
# git reset --hard
# same as git stash but doesn't leave you a way to pop back
#
# git reset HEAD <file> <file> <dir> <dir>
# unadds all files and directories listed, they all still exist with their modifications
#
# git reset HEAD
# unadds all files and directories, the all still exist with their modifications
#
#
# --------------------------
# commited files, not pushed
# --------------------------
#
# git revert <branch>
# undoes all changes associated with the branch, lose changes
#
# with branch1 and then branch1->branch2
# git checkout branch1 <file> <file> <dir> <dir>
# gets the files and directories as they were in branch1 as modification to branch2
# above modifications are already staged
#
# git rebase -i branch1
# allow removing, changing order, etc. of commits. necessarily rewrites history
#
#
#
#


#function added_files {
#  read -p 'Discard all changes? (y/n): ' RESPONSE
#
#  if [ "$RESPONSE" = "y" ]; then
#    echo "git reset --hard"
#  elif [ "$RESPONSE" = "n" ]; then
#    read -p 'Unstage all files? (y/n): ' RESPONSE
#
#    if [ "$RESPONSE" = "y" ]; then
#      echo "git reset"
#    elif [ "$RESPONSE" = "n" ]; then
#      echo "git reset HEAD <file>"
#    fi
#  fi
#}
#
#function unadded_files {
#  read -p 'Keep files for later? (y/n): ' RESPONSE
#
#  if [ "$RESPONSE" = "y" ]; then
#    echo "git stash"
#  elif [ "$RESPONSE" = "n" ]; then
#    read -p 'Discard all local changes? (y/n): ' RESPONSE
#
#    if [ "$RESPONSE" = "y" ]; then
#      echo "git reset --hard"
#    elif [ "$RESPONSE" = "n" ]; then
#      echo "git checkout -- <file> <file> <file>"
#    fi
#  fi
#}
#
#function commited {
#  read -p 'Keep history intact? (y/n): ' RESPONSE
#
#  if [ "$RESPONSE" = "y" ]; then
#    echo "Undo entire commit: "
#    echo "git revert commit-undo-id"
#    echo ""
#    echo "Undo changes on a file/dir but keep them staged:"
#    echo "git checkout commit-undo-id <file> <file>"
#    echo ""
#    echo "Undo changes on a file/dir but make them unstaged:"
#    echo "git reset commit-undo-id <file> <file>"
#  elif [ "$RESPONSE" = "n" ]; then
#    echo "Some combination of checkout out previous branches and rebranching or..."
#    echo "git rebase ..."
#    echo ""
#    echo "If branches A->B->C->D you can pick and choose what and when for all with:"
#    echo "git rebase -i A"
#    echo ""
#    echo "also..."
#    echo "git rebase -i A-id..C-id"
#    echo "Redo the undo, get the ids... git reflog show"
#  fi
#}
#
#function main {
#  read -p 'Leaked sensitive info? (y/n): ' RESPONSE
#
#  if [ "$RESPONSE" = "y" ]; then
#    echo "This might get you there, also there's https://rtyley.github.io/bfg-repo-cleaner/:"
#    echo "git filter-branch --tree-filter 'rm <filename>' HEAD"
#  elif [ "$RESPONSE" = "n" ]; then
#    read -p 'File already pushed? (y/n): ' RESPONSE
#
#    if [ "$RESPONSE" = "y" ]; then
#      echo "Please figure it out and update this file."
#    elif [ "$RESPONSE" = "n" ]; then
#      read -p 'File already committed? (y/n): ' RESPONSE
#
#      if [ "$RESPONSE" = "y" ]; then
#        commited
#      elif [ "$RESPONSE" = "n" ]; then
#        read -p 'Is the file already added? (y/n): ' RESPONSE
#
#        if [ "$RESPONSE" = "y" ]; then
#          added_files
#        elif [ "$RESPONSE" = "n" ]; then
#          unadded_files
#        fi
#      fi
#    fi
#  fi
#}

