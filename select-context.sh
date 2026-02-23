#!/bin/bash

# Função para listar os contextos e permitir a seleção
select_k8s_context() {
    # Listar todos os contextos disponíveis
    contexts=$(kubectl config get-contexts -o name)

    # Contar o número de contextos
    context_count=$(echo "$contexts" | wc -l)

    # Verificar se existem contextos disponíveis
    if [ "$context_count" -eq 0 ]; then
        echo "Nenhum contexto encontrado."
        exit 1
    fi

    # Exibir as opções de contextos numeradas
    echo "Escolha o cluster (contexto) desejado:"
    i=1
    for context in $contexts; do
        echo "[$i] $context"
        i=$((i + 1))
    done

    # Ler a escolha do usuário
    read -p "Digite o número do contexto desejado: " context_number

    # Validar a escolha do usuário
    if [ "$context_number" -ge 1 ] 2>/dev/null && [ "$context_number" -le "$context_count" ] 2>/dev/null; then
        # Obter o nome do contexto escolhido
        chosen_context=$(echo "$contexts" | sed -n "${context_number}p")

        # Configurar o contexto escolhido
        kubectl config use-context "$chosen_context"

        echo "Contexto alterado para: $chosen_context"
    else
        echo "Escolha inválida."
        exit 1
    fi
}

# Chamar a função
select_k8s_context


# Mostrar namespaces para garantir qual cluster foi selecionado
kubectl get namespaces -o custom-columns=:metadata.name