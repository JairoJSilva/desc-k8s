#!/bin/bash

# Verifica se está em um repositório Git
if [ ! -d ".git" ]; then
  echo "❌ Este diretório não é um repositório Git."
  exit 1
fi

# Pergunta mensagem do commit
read -p "Digite a mensagem do commit: " COMMIT_MSG

if [ -z "$COMMIT_MSG" ]; then
  echo "❌ Mensagem de commit não pode ser vazia."
  exit 1
fi

# Adiciona arquivos
git add .

# Faz commit
git commit -m "$COMMIT_MSG"

# Pergunta se deseja criar tag
read -p "Deseja criar uma tag? (s/n): " CREATE_TAG

if [[ "$CREATE_TAG" == "s" || "$CREATE_TAG" == "S" ]]; then
  read -p "Digite o nome da tag (ex: v1.0.0): " TAG_NAME

  if [ -z "$TAG_NAME" ]; then
    echo "❌ Nome da tag não pode ser vazio."
    exit 1
  fi

  git tag -a "$TAG_NAME" -m "Release $TAG_NAME"
  echo "🏷️ Tag $TAG_NAME criada."
fi

# Push branch
git push

# Push tag (se existir)
if [[ "$CREATE_TAG" == "s" || "$CREATE_TAG" == "S" ]]; then
  git push origin "$TAG_NAME"
fi

echo "✅ Push finalizado com sucesso!"