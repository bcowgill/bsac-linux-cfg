#!/bin/bash
# operate on modified and added files from a git repo
# filenames with tricky characters will be a problem, -z format remedies that
echo Modified
git status --porcelain | perl -ne 's{\A \s M \s+}{}xms && print;'
echo Added
git status --porcelain | perl -ne 's{\A A \s+}{}xms && print;'
echo Renamed
git status --porcelain | perl -ne 's{\A R \s+ .+? \s+ -> \s+ }{}xms && print;'
echo Renamed and Modified
git status --porcelain | perl -ne 's{\A R M .+? \s+ -> \s+ }{}xms && print;'
echo Copied
git status --porcelain | perl -ne 's{\A C \s+ .+? \s+ -> \s+ }{}xms && print;'
echo Deleted
git status --porcelain | perl -ne 's{\A D \s+}{}xms && print;'

exit 0
   Short Format
       In the short-format, the status of each path is shown as

           XY PATH1 -> PATH2

       where PATH1 is the path in the HEAD, and the " -> PATH2" part is shown only when PATH1 corresponds to a different path in the index/worktree (i.e. the
       file is renamed). The XY is a two-letter status code.

       The fields (including the ->) are separated from each other by a single space. If a filename contains whitespace or other nonprintable characters, that
       field will be quoted in the manner of a C string literal: surrounded by ASCII double quote (34) characters, and with interior special characters
       backslash-escaped.

       For paths with merge conflicts, X and Y show the modification states of each side of the merge. For paths that do not have merge conflicts, X shows the
       status of the index, and Y shows the status of the work tree. For untracked paths, XY are ??. Other status codes can be interpreted as follows:

       ·   ' ' = unmodified

       ·   M = modified

       ·   A = added

       ·   D = deleted

       ·   R = renamed

       ·   C = copied

       ·   U = updated but unmerged

       Ignored files are not listed, unless --ignored option is in effect, in which case XY are !!.

           X          Y     Meaning
           -------------------------------------------------
                     [MD]   not updated
           M        [ MD]   updated in index
           A        [ MD]   added to index
           D         [ M]   deleted from index
           R        [ MD]   renamed in index
           C        [ MD]   copied in index
           [MARC]           index and work tree matches
           [ MARC]     M    work tree changed since index
           [ MARC]     D    deleted in work tree
           -------------------------------------------------
           D           D    unmerged, both deleted
           A           U    unmerged, added by us
           U           D    unmerged, deleted by them
           U           A    unmerged, added by them
           D           U    unmerged, deleted by us
           A           A    unmerged, both added
           U           U    unmerged, both modified
           -------------------------------------------------
           ?           ?    untracked
           !           !    ignored
           -------------------------------------------------

   Porcelain Format
       The porcelain format is similar to the short format, but is guaranteed not to change in a backwards-incompatible way between Git versions or based on user
       configuration. This makes it ideal for parsing by scripts. The description of the short format above also describes the porcelain format, with a few
       exceptions:

        1. The user’s color.status configuration is not respected; color will always be off.

        2. The user’s status.relativePaths configuration is not respected; paths shown will always be relative to the repository root.

       There is also an alternate -z format recommended for machine parsing. In that format, the status field is the same, but some other things change. First,
       the -> is omitted from rename entries and the field order is reversed (e.g from -> to becomes to from). Second, a NUL (ASCII 0) follows each filename,
       replacing space as a field separator and the terminating newline (but a space still separates the status field from the first filename). Third, filenames
       containing special characters are not specially formatted; no quoting or backslash-escaping is performed.

