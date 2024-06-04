#!/bin/bash

# Obtém a versão mais recente da tag
latest_tag=$(git describe --tags --abbrev=0 2>/dev/null)

# Verifica se a tag mais recente existe
if [ -z "$latest_tag" ]; then
  # Se não houver tags, começamos com a versão 1.0.0
  new_version="1.0.0"
else
  # Extrai os componentes da versão
  major=$(echo "$latest_tag" | cut -d. -f1)
  minor=$(echo "$latest_tag" | cut -d. -f2)
  patch=$(echo "$latest_tag" | cut -d. -f3)

  # Incrementa a versão com base nas mensagens de commit
  if git log --format=%B -n 1 HEAD | grep -q '\[major\]'; then
    major=$((major + 1))
    minor=0
    patch=0
  elif git log --format=%B -n 1 HEAD | grep -q '\[minor\]'; then
    minor=$((minor + 1))
    patch=0
  else
    patch=$((patch + 1))
  fi

  # Cria a nova versão
  new_version="$major.$minor.$patch"
fi

echo "Nova versão: $new_version"
