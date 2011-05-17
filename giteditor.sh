#!/bin/sh
#
# This is a modification of the excellent script HGEDITOR.SH that is
# distributed with the Mercurial version control system. I've simply
# modified it to work with Git.
#

# If you want to pass your favourite editor some other parameters
# only for Git, modify this:

GIT=`which git`

case "${EDITOR}" in
    "")
        EDITOR="vi"
        ;;
    emacs)
        EDITOR="$EDITOR -nw"
        ;;
    gvim|vim)
        EDITOR="$EDITOR -f -o"
        ;;
esac


GITTMP=""

cleanup_exit() {
    rm -rf "$GITTMP"
}

# Remove temporary files even if we get interrupted
trap "cleanup_exit" 0 # normal exit
trap "exit 255" HUP INT QUIT ABRT TERM

GITTMP=$(mktemp -d ${TMPDIR-/tmp}/giteditor.XXXXXX)

[ $GITTMP != x -a -d $GITTMP ] || {
  echo "Could not create temporary directory! Exiting." 1>&2
  exit 1
}

(
    "$GIT" diffall >> "$GITTMP/diff"
)

cat "$1" > "$GITTMP/msg"

MD5=$(which md5sum 2>/dev/null) || MD5=$(which md5 2>/dev/null)

[ -x "${MD5}" ] && CHECKSUM=`${MD5} "$GITTMP/msg"`
if [ -s "$GITTMP/diff" ]; then
    $EDITOR "+e $GITTMP/diff" '+set buftype=help filetype=diff' "+vsplit $GITTMP/msg" '+set filetype=gitcommit tw=78' || exit $?
else
    $EDITOR -c "r $TEMPLATE" "$GITTMP/msg" || exit $?
fi

[ -x "${MD5}" ] && (echo "$CHECKSUM" | ${MD5} -c >/dev/null 2>&1 && exit 13)

mv "$GITTMP/msg" "$1"

exit $?
