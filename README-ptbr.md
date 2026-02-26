# Verificador de Consistência de DNS

Leia-me: [English](README.md)

![Licença](https://img.shields.io/github/license/sr00t3d/bat-consistency-checker)
![Script Bat](https://img.shields.io/badge/language-Bash-green.svg)

<img width="700" src="bat-consistency-checker-cover.webp" />

Uma ferramenta em Script Batch do Windows (`.bat`) projetada para diagnosticar problemas de resolução e propagação de nomes DNS, com foco específico em servidores de e-mail (`mail.domain`).

Este script executa consultas cruzadas entre o DNS Local da máquina, o DNS Público do Google e o IP Público da rede para validar se o cliente está resolvendo o endereço IP correto do servidor.

## 🚀 Funcionalidades

* **Limpeza de Cache:** Executa automaticamente `ipconfig /flushdns` para garantir que nenhum dado obsoleto esteja afetando o teste.
* **Verificações Cruzadas:**
    * Consulta o IP do subdomínio `mail` via **DNS do Google (8.8.8.8)**.
    * Consulta o IP do subdomínio `mail` via **DNS Local** (o resolvedor configurado no adaptador de rede).
* **Identificação de IP Público:** Verifica o endereço IP externo do cliente usando o serviço OpenDNS.
* **Diagnóstico Automático:** Compara o IP resolvido localmente com o IP resolvido externamente e alerta o usuário caso haja divergência (indicando atrasos de propagação ou cache travado).

## 📋 Pré-requisitos

* **Sistema Operacional:** Windows (7, 8, 10 ou 11).
* **Permissões:** Recomendado executar como **Administrador** para garantir que o comando de limpeza de DNS funcione corretamente, embora as funções de consulta funcionem em modo de usuário.

## 🔧 Como Usar

1.  Baixe o arquivo do script (ex.: `check_dns.bat`).
2.  Clique com o botão direito no arquivo e selecione **"Executar como administrador"**.
3.  Aguarde a inicialização (5 segundos).
4.  Quando solicitado, digite apenas o nome do domínio principal.
    * *Exemplo:* Se o seu site for `www.company.com`, digite `company.com`.
5.  O script adicionará automaticamente o prefixo `mail.` e executará os diagnósticos.

## 📊 Entendendo os Resultados

O script exibirá um resumo ao final da execução:

| Campo | Descrição |
| :--- | :--- |
| **IP (resolvido por 8.8.8.8)** | O endereço IP que o mundo (Google) enxerga para o seu domínio. |
| **IP (resolvido pelo DNS Local)** | O endereço IP que **o seu computador** está vendo no momento. |
| **IP Público do Cliente** | O IP externo atual da sua conexão com a internet. |

### Possíveis Diagnósticos:

* ✅ **[OK]:** O IP que seu computador vê corresponde ao IP que o Google vê. Seu DNS está atualizado e consistente.
* ⚠️ **[ALERTA]:** O IP Local difere do IP do Google. Isso indica:
    * A propagação do DNS ainda não terminou;
    * Seu provedor de internet possui um cache desatualizado;
    * Existe uma entrada incorreta no arquivo `hosts` do Windows.

## 🛠️ Exemplo de Lógica do Código

A verificação principal de consistência segue esta lógica:

```batch
if "!IP_LOCAL!"=="!IP_SERVIDOR!" (
    echo [OK] O IP resolvido localmente corresponde ao IP retornado pelo servidor.
) else (
    echo [ALERTA] O IP resolvido localmente NÃO corresponde ao IP retornado pelo servidor.
)
```

## ⚠️ Aviso Legal

> [!WARNING]
> Este software é fornecido "como está". Certifique-se sempre de testar primeiro em um ambiente de desenvolvimento. O autor não se responsabiliza por qualquer uso indevido, consequências legais ou impacto em dados causado por esta ferramenta.

---

## 📚 Tutorial Detalhado

Para um guia completo passo a passo, confira meu artigo completo:

👉 [**Verifique seu Domínio e DNS Rapidamente**](https://perciocastelo.com.br/blog/check-your-domain-and-dns-quickly.html)

## Licença 📄

Este projeto está licenciado sob a **GNU General Public License v3.0**. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.
