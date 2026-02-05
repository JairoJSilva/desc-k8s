#!/bin/bash

# Verifica se é repositório git
if [ ! -d ".git" ]; then
  echo "❌ Este diretório não é um repositório Git."
  exit 1
fi

# Pergunta commit
read -p "Mensagem do commit: " COMMIT_MSG
if [ -z "$COMMIT_MSG" ]; then
  echo "❌ Commit não pode ser vazio."
  exit 1
fi

# Pergunta tipo de tag
echo "Tipo de versão:"
echo "1) feature (minor)"
echo "2) release (major)"
echo "3) hotfix (patch)"
read -p "Escolha [1/2/3]: " TYPE

# Pega última tag
LAST_TAG=$(git tag --sort=-v:refname | head -n 1)

if [ -z "$LAST_TAG" ]; then
  LAST_TAG="v0.0.0"
fi

echo "Última tag: $LAST_TAG"

# Remove v
VERSION=${LAST_TAG#v}
IFS='.' read -r MAJOR MINOR PATCH <<< "$VERSION"

# Incrementa conforme escolha
case $TYPE in
  1)
    ((MINOR++))
    PATCH=0
    TAG_TYPE="feature"
    ;;
  2)
    ((MAJOR++))
    MINOR=0
    PATCH=0
    TAG_TYPE="release"
    ;;
  3)
    ((PATCH++))
    TAG_TYPE="hotfix"
    ;;
  *)
    echo "❌ Opção inválida"
    exit 1
    ;;
esac

NEW_TAG="v$MAJOR.$MINOR.$PATCH"

echo "Nova tag: $NEW_TAG ($TAG_TYPE)"

# Commit
git add .
git commit -m "$COMMIT_MSG"

# Cria tag anotada
git tag -a "$NEW_TAG" -m "$TAG_TYPE: $COMMIT_MSG"

# Push branch e tag
git push
git push origin "$NEW_TAG"

echo "✅ Commit e tag $NEW_TAG enviados!"
