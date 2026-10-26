


#### Logar em uma conta no GitHub
```
gh auth login
```

Alternar entre as contas
Para ativar a conta juniorjrfsn, execute:
```
gh auth switch --user juniorjrfsn
```

Confira qual conta está ativa:
```
gh auth status
```


#### Remover uma conta do GitHub CLI
Se você quiser desconectar a conta juniorjrfsn, execute:
```
gh auth logout --hostname github.com --user juniorjfsny
gh auth logout --hostname github.com --user juniorjrfsn
```

#### Verificar qual conta o Git usa nos seus projetos
Dentro da pasta do projeto, execute:
```
git config user.name
git config user.email
git remote -v
```

#### Repositório
``` 
git config user.name "juniorjrfsn"
git config user.email "junior.jrfsn@gmail.com"
``` 

#### Repositório Globais
``` 
git config --global user.name "juniorjrfsn"
git config --global user.email "junior.jrfsn@gmail.com"
```