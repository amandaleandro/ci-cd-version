#!/bin/bash

# Verifica se há alterações pendentes no repositório
if ! git diff --quiet; then
  echo "Há alterações pendentes no repositório. Uma nova versão será criada."

  # Obtém a versão mais recente da tag
  latest_tag=$(git describe --tags --abbrev=0)

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
      # Caso contrário, incrementamos a versão principal
      major=$((major + 1))
    fi

    # Cria a nova versão
    new_version="$major.$minor.$patch"
  fi

  echo "Nova versão: $new_version"

  # Aqui você pode criar a tag com a nova versão
  # git tag "$new_version"
else
  echo "Não há alterações no repositório. Nenhuma nova versão será criada."
fi
