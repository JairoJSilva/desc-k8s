#!/bin/bash

# Define o repositório remoto
REMOTE_REPO="git@github.com:JairoJSilva/desc-k8s.git"

# 1. Solicita a mensagem do commit
echo "💬 Digite a mensagem do commit:"
read -r COMMIT_MESSAGE

if [ -z "$COMMIT_MESSAGE" ]; then
    echo "❌ Erro: A mensagem do commit não pode ser vazia."
    exit 1
fi

# 2. Executa o fluxo comum (Add e Commit)
git add .
git commit -m "$COMMIT_MESSAGE"

# Obtém o nome do branch atual
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# 3. Push do código
echo "📤 Fazendo push para origin/$CURRENT_BRANCH..."
git push origin "$CURRENT_BRANCH"

# 4. Lógica de Versionamento Semântico
echo "🏷️  Deseja criar uma tag SemVer? (s/n)"
read -r CONFIRM_TAG

if [[ "$CONFIRM_TAG" =~ ^[Ss]$ ]]; then
    # Busca a última tag via git, se não existir começa com v0.0.0
    LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null)
    if [ -z "$LAST_TAG" ]; then
        LAST_TAG="v0.0.0"
    fi

    # Extrai os números (removendo o 'v' inicial se houver)
    BASE_VERSION=${LAST_TAG#v}
    MAJOR=$(echo "$BASE_VERSION" | cut -d. -f1)
    MINOR=$(echo "$BASE_VERSION" | cut -d. -f2)
    PATCH=$(echo "$BASE_VERSION" | cut -d. -f3)

    echo "Última versão: $LAST_TAG"
    echo "Qual incremento deseja realizar?"
    echo "1) Major (X.0.0) - Mudanças incompatíveis"
    echo "2) Minor (0.X.0) - Novas funcionalidades (compatíveis)"
    echo "3) Patch (0.0.X) - Correções de bugs"
    read -r VERSION_CHOICE

    case $VERSION_CHOICE in
        1)
            MAJOR=$((MAJOR + 1))
            MINOR=0
            PATCH=0
            ;;
        2)
            MINOR=$((MINOR + 1))
            PATCH=0
            ;;
        3)
            PATCH=$((PATCH + 1))
            ;;
        *)
            echo "❌ Opção inválida. Operação de tag cancelada."
            exit 1
            ;;
    esac

    NEW_TAG="v$MAJOR.$MINOR.$PATCH"

    echo "📌 Criando e enviando tag: $NEW_TAG"
    git tag -a "$NEW_TAG" -m "$COMMIT_MESSAGE"
    git push origin "$NEW_TAG"
    echo "✅ Código e Tag $NEW_TAG enviados com sucesso!"
else
    echo "⏭️  Push realizado sem criação de tag."
    echo "✅ Processo concluído!"
fi
## Só pra teste