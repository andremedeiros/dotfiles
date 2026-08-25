function omp-wt-clean --description 'Remove worktrees/branches created by the omp launch wrapper, skipping any with uncommitted or unmerged work'
    set -l force 0
    if contains -- --force $argv
        set force 1
    end

    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "omp-wt-clean: not inside a git repo" >&2
        return 1
    end

    set -l repo_root (git rev-parse --show-toplevel)
    set -l removed 0
    set -l skipped 0

    set -l entries (git -C "$repo_root" worktree list --porcelain | awk -v prefix="$repo_root/.worktrees/" '
        /^worktree / { path = $2 }
        /^branch / { branch = $2 }
        /^$/ { if (index(path, prefix) == 1) print path "\t" branch; path = ""; branch = "" }
        END { if (index(path, prefix) == 1) print path "\t" branch }
    ')

    for entry in $entries
        set -l parts (string split \t -- $entry)
        set -l wt_path $parts[1]
        set -l wt_branch (string replace 'refs/heads/' '' -- $parts[2])

        if not test -d "$wt_path"
            # Registered but already gone from disk: nothing left to lose.
            git -C "$repo_root" worktree remove --force "$wt_path" 2>/dev/null
            set removed (math $removed + 1)
            continue
        end

        # Uncommitted or untracked work sitting only in this worktree.
        set -l dirty (git -C "$wt_path" status --porcelain -uall 2>/dev/null)

        # The branch this worktree forked from, recorded by `omp` at
        # creation time. Fall back to the repo's default branch when the
        # worktree predates that bookkeeping.
        set -l base (git -C "$repo_root" config --get "branch.$wt_branch.ompbase" 2>/dev/null)
        if test -z "$base"
            set base (git -C "$repo_root" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | string replace 'origin/' '')
        end

        # Work that only exists on this branch, not yet on its base -
        # i.e. not on the original/main checkout.
        set -l unmerged 0
        if test -n "$base"; and git -C "$repo_root" rev-parse --verify "$base" >/dev/null 2>&1
            if not git -C "$repo_root" merge-base --is-ancestor "$wt_branch" "$base" 2>/dev/null
                set unmerged 1
            end
        else
            # No provable base to diff against - can't show it's safe.
            set unmerged 1
        end

        if test (count $dirty) -gt 0; or test $unmerged -eq 1
            if test $force -eq 0
                echo "omp-wt-clean: SKIPPING $wt_path (branch $wt_branch) - work not on $base:" >&2
                if test (count $dirty) -gt 0
                    echo "  uncommitted/untracked changes:" >&2
                    for line in $dirty
                        echo "    $line" >&2
                    end
                end
                if test $unmerged -eq 1
                    if test -n "$base"
                        echo "  commits not on $base:" >&2
                        for line in (git -C "$repo_root" log --oneline "$base..$wt_branch" 2>/dev/null)
                            echo "    $line" >&2
                        end
                    else
                        echo "  no recorded base branch to verify against" >&2
                    end
                end
                set skipped (math $skipped + 1)
                continue
            else
                echo "omp-wt-clean: --force removing $wt_path (branch $wt_branch) despite unmerged/uncommitted work" >&2
            end
        end

        git -C "$repo_root" worktree remove --force "$wt_path" 2>/dev/null
        if string match -q 'omp/*' $wt_branch
            git -C "$repo_root" branch -D $wt_branch 2>/dev/null
        end
        set removed (math $removed + 1)
    end

    git -C "$repo_root" worktree prune
    echo "omp-wt-clean: removed $removed, skipped $skipped worktree(s) under $repo_root/.worktrees"
    if test $skipped -gt 0
        echo "omp-wt-clean: re-run with --force to remove skipped worktrees anyway (irreversible)" >&2
    end
end
