@echo off
setlocal EnableDelayedExpansion

set UE_CMD="C:\Program Files\Epic Games\UE_5.5_OCULUS\Engine\Binaries\Win64\UnrealEditor-Cmd.exe"
set PROJECT="C:\Users\Simeo\Perforce\Simeon_Laptop\playground\PoncaVRPlayground\PoncaVRPlayground.uproject"
set PSO_DIR=C:\PSOfiles\PoncaVRPlayground
set COOKED_CACHES=C:\Users\Simeo\Perforce\Simeon_Laptop\playground\PoncaVRPlayground\Saved\Cooked\Android_ASTC\PoncaVRPlayground\Metadata\PipelineCaches
set SPC_OUT=C:\Users\Simeo\Perforce\Simeon_Laptop\playground\PoncaVRPlayground\Build\Android\PipelineCaches\PoncaVRPlayground_SF_VULKAN_ES31_ANDROID.spc
set BUILD_OUT=C:\Users\Simeo\Perforce\Simeon_Laptop\playground\PoncaVRPlayground\Builds\Android_ASTC
set INSTALL_BAT=%BUILD_OUT%\Install_PoncaVRPlayground-arm64.bat
set UAT="C:\Program Files\Epic Games\UE_5.5_OCULUS\Engine\Build\BatchFiles\RunUAT.bat"

echo ============================================================
echo  STEP 1: Pull .rec.upipelinecache from device
echo ============================================================
if not exist "%PSO_DIR%" mkdir "%PSO_DIR%"
adb pull /sdcard/Android/data/com.YourCompany.PoncaVRPlayground/files/UnrealGame/PoncaVRPlayground/PoncaVRPlayground/Saved/CollectedPSOs/ %PSO_DIR%\
if errorlevel 1 (
    echo WARNING: adb pull failed or no files found. Continuing anyway...
)

echo.
echo ============================================================
echo  STEP 2: Copy .shk files from cooked metadata
echo ============================================================
xcopy /Y "%COOKED_CACHES%\*.shk" "%PSO_DIR%\"
if errorlevel 1 (
    echo ERROR: Failed to copy .shk files. Make sure you have a cooked build.
    pause
    exit /b 1
)

echo.
echo ============================================================
echo  STEP 3: Expand .rec.upipelinecache + .shk into .spc
echo ============================================================

set REC_FILE=
for /r "%PSO_DIR%" %%f in (*.rec.upipelinecache) do (
    if not defined REC_FILE set REC_FILE=%%f
)

if not defined REC_FILE (
    echo ERROR: No .rec.upipelinecache files found under %PSO_DIR%
    echo Make sure the device pull succeeded.
    pause
    exit /b 1
)

echo Found: %REC_FILE%

for %%f in ("%REC_FILE%") do set REC_DIR=%%~dpf

%UE_CMD% %PROJECT% -run=ShaderPipelineCacheTools expand "%REC_DIR%*.rec.upipelinecache" "%PSO_DIR%\*.shk" "%SPC_OUT%"
if errorlevel 1 (
    echo ERROR: ShaderPipelineCacheTools expand failed.
    pause
    exit /b 1
)
echo SPC written to: %SPC_OUT%

echo.
echo ============================================================
echo  STEP 4: Repackage (build only, no cook)
echo ============================================================
if not exist "%BUILD_OUT%" mkdir "%BUILD_OUT%"

%UAT% BuildCookRun ^
    -project=%PROJECT% ^
    -noP4 ^
    -platform=Android ^
    -cookflavor=ASTC ^
    -clientconfig=Development ^
    -build ^
    -skipcook ^
    -stage ^
    -package ^
    -archive ^
    -archivedirectory="%BUILD_OUT%" ^
    -nocompile ^
    -nocompileeditor ^
    -installed ^
    -unrealexe=%UE_CMD%

if errorlevel 1 (
    echo ERROR: Package step failed.
    pause
    exit /b 1
)

echo.
echo ============================================================
echo  STEP 5: Install APK to device
echo ============================================================
if not exist "%INSTALL_BAT%" (
    echo ERROR: Install bat not found at %INSTALL_BAT%
    echo Check the Builds\Android_ASTC folder for the correct install bat name.
    pause
    exit /b 1
)

call "%INSTALL_BAT%"
if errorlevel 1 (
    echo ERROR: Install failed.
    pause
    exit /b 1
)

echo.
echo ============================================================
echo  DONE - APK installed to device
echo ============================================================
pause