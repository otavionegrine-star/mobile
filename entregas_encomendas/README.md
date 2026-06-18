# 📦 Sistema de Controle de Encomendas

Um aplicativo desenvolvido em Flutter para otimizar o gerenciamento, recebimento e a entrega de encomendas em condomínios residenciais ou comerciais. O sistema funciona de forma totalmente offline, utilizando persistência local para garantir agilidade e segurança no controle de fluxos.

---

## ✨ Funcionalidades do Sistema

### 👤 Painel de Moradores
* **Cadastro estruturado:** Permite registrar Nome Completo, Documento de Identidade, Idade e Endereço/Apartamento.
* **Listagem Inteligente:** Apresenta todos os moradores organizados automaticamente por ordem alfabética para facilitar a busca.
* **Feedback Visual:** Notificações em formato de SnackBar confirmando o sucesso do cadastro.
* **Ficha Detalhada:** Tela exclusiva contendo as informações completas do morador e seu respectivo histórico de entregas.

### 📥 Fluxo de Encomendas
* **Entrada de Pacotes:** Registro simplificado especificando a categoria da encomenda (Ex: Caixa, Envelope, Mercado Livre).
* **Timestamp Automático:** Captura exata do momento de recebimento no formato `YYYY-MM-DD HH:MM`.
* **Controle de Status:** Diferenciação visual por cores e ícones (Laranja para pacotes **Pendentes** e Verde para **Retirados**).
* **Protocolo de Saída:** Atualização instantânea com a data e hora em que o morador realizou a retirada física do pacote.

---

## 🛠️ Tecnologias e Dependências

* **[Flutter](https://flutter.dev/):** SDK principal utilizando componentes de design baseados no **Material 3**.
* **[sqflite](https://pub.dev/packages/sqflite):** Banco de dados relacional (SQLite) para persistência de dados local estável.
* **[path](https://pub.dev/packages/path):** Biblioteca utilitária para gerenciamento de caminhos de arquivos nos diretórios do dispositivo.

---

## 📂 Organização de Arquivos (Estrutura do Projeto)

O projeto foi construído seguindo uma arquitetura modular dividida por responsabilidades:

```text
lib/
│
├── database/
│   └── db_helper.dart            # Inicialização do SQLite, tabelas e métodos CRUD
│
├── models/
│   ├── morador_model.dart        # Modelo de dados e serialização do Morador
│   └── encomenda_model.dart      # Modelo de dados e serialização da Encomenda
│
├── screens/
│   ├── home_screen.dart          # Listagem geral e formulário de moradores
│   └── detalhes_morador_screen.dart # Perfil do morador e controle de pacotes
│
└── main.dart                     # Inicialização do app e configuração do tema
