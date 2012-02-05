@echo off
rem
rem Copyright (c) 2011 The MyoMake Project <http://www.myomake.org>
rem
rem Licensed under the Apache License, Version 2.0 (the "License");
rem you may not use this file except in compliance with the License.
rem You may obtain a copy of the License at
rem
rem     http://www.apache.org/licenses/LICENSE-2.0
rem
rem Unless required by applicable law or agreed to in writing, software
rem distributed under the License is distributed on an "AS IS" BASIS,
rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
rem See the License for the specific language governing permissions and
rem limitations under the License.
rem
rem Batch script for cygspawn
rem
setlocal
if /i "%~1" == "/gui" (
    set "SUBSYTEM=WINDOWS"
    set "OUTFILE=cygspawnw.exe"
    shift
) else (
    set "SUBSYTEM=CONSOLE"
    set "OUTFILE=cygspawn.exe"
)
if /i "%~1" == "/x64" (
    set "MACHINE=X64"
    set "CFLAGS=/DWIN64 /W3 %CFLAGS%"
    set "RCOPTS=/d WIN64 /d _WIN64 %RCOPTS%"
) else (
    set "MACHINE=X86"
    set "CFLAGS=/W3 %CFLAGS%"
)
cl /nologo /TC /O2 /Ob2 /Zi /MD /DWIN32 %CFLAGS% /DUNICODE /D_UNICODE /D%SUBSYTEM% /c cygspawn.c /Fdcygspawn
rc /l 0x409 /d "NDEBUG" %RCOPTS% cygspawn.rc
link /NOLOGO /OPT:REF /INCREMENTAL:NO /SUBSYSTEM:%SUBSYTEM% /MACHINE:%MACHINE% %LDFLAGS% cygspawn.obj cygspawn.res kernel32.lib psapi.lib %EXTRA_LIBS% /pdb:cygspwn.pdb /OUT:%OUTFILE%
@if exist cygspwn.exe.manifest mt -nologo -manifest cygspwn.exe.manifest -outputresource:cygspwn.exe;1
