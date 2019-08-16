@echo off
setlocal enabledelayedexpansion enableextensions

set TargetName=DeviceApp
set RootDir=%~dp0\..
FOR /F %%i IN ("%RootDir%\") DO set RootDir=%%~fi
FOR /F %%i IN ("%RootDir%\..\MinGCC\\") DO set MinGCCDir=%%~fi

set IntDir=%RootDir%\..\Bin\Temp\%TargetName%\
set OutDir=%RootDir%\..\Bin\%TargetName%\


FOR /F %%i IN ("%MinGCCDir%\bin\mipsel-elf32-gcc.exe") DO set GCC="%%~fi"
FOR /F %%i IN ("%MinGCCDir%\bin\mipsel-elf32-ld.exe") DO set LD="%%~fi"
FOR /F %%i IN ("%MinGCCDir%\bin\mipsel-elf32-ar.exe") DO set AR="%%~fi"
FOR /F %%i IN ("%MinGCCDir%\bin\mipsel-elf32-objcopy.exe") DO set OBJCOPY="%%~fi"
FOR /F %%i IN ("%MinGCCDir%\bin\mipsel-elf32-objdump.exe") DO set OBJDUMP="%%~fi"
FOR /F %%i IN ("%MinGCCDir%\bin\mipsel-elf32-size.exe") DO set SIZE="%%~fi"

set CFlags=-mips32 -EL -O3 -mhard-float -c  -Wa,-mdebug -fno-delayed-branch -fno-builtin -Wa,-O0 -Wa,--mc24r2  -DNDEBUG -g -gdwarf-2 -std=c99 -Wall -Wno-unknown-pragmas -Wextra -Werror -fno-strict-aliasing

IF EXIST "%IntDir%" (
	rem del /F /Q "%IntDir%\*.lst" >NUL
	del /F /Q "%IntDir%\*.o"  >NUL
	rd /S /Q "%IntDir%"  >NUL
	)
IF  EXIST "%OutDir%" (rd /S /Q "%OutDir%") >NUL

IF NOT EXIST "%OutDir%" (mkdir "%OutDir%")
IF NOT EXIST "%IntDir%" (mkdir "%IntDir%")
goto :Main


:CompileCCode
	set SrcFile=%~f1
	FOR /F %%j IN ("%IntDir%\%~n1.o") DO set OutFile=%%~fj
	rem echo OutFile=%OutFile%
	pushd "%MinGCCDir%\bin"
	rem echo SrcFile=%SrcFile%
	%GCC% %CFlags%  -o "!OutFile!" "!SrcFile!"
	if !ERRORLEVEL! NEQ 0 ( 
			set /A bError=1
			echo FAILED: "%~n1" Err=!ERRORLEVEL!
		)
	popd	
exit /b !bError!

:CompileAsmCode
	set SrcFile=%~f1
	FOR /F %%j IN ("%IntDir%\%~n1.o") DO set OutFile=%%~fj
	rem echo OutFile=%OutFile%
	pushd "%MinGCCDir%\bin"
	rem echo SrcFile=%SrcFile%
	%GCC% -mips32 -EL -O3 -mhard-float -c  -Wa,-mdebug  -o "!OutFile!" "!SrcFile!"
	if !ERRORLEVEL! NEQ 0 ( 
			set /A bError=1
			echo FAILED: "%~n1" Err=!ERRORLEVEL!
		)
	popd	
exit /b !bError!


:LinkProject
	set ObjList=
	FOR %%I in (%IntDir%\*.o) DO set ObjList=!ObjList! "%%~fI"
    FOR /F %%i IN ("%OutDir%\%TargetName%.o") DO set OutObject=%%~fi
	FOR /F %%i IN ("%OutDir%\%TargetName%.map") DO set OutMap=%%~fi
	FOR /F %%i IN ("%OutDir%\%TargetName%.sre") DO set OutSre=%%~fi
    FOR /F %%i IN ("%OutDir%\%TargetName%.dis") DO set OutDis=%%~fi
	
	echo ObjList=%ObjList%
	
	set LDFlags=-g -d -N  -T "%RootDir%\DeviceProject\LDScript.ld" !ObjList! "%RootDir%\..\Bin\DeviceLib\DeviceLib.a" -o "!OutObject!" -Map "!OutMap!"

    rem echo LinkExe:Linking %TargetName%: %LDFlags%
	%LD% %LDFlags%
	if !ERRORLEVEL! NEQ 0 ( 
			set /A bError=1
			echo Link error: "%~n1" Err=!ERRORLEVEL!
		) else (
			%OBJCOPY% -O srec "!OutObject!" "!OutSre!"
		)	
exit /b 0
rem GCC 
rem echo GCC=%GCC%

:Main
call :CompileAsmCode  %RootDir%\DeviceProject\DeviceStartup.s
call :CompileCCode %RootDir%\DeviceProject\DeviceCode.c
call :CompileCCode %RootDir%\CommonCode\CommFuncs.c
call :LinkProject