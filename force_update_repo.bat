@echo off
chcp 65001
setlocal

echo ==========================================
echo 🚀 로컬 작업물을 GitHub 저장소에 강제 덮어쓰기 시작합니다.
echo (대상: Jeremy-Joo/TechBlogRepo.git)
echo ==========================================

:: git 상태 보여주기
git status

:: 사용자 확인
echo.
set /p confirm="이 상태를 GitHub에 강제로 덮어쓰시겠습니까? (y/n): "
if /i "%confirm%" NEQ "y" (
    echo ❌ 취소되었습니다.
    exit /b
)

:: git 작업
echo ▶ 변경사항 추가 (git add .)
git add .

echo ▶ 커밋 생성
set commitMessage="🚀 강제 업데이트 (모든 파일 정리 후 업로드) - %DATE% %TIME%"
git commit -m %commitMessage%

echo ▶ 브랜치 이름 설정
git branch -M main

echo ▶ GitHub로 강제 푸시 시작
git push -f origin main

echo.
echo ==========================================
echo ✅ GitHub 저장소 강제 업데이트 완료!
echo 🌐 저장소: https://github.com/Jeremy-Joo/TechBlogRepo
echo ==========================================
pause
