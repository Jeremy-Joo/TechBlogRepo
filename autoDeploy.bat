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
echo ==========================================

:: === 2. 현재 저장소 변경사항 체크 ===
git status
echo.
set /p confirm="위 상태를 확인했나요? (y/n): "
if /i "%confirm%" NEQ "y" (
    echo ❌ 중단되었습니다.
    exit /b
)

:: === 3. Hugo 빌드 ===
echo ▶ Hugo 사이트 빌드 중...
hugo --baseURL=%BASE_URL%

IF NOT EXIST %BUILD_DIR% (
    echo ❌ 빌드 실패: %BUILD_DIR% 폴더가 없습니다.
    exit /b 1
)

:: === 4. public 폴더로 이동해서 배포 ===
cd %BUILD_DIR%

echo ▶ Git 초기화 및 GitHub 배포 준비 중...
git init
git remote add origin %TARGET_REPO%
git add .
git commit -m "🚀 Hugo 자동 배포 - %DATE% %TIME%"
git branch -M %TARGET_BRANCH%
git push -f origin %TARGET_BRANCH%

echo.
echo ✅ Hugo 사이트 배포가 완료되었습니다!
echo 🌐 접속 주소: %BASE_URL%
pause
