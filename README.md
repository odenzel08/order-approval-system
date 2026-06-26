# 📋 Sistema de Aprovação de Pedidos

Projeto desenvolvido em **Salesforce (Apex)** com o objetivo de demonstrar uma arquitetura escalável para processamento de pedidos utilizando o padrão **Trigger Handler**, processamento assíncrono com **Queueable Apex** e boas práticas de desenvolvimento **bulkificado**.

## 🚀 Objetivo

Este projeto simula um fluxo de aprovação de pedidos onde a decisão de aprovação depende do valor do pedido.

Além da regra de negócio, o foco principal é demonstrar uma arquitetura organizada, desacoplada e preparada para lidar com grandes volumes de registros.

## 🏗️ Arquitetura

O fluxo da aplicação segue a seguinte sequência:

```text
Pedido criado
      │
      ▼
Trigger
      │
      ▼
Trigger Handler
      │
      ▼
Queueable Apex
      │
      ▼
Processamento assíncrono e bulkificado
      │
      ▼
Validação das regras de aprovação
      │
      ├── Pedido abaixo do limite
      │          ▼
      │   Aprovação automática
      │
      └── Pedido acima do limite
                 ▼
 Aprovação pelo gerente do usuário criador
```

## ⚙️ Regras de Negócio

* Ao criar um pedido, um Trigger é executado.
* O Trigger delega toda a lógica para uma classe Handler.
* O Handler envia os registros para uma classe Queueable.
* O Queueable processa todos os pedidos de forma assíncrona e bulkificada.
* Se o valor do pedido estiver dentro do limite permitido, ele é aprovado automaticamente.
* Caso o valor ultrapasse o limite definido, o pedido é encaminhado para aprovação do gerente do usuário responsável.

## 💡 Conceitos Aplicados

* Trigger Handler Pattern
* Separação de responsabilidades (SoC)
* Queueable Apex
* Processamento assíncrono
* Bulkification
* Boas práticas em Triggers
* Clean Code
* Arquitetura em camadas

## 🛠️ Tecnologias

* Salesforce Platform
* Apex
* SOQL
* Queueable Apex
* Triggers
  
## 🎯 Motivação

Este projeto foi desenvolvido como prática de arquitetura em Apex, buscando reproduzir um cenário comum em aplicações corporativas: processamento de pedidos com fluxo de aprovação, mantendo o código organizado, reutilizável e preparado para evolução futura.
