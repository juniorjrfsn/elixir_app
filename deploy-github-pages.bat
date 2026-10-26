@echo off
setlocal

where gh >nul 2>nul
if errorlevel 1 (
    echo GitHub CLI (gh) nao encontrado.
    echo Instale em: https://cli.github.com/
    echo Depois rode novamente este arquivo.
    pause
    exit /b 1
)

where git >nul 2>nul
if errorlevel 1 (
    echo Git instalado nao encontrado.
    echo Instale o Git e rode novamente.
    pause
    exit /b 1
)

if not exist ".git" (
    echo Este diretorio nao e um repositorio Git.
    echo Execute: git init
    echo e depois configure o remote origin.
    pause
    exit /b 1
)

if not exist ".github\workflows" mkdir ".github\workflows"

> ".github\workflows\deploy-pages.yml" (
    echo name: Deploy static site to GitHub Pages
    echo.
    echo on:
    echo   push:
    echo     branches: ["main"]
    echo   workflow_dispatch:
    echo.
    echo permissions:
    echo   contents: read
    echo   pages: write
    echo   id-token: write
    echo.
    echo concurrency:
    echo   group: "pages"
    echo   cancel-in-progress: true
    echo.
    echo jobs:
    echo   deploy:
    echo     environment:
    echo       name: github-pages
    echo       url: ${{ steps.deployment.outputs.page_url }}
    echo     runs-on: ubuntu-latest
    echo     steps:
    echo       - name: Checkout
    echo         uses: actions/checkout@v4
    echo.
    echo       - name: Setup Pages
    echo         uses: actions/configure-pages@v5
    echo.
    echo       - name: Upload artifact
    echo         uses: actions/upload-pages-artifact@v3
    echo         with:
    echo           path: .
    echo.
    echo       - name: Deploy to GitHub Pages
    echo         id: deployment
    echo         uses: actions/deploy-pages@v4
)

> ".nojekyll" (
    rem arquivo vazio para evitar processamento do Jekyll
)

for /f "tokens=*" %%i in ('git config --get remote.origin.url 2^>nul') do set REMOTE=%%i
if "%REMOTE%"=="" (
    echo Nenhum remote origin encontrado.
    echo Configure o remote do GitHub antes de continuar.
    echo Exemplo: git remote add origin https://github.com/SEU_USUARIO/SEU_REPO.git
    pause
    exit /b 1
)

for /f "tokens=1,2 delims=/:" %%a in ("%REMOTE%") do set HOST=%%a & set REST=%%b
for /f "tokens=1,2 delims=/" %%a in ("%REST%") do set OWNER=%%a & set REPO=%%b
if "%OWNER%"=="" or "%REPO%"=="" (
    echo Remote invalido: %REMOTE%
    echo Use o formato: https://github.com/SEU_USUARIO/SEU_REPO.git
    pause
    exit /b 1
)

set REPO_PATH=%OWNER%/%REPO%

gh auth status --hostname github.com >nul 2>nul
if errorlevel 1 (
    echo Login no GitHub necessario.
    gh auth login
    if errorlevel 1 (
        echo Falha na autenticacao do GitHub CLI.
        pause
        exit /b 1
    )
)

git add .
git commit -m "Configure GitHub Pages" --allow-empty
if errorlevel 1 (
    echo Nenhuma alteracao para commit. Continuando...
)

git push origin main
if errorlevel 1 (
    echo Falha no push. Verifique o remote e as credenciais.
    pause
    exit /b 1
)

gh api -H "Accept: application/vnd.github+json" "/repos/%REPO_PATH%/pages" >nul 2>nul
if errorlevel 1 (
    echo Ativando GitHub Pages via API...
    gh api --method POST -H "Accept: application/vnd.github+json" "/repos/%REPO_PATH%/pages" -f "source[branch]=main" -f "source[path]=/"
) else (
    echo Atualizando GitHub Pages via API...
    gh api --method PUT -H "Accept: application/vnd.github+json" "/repos/%REPO_PATH%/pages" -f "source[branch]=main" -f "source[path]=/"
)

if errorlevel 1 (
    echo Houve um erro ao ativar o GitHub Pages.
    pause
    exit /b 1
)

echo.
echo Publicacao configurada com sucesso.
echo URL esperada:
 echo https://%OWNER%.github.io/%REPO%/

echo.
echo Aguarde alguns minutos para a primeira publicacao aparecer.
pause
