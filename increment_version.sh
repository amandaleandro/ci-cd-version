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

  # Incrementa a versão de acordo com o versionamento semântico
  if [ "$major" -eq "0" ]; then
    # Se a versão principal for 0, incrementamos a versão secundária
    minor=$((minor + 1))
  else
    # Caso contrário, verificamos os commits para determinar se é necessário incrementar major, minor ou patch
    commit_messages=$(git log --pretty=format:"%s" ${latest_tag}..HEAD)
    if [[ $commit_messages == *"BREAKING CHANGE"* ]]; then
      # Se houver commits com a mensagem "BREAKING CHANGE", incrementamos o major
      major=$((major + 1))
      minor=0
      patch=0
    elif [[ $commit_messages == *"feat"* ]]; then
      # Se houver commits com a palavra-chave "feat", incrementamos o minor
      minor=$((minor + 1))
      patch=0
    else
      # Caso contrário, incrementamos o patch
      patch=$((patch + 1))
    fi
  fi

  # Cria a nova versão
  new_version="$major.$minor.$patch"
fi

echo "Nova versão: $new_version"
