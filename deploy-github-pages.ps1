param(
    [string]$Repo = "",
    [string]$Branch = "main",
    [string]$Path = "/",
    [switch]$SkipPush
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Ensure-GitHubCli {
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
        throw "O GitHub CLI (gh) não foi encontrado. Instale-o primeiro: https://cli.github.com/"
    }
}

function Get-RepoFromGitRemote {
    $remote = git config --get remote.origin.url 2>$null
    if (-not $remote) {
        throw "Nenhum remote 'origin' encontrado. Verifique se o repositório Git foi inicializado e conectado ao GitHub."
    }

    if ($remote -match 'github\.com[:/](?<owner>[^/]+)/(?<repo>[^/.]+?)(?:\.git)?$') {
        return "$($Matches.owner)/$($Matches.repo)"
    }

    throw "Remote do GitHub em formato inesperado: $remote"
}

Ensure-GitHubCli

if (-not $Repo) {
    $Repo = Get-RepoFromGitRemote
}

Write-Host "Repositório GitHub: $Repo"

try {
    gh auth status --hostname github.com 2>$null | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Você não está autenticado no GitHub. Abrindo login..."
        gh auth login
        if ($LASTEXITCODE -ne 0) {
            throw "Falha na autenticação do GitHub CLI."
        }
    }
}
catch {
    throw "Não foi possível verificar a autenticação do GitHub CLI: $($_.Exception.Message)"
}

if (-not (Test-Path ".git")) {
    throw "Este diretório não é um repositório Git. Execute 'git init' e configure o remote antes de continuar."
}

$workflowDir = ".github/workflows"
New-Item -ItemType Directory -Force -Path $workflowDir | Out-Null

$workflowContent = @'
name: Deploy static site to GitHub Pages

on:
  push:
    branches: ["main"]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: true

jobs:
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Pages
        uses: actions/configure-pages@v5

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: .

      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
'@

Set-Content -Path "$workflowDir/deploy-pages.yml" -Value $workflowContent -Encoding utf8
Set-Content -Path ".nojekyll" -Value "" -Encoding utf8

if (-not $SkipPush) {
    git add .
    git commit -m "Configure GitHub Pages" --allow-empty
    git push origin $Branch
}

Write-Host "Configurando GitHub Pages no repositório $Repo..."

$pagesExists = gh api -H "Accept: application/vnd.github+json" "/repos/$Repo/pages" 2>$null
if ($LASTEXITCODE -ne 0) {
    gh api --method POST -H "Accept: application/vnd.github+json" "/repos/$Repo/pages" -f "source[branch]=$Branch" -f "source[path]=$Path"
}
else {
    gh api --method PUT -H "Accept: application/vnd.github+json" "/repos/$Repo/pages" -f "source[branch]=$Branch" -f "source[path]=$Path"
}

Write-Host ""
Write-Host "Status da publicação:"
gh api -H "Accept: application/vnd.github+json" "/repos/$Repo/pages"

Write-Host ""
Write-Host "URL esperada: https://$($Repo.Split('/')[0]).github.io/$($Repo.Split('/')[1])/"
Write-Host "Aguarde alguns minutos e confira o status do workflow no GitHub."
