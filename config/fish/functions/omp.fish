function omp --description 'Launch omp inside a fresh git worktree'
    # Subcommands that must never trigger worktree creation (only bare
    # launch / an explicit `launch` should). Kept in sync with `omp --help`.
    set -l subcmds acp auth-broker auth-gateway agents bench browser-relay \
        cleanse commit completions compress config dry-balance gc grep \
        gallery grievances install join models plugin ps say share setup \
        shell read ssh stats update usage tiny-models token ttsr worktree \
        wt search q

    set -l do_worktree 1
    if test (count $argv) -gt 0
        if not string match -q -- '-*' $argv[1]
            if contains -- $argv[1] $subcmds
                set do_worktree 0
            end
        end
    end

    if test $do_worktree -eq 1; and test -z "$OMP_NO_AUTO_WORKTREE"
        if git rev-parse --is-inside-work-tree >/dev/null 2>&1
            set -l git_dir (git rev-parse --absolute-git-dir)
            set -l common_dir (git rev-parse --path-format=absolute --git-common-dir)
            set -l superproject (git rev-parse --show-superproject-working-tree 2>/dev/null)

            # Only act from a normal checkout: skip if already inside a
            # linked worktree, and skip submodules (they also show
            # git_dir != common_dir but are not worktrees).
            if test "$git_dir" = "$common_dir"; and test -z "$superproject"
                set -l repo_root (git rev-parse --show-toplevel)
                set -l branch (git branch --show-current)
                if test -z "$branch"
                    set branch detached
                end
                set -l stamp (date +%Y%m%d-%H%M%S)-(random 1000 9999)
                set -l wt_branch "omp/$branch-$stamp"
                set -l wt_dir "$repo_root/.worktrees/$branch-$stamp"
                set -l exclude_file "$common_dir/info/exclude"

                # Keep generated worktrees out of the tracked tree without
                # touching the repo's committed .gitignore.
                if not grep -qx '.worktrees/' $exclude_file 2>/dev/null
                    echo '.worktrees/' >>$exclude_file
                end

                if git -C "$repo_root" worktree add "$wt_dir" -b "$wt_branch" >/dev/null 2>&1
                    # Record the branch this worktree forked from so
                    # omp-wt-clean can prove later that its work landed
                    # upstream before deleting anything.
                    git -C "$repo_root" config "branch.$wt_branch.ompbase" "$branch"
                    echo "omp: isolated worktree at $wt_dir (branch $wt_branch)" >&2
                    cd "$wt_dir"
                else
                    echo "omp: worktree creation failed, launching in $PWD instead" >&2
                end
            end
        end
    end

    command omp $argv
end
