Cygwin spawn helper (Cygspawn)
==============================

Cygwin uses posix paths and environments which makes most of
the standard windows programs to fail because of path mismatch.
The traditional way of handling that is using Cygwin cygpath
utility which translates Cygwin (posix) paths to their windows
equivalents from shell.

For example a standard usage would be:

    program.exe "--f1=`cygpath -w /tmp/f1`" "`cygpath -w /tmp/f1`" ...

This can become very complex and it requires that the shell
script is aware it runs inside the Cygwin environment.

Cygspawn utility does that automatically by replacing each posix
argument that contains path element with its windows equivalent.
It also replaces paths in the environment variable values making
sure the multiple path elements are correctly separated using
windows path separator `;`.

Using cygspawn the upper example would become:

    cygspawn program.exe -w /tmp/f1 -w /tmp/f1 ...

Before starting `program.exe` cygspawn converts all command line
and environment variables to windows format.

Cygspawn also understands Microsoft Visual Studio tools specific
command lines which allows to be used from GNU make or similar
toolkit without the need to change all posix path variables.

    CC = cygspawn cl
    INCLUDES = -I`pwd`/includes
    ...
    $(CC) $(INCLUDES) /Fo/tmp/myprogram ...

In the upper example both the `-I...` and `/Fo/tmp/myprogram`
are converted as paths because those cl.exe options do not need
space between the option name and option value. The cl.exe will
receive `/FoC:\cygwin\tmp\myprogram` instead provided posix flavor.

