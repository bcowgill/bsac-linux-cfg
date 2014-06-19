#!/bin/bash
# merge a branch and invoke merge tool if there were conflicts
branch="$1"
if [ -z $branch ]; then
   git branch
   echo Specify a branch name or something to merge
   echo remember git merge --abort to give up!
else
   git merge "$branch" || git mergetool
fi

## Applying: ENG-2332: controls for new bidder features : campaign_details.tt just tidying up some whitespace first
## Using index info to reconstruct a base tree...
## M       views/campaign_details.tt
## <stdin>:23: space before tab in indent.
##         <br/>
## <stdin>:188: space before tab in indent.
##                                 <td width="50">
## warning: 2 lines add whitespace errors.
## Falling back to patching base and 3-way merge...
## Auto-merging views/campaign_details.tt
## CONFLICT (content): Merge conflict in views/campaign_details.tt
## Failed to merge in the changes.
## Patch failed at 0011 ENG-2332: controls for new bidder features : campaign_details.tt just tidying up some whitespace first
## The copy of the patch that failed is found in:
##    /home/brent/workspace/projects/infinity-plus-dashboard/.git/rebase-apply/patch
## 
## When you have resolved this problem, run "git rebase --continue".
## If you prefer to skip this patch, run "git rebase --skip" instead.
## To check out the original branch and stop rebasing, run "git rebase --abort".
## 
## Merging:
## views/campaign_details.tt
## 
## Normal merge conflict for 'views/campaign_details.tt':
##   {local}: modified file
##   {remote}: modified file
## Hit return to start merge resolution tool (diffmerge): 

## brent@slug:~/workspace/projects/infinity-plus-dashboard (ENG-2506 $%|REBASE 11/97)$ git rebase --continue

## Applying: ENG-2332: controls for new bidder features : campaign_details.tt just tidying up some whitespace first
## No changes - did you forget to use 'git add'?
## If there is nothing left to stage, chances are that something else
## already introduced the same changes; you might want to skip this patch.
## 
## When you have resolved this problem, run "git rebase --continue".
## If you prefer to skip this patch, run "git rebase --skip" instead.
## To check out the original branch and stop rebasing, run "git rebase --abort".
## 

## brent@slug:~/workspace/projects/infinity-plus-dashboard (ENG-2506 $%|REBASE 11/97)$ git rebase --skip || git mergetool

