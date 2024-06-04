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

# Verifica se houve alterações desde a última tag
if [ "$(git diff $latest_tag)" ]; then
  # Se houver alterações, incrementa a versão de correção
  patch=$((patch + 1))
  echo "Alterações detectadas. Incrementando a versão de correção para $patch."
else
  echo "Nenhuma alteração detectada. Mantendo a versão atual $version."
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
