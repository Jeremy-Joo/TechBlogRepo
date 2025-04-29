@echo off
chcp 65001
setlocal enabledelayedexpansion

:: === 사용자 설정 ===
set TARGET_REPO=https://github.com/Jeremy-Joo/TechBlog.git
set TARGET_BRANCH=main
set BUILD_DIR=public
set BASE_URL=https://jeremy-joo.github.io/TechBlog/

:: === 1. 상태 출력 ===
echo ==========================================
echo Hugo 블로그 자동 배포를 시작합니다.
echo 기존 파일과 비교 후 삭제될 파일을 미리 보여줍니다.
echo ==========================================
echo.

:: === 2. public 폴더 정리 ===
echo ▶ public 폴더 삭제 중...
if exist "%BUILD_DIR%" (
    rmdir /s /q "%BUILD_DIR%"
)
echo.

:: === 3. 로컬 public 빌드 ===
echo ▶ Hugo 사이트 빌드 중...
hugo --baseURL=%BASE_URL%

IF NOT EXIST "%BUILD_DIR%" (
    echo ❌ 빌드 실패: %BUILD_DIR% 폴더가 없습니다.
    exit /b 1
)

:: === 4. 현재 서버 내용 가져오기 ===
echo ▶ GitHub 저장소에서 현재 내용을 임시폴더에 복제 중...
set TEMP_DIR=__temp_repo__
if exist "%TEMP_DIR%" (
    rmdir /s /q "%TEMP_DIR%"
)
git clone --depth=1 %TARGET_REPO% %TEMP_DIR%

:: === 5. 삭제될 파일 비교 ===
echo.
echo ▶ 삭제될 파일 목록:
for /r "%TEMP_DIR%" %%f in (*) do (
    set FILE=%%~pf%%~nxf
    set FILE=!FILE:%TEMP_DIR%=!
    if not exist "%BUILD_DIR%!FILE!" (
        echo - !FILE!
    )
)

echo.
echo ==========================================
set /p confirm="계속 진행할까요? (y/n): "
if /i "%confirm%" NEQ "y" (
    echo ❌ 중단되었습니다.
    rmdir /s /q "%TEMP_DIR%"
    exit /b
)

:: === 6. public 폴더로 이동해서 배포 ===
cd "%BUILD_DIR%"

echo ▶ Git 초기화 및 GitHub 배포 준비 중...
git init
git remote add origin %TARGET_REPO%
git add .
git commit -m "🚀 Hugo 자동 배포 (삭제 검사 포함) - %DATE% %TIME%"
git branch -M %TARGET_BRANCH%
git push -f origin %TARGET_BRANCH%

:: === 7. 마무리 정리 ===
cd ..
rmdir /s /q "%TEMP_DIR%"
echo.
echo ✅ 배포 완료! 삭제된 파일은 위 목록 참고.
echo 🌐 접속 주소: %BASE_URL%
pause
