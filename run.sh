#!/bin/sh
(
self=$$
set -e; false && exit 42 || printf "this is %s (%s)\n" "$0" "$self"

# portability can barely count up to three
LC_ALL=C
export LC_ALL

# lets see how much of the weed goes up into smoke early
hash mktemp make git sed tar wget


    # stage 1 # :: create a temporary space in time ::

    TMPDIR="$(mktemp --tmpdir -d test.XXXXXXXXX)"
    export TMPDIR # yes, we mean it
    printf 'test run %s\n' "$TMPDIR"

    trap 'set +e; make clean; rm -rf -- "$TMPDIR"; printf "done with trap of: %s\n" "$TMPDIR"; trap - EXIT; exit
    ' EXIT INT HUP TERM
    do_the_pipe_fail="kill $self"

    HOME="$(mktemp --tmpdir -d home.XXX)"
    mkdir -p -- "$HOME/.local/bin"
    PATH="$HOME/.local/bin:$PATH"


    # stage 2 # :: populate with files ::

    ( ( ( ( (

      # multiple population strategies:
      #
      #  copy files to transpose early modifications into test
      #   copy HEAD tree to commit test
      #    get remote master archive to test
      #

        git ls-files -z --cached | sed -z '/\.git/d;/^run\.sh/d' | tar c -z --transform='s/^/tar-pipe-'"$(git describe --tags --always --first-parent --dirty=-dirty)"'\//' --null -T - \
         || git archive --worktree-attributes --format tar.gz --prefix "$(git describe --tags --always --first-parent)"/ HEAD \
          || wget -nv -O - https://github.com/ktomk/mkdocs-test/archive/refs/heads/master.tar.gz \
           || $do_the_pipe_fail

    ) ) ) ) ) \
               \
                \
                | \
                ( tar x -zv -C "$TMPDIR" --strip-components=1 || $do_the_pipe_fail ) \
                          | sed 's/^/ \\~> /; s/\//  \/  /g; s/ \/ $/\//'
                          :
                   cd "$TMPDIR"


printf "
                            ||
                            ^^
                      ~~< * °° * >~~
                      ready to rumble
                      ~~< _ .. _ >~~
                           '||'
                        ,°°    °°.
       °  ° °° °°°° °° °          ° °° °°°° °° °  °

"
(

                          ( (
                           (:)

                         set -x

                           (:)


  make test-a-setup ;:;:; ./test.bash


                           (:)

                      (make  clean)

                           (:)


                            make test-b-setup ;:;:; ./test.bash


                           (:)
                            ) )

)
printf "
                       '''''||'''''
                          ''^^''
                           °  °
                      ~~< _ ** _ >~~
                   let the test be done.
               - - -- ~~< * °° * >~~ -- - -

"

       # ~~ you made a small runner ever happy ~~ #

          printf '\n\n%s <- done! \n' "$TMPDIR"
)
