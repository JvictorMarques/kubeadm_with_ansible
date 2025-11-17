# kubeadm_with_ansible

Este repositório fornece scripts e configurações para implantar automaticamente um cluster Kubernetes na AWS. O processo é totalmente automatizado, utilizando o Terraform para o provisionamento da infraestrutura e o Ansible para a configuração dos nós e inicialização do cluster com o `kubeadm`.

Este projeto configura um cluster com os seguintes componentes:
*   Um nó master e um número configurável de nós workers.
*   `containerd` como runtime de contêiner.
*   Calico como plugin CNI (Container Network Interface).

## Pré-requisitos

Antes de começar, certifique-se de ter os seguintes itens instalados e configurados:
*   [Terraform](https://www.terraform.io/downloads.html)
*   [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
*   [AWS CLI](https://aws.amazon.com/cli/) com suas credenciais configuradas.
*   Um par de chaves SSH localizado em `~/.ssh/id_rsa.pub` e `~/.ssh/id_rsa`. A chave pública é usada pelo Terraform para conceder acesso SSH às instâncias EC2 provisionadas.

## Início Rápido

Siga estes passos para provisionar e configurar seu cluster Kubernetes.

1.  **Clone o repositório:**
    ```bash
    git clone https://github.com/jvictormarques/kubeadm_with_ansible.git
    cd kubeadm_with_ansible
    ```

2.  **Execute o script de inicialização:**
    Este script automatiza todo o processo de configuração. Ele executa o Terraform para criar a infraestrutura na AWS e, em seguida, roda um playbook Ansible para configurar o cluster.

    ```bash
    chmod +x scripts/*.sh
    ./scripts/startup.sh
    ```
    O script realiza as seguintes ações:
    - Inicializa o Terraform.
    - Provisiona os recursos AWS (VPC, Subnet, instâncias EC2, Security Groups, etc.).
    - Gera um arquivo de inventário Ansible (`ansible/hosts.ini`) com os IPs públicos das novas instâncias.
    - Executa o playbook `ansible/main.yml` para:
        - Instalar `containerd`, `kubeadm`, `kubectl` e `kubelet` em todos os nós.
        - Inicializar o plano de controle no nó master.
        - Instalar o plugin de rede Calico.
        - Adicionar os nós workers ao cluster.
        - Buscar o arquivo `kubeconfig` para sua máquina local.

3.  **Acesse seu cluster:**
    Após a conclusão do `startup.sh`, um arquivo `kubeconfig` será copiado para `k8s/config`. Você pode usar este arquivo para gerenciar seu novo cluster a partir da sua máquina local.

    Defina a variável de ambiente `KUBECONFIG`:
    ```bash
    export KUBECONFIG=$(pwd)/k8s/config
    ```
    Verifique se os nós do cluster estão prontos:
    ```bash
    kubectl get nodes
    ```

## Implantando uma Aplicação de Exemplo

Uma aplicação de exemplo NGINX está disponível em `k8s/deployment.yaml` para ajudar a testar o cluster.

1.  **Implemente a aplicação NGINX:**
    ```bash
    kubectl apply -f k8s/deployment.yaml
    ```

2.  **Verifique o status:**
    Confirme se o pod está em execução e o serviço foi criado.
    ```bash
    kubectl get pods
    kubectl get svc nginx
    ```
    A saída mostrará a NodePort atribuída ao serviço NGINX, que pode ser usada para acessar a aplicação.

## Gerenciando o Ambiente

O diretório `scripts` contém scripts auxiliares para gerenciar o ciclo de vida do cluster.

*   **Destruir a infraestrutura (`destroy.sh`):**
    Para remover todos os recursos AWS criados pelo Terraform, execute:
    ```bash
    ./scripts/destroy.sh
    ```
*   **Recriar a infraestrutura (`recreate.sh`):**
    Para destruir e recriar imediatamente todo o ambiente, execute:
    ```bash
    ./scripts/recreate.sh
    ```

## Personalização

Você pode personalizar sua implantação editando as variáveis em `terraform/vars.tf`. Variáveis principais incluem:

*   `workers_count`: Número de nós workers a serem criados (padrão: `2`).
*   `node_instance`: AMI ID e tipo de instância para os nós master e workers (padrão: `ami-0ecb62995f68bb549` e `t3.small`).
*   `kubeadm_ansible_subnet`: Bloco CIDR e zona de disponibilidade para a subnet.

## Estrutura do Projeto

```
.
├── ansible/          # Playbooks e roles do Ansible para configuração
│   ├── main.yml      # Playbook principal que orquestra todos os roles
│   ├── roles/        # Roles individuais para cada etapa de configuração
│   └── hosts.ini     # Arquivo de inventário gerado automaticamente pelo Terraform
├── k8s/              # Manifests do Kubernetes e kubeconfig gerado
│   ├── deployment.yaml
│   └── config
├── scripts/          # Scripts auxiliares para gerenciar o ambiente
│   ├── startup.sh
│   ├── destroy.sh
│   └── recreate.sh
└── terraform/        # Arquivos Terraform para provisionamento da infraestrutura AWS
    ├── main.tf
    ├── ec2.tf
    ├── vpc.tf
    └── vars.tf
```
