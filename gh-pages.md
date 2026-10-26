# GitHub Pages para o projeto

Este guia mostra como publicar o site estático do repositório no GitHub Pages usando o GitHub CLI e também com os scripts automáticos já criados no projeto.

## 1) Verificar o repositório

Confirme se o repositório já está conectado ao GitHub:

```bash
git remote -v
```

Se o remote não existir, adicione:

```bash
git remote add origin https://github.com/juniorjrfsn/elixir_app.git
```

## 2) Autenticar no GitHub CLI

```bash
gh auth login
```

Opcionalmente, defina o repositório padrão:

```bash
gh repo set-default juniorjrfsn/elixir_app
```

## 3) Publicar o código

```bash
git add .
git commit -m "Configure GitHub Pages"
git push origin main
```

## 4) Verificar se o workflow do GitHub Actions rodou

```bash
gh run list --limit 5
```

Se quiser ver os logs de uma execução em particular:

```bash
gh run view <RUN_ID> --log
```

## 5) Ativar o GitHub Pages via API

Se a página ainda não estiver habilitada, use:

```bash
gh api --method POST   -H "Accept: application/vnd.github+json"   /repos/juniorjrfsn/elixir_app/pages   -f "source[branch]=main"   -f "source[path]=/"
```

Se a página já existir, atualize com:

```bash
gh api --method PUT  -H "Accept: application/vnd.github+json"  /repos/juniorjrfsn/elixir_app/pages   -f "source[branch]=main"   -f "source[path]=/"
```

## 6) Verificar o status da publicação

```bash
gh api -H "Accept: application/vnd.github+json" /repos/juniorjrfsn/elixir_app/pages
```

A URL final esperada é:

```text
https://juniorjrfsn.github.io/elixir_app/
```

## 7) Script automático em PowerShell

No diretório do projeto, execute:

```powershell
.\deploy-github-pages.ps1
```

Para outro repositório:

```powershell
.\deploy-github-pages.ps1 -Repo "juniorjrfsn/elixir_app"
```

Para apenas preparar os arquivos sem fazer push:

```powershell
.\deploy-github-pages.ps1 -SkipPush
```

Esse script cria:

- `.github/workflows/deploy-pages.yml`
- `.nojekyll`
- faz `git add`, `git commit`, `git push`
- ativa o GitHub Pages pela API

## 8) Script automático em .bat para Windows

Dê duplo clique no arquivo:

```text
deploy-github-pages.bat
```

Ou rode pelo PowerShell:

```powershell
.\deploy-github-pages.bat
```

Esse script faz a mesma tarefa de forma mais simples para uso no Windows.

## 9) Observações importantes

- O site deve estar em `index.html` na raiz do repositório.
- O conteúdo publicado é estático; não deve depender de um servidor backend.
- O GitHub Pages pode levar alguns minutos para ficar disponível após a primeira publicação.
- Se quiser usar uma subpasta como raiz, ajuste o parâmetro `source[path]` para a pasta correta.

## 10) Resumo rápido

```bash
gh auth login
git add .
git commit -m "Configure GitHub Pages"
git push origin main
```

```bash
gh api --method POST \
  -H "Accept: application/vnd.github+json" \
  /repos/juniorjrfsn/elixir_app/pages \
  -f "source[branch]=main" \
  -f "source[path]=/"
```

```text
https://juniorjrfsn.github.io/elixir_app/
```
