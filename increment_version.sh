#!/bin/bash

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

  # Verifica se houve commits desde a última tag
  if git log "$latest_tag"..HEAD --oneline | grep -qE "feat|fix|perf"; then
    # Incrementa a versão de acordo com o versionamento semântico
    if [ "$major" -eq "0" ]; then
      # Se a versão principal for 0, incrementamos a versão secundária
      minor=$((minor + 1))
    else
      # Caso contrário, incrementamos a versão principal
      major=$((major + 1))
    fi
  fi

  # Verifica se a nova versão é maior ou igual a 1.0.0
  if [ "$major" -eq "1" ] && [ "$minor" -eq "0" ] && [ "$patch" -eq "0" ]; then
    # Se a nova versão for menor que 1.0.0, definimos como 1.0.0
    new_version="1.0.0"
  else
    # Cria a nova versão
    new_version="$major.$minor.$patch"
  fi
fi

echo "Nova versão: $new_version"
