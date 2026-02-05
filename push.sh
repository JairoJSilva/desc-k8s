#!/bin/bash

# Verifica se está em um repositório git
if [ ! -d ".git" ]; then
  echo "❌ Este diretório não é um repositório Git."
  exit 1
fi

# Solicita mensagem do commit
read -p "Digite a mensagem do commit: " COMMIT_MSG

if [ -z "$COMMIT_MSG" ]; then
  echo "❌ Commit cancelado. Mensagem vazia."
  exit 1
fi

# Adiciona arquivos
git add .

# Faz commit
git commit -m "$COMMIT_MSG"

# Pergunta sobre TAG
read -p "Deseja criar uma TAG? (s/n): " CREATE_TAG

if [[ "$CREATE_TAG" == "s" || "$CREATE_TAG" == "S" ]]; then
  read -p "Digite o nome da TAG (ex: v1.0.0): " TAG_NAME

  if [ -z "$TAG_NAME" ]; then
    echo "❌ Nome da TAG vazio. Ignorando TAG."
  else
    git tag -a "$TAG_NAME" -m "$COMMIT_MSG"
    echo "✅ TAG '$TAG_NAME' criada."
  fi
fi

# Push commit
git push

# Push tags (se houver)
git push --tags

echo "🚀 Push finalizado com sucesso!"