#!/bin/bash

# Verifica se o Git está instalado
if ! command -v git &> /dev/null; then
  echo "Git não está instalado. Por favor, instale o Git e tente novamente."
  exit 1
fi

# Navega até o diretório do repositório
cd "$(dirname "$0")"

# Garante que o script está sendo executado no contexto de um repositório Git
if ! git rev-parse --is-inside-work-tree &> /dev/null; then
  echo "Este script deve ser executado dentro de um repositório Git."
  exit 1
fi

# Garante que o script tenha permissões de execução
if [[ ! -x "$0" ]]; then
  echo "O script não tem permissões de execução. Conceda permissões de execução usando 'chmod +x $0'."
  exit 1
fi

# Garante que estamos na branch principal (main)
current_branch=$(git rev-parse --abbrev-ref HEAD)
if [ "$current_branch" != "main" ]; then
  echo "Este script deve ser executado na branch 'main'."
  exit 1
fi

# Obtém a versão da última tag ou define como v1.0.0 se não houver tags
latest_tag=$(git describe --tags --abbrev=0 2>/dev/null)
if [ -z "$latest_tag" ]; then
  latest_tag="v1.0.0"
  echo "Nenhuma tag anterior encontrada. Começando com a versão $latest_tag."
fi

# Extrai os componentes da versão da última tag
version=$(echo "$latest_tag" | cut -d'v' -f2)

# Extrai as versões de maior, menor e correção
IFS='.' read -r major minor patch <<< "$version"

# Verifica os commits para determinar se deve incrementar a versão de maior, menor ou de correção
commit_messages=$(git log --pretty=format:"%s" ${latest_tag}..HEAD)
echo "Mensagens de commit desde a última tag:"
echo "$commit_messages"

if [[ -z "$commit_messages" ]]; then
  # Se não houver mensagens de commit, incrementa a versão de correção
  patch=$((patch + 1))
  echo "Nenhuma mudança detectada. Incrementando a versão de correção para $patch."
else
  if [[ $commit_messages == *"BREAKING CHANGE"* ]]; then
    # Se houver commits com a mensagem "BREAKING CHANGE", incrementa a versão de maior
    major=$((major + 1))
    minor=0
    patch=0
    echo "Mudança de quebra detectada. Incrementando a versão de maior para $major."
  elif [[ $commit_messages == *"feat"* ]]; then
    # Se houver commits com a palavra-chave "feat", incrementa a versão de menor
    minor=$((minor + 1))
    patch=0
    echo "Commits de recurso detectados. Incrementando a versão de menor para $minor."
  else
    # Caso contrário, incrementa a versão de correção
    patch=$((patch + 1))
    echo "Incrementando a versão de correção para $patch."
  fi
fi

# Cria a nova versão
new_version="v$major.$minor.$patch"
echo "Nova versão: $new_version"

# Verifica se a tag já existe
if git rev-parse "$new_version" >/dev/null 2>&1; then
  echo "Tag $new_version já existe. Saindo sem criar uma nova tag."
  exit 0
fi

# Escreve a nova versão em um arquivo
echo "$new_version" > version.txt

# Adiciona uma tag ao repositório com a nova versão e faz o push da tag para o repositório remoto
git tag "$new_version"
git push origin "$new_version"
