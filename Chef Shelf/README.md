# 🍳 Chef’s Shelf

> **Seu caderno digital de receitas e assistente culinário inteligente.**  
> Desenvolvido com Flutter e integrado ao Firebase e TheMealDB API.

---

## 📌 Visão Geral

O **Chef’s Shelf** é um aplicativo mobile completo de culinária e gestão de receitas. Ele permite que entusiastas e cozinheiros domésticos descubram milhares de pratos internacionais, organizem suas receitas preferidas em um caderno pessoal sincronizado na nuvem e acompanhem o preparo prato a prato com suporte a modo cozinha e tradução automática para português (`pt-BR`).

---

## ✨ Principais Funcionalidades

- **🌟 Descoberta & Inspiração Diária**:
  - Destaque da *Receita do Dia* em formato Bento Card com tempo, nível de dificuldade e calorias.
  - Carrossel de categorias culinárias com emojis (Massas 🍝, Carnes 🥩, Sobremesas 🍰, Saladas 🥗, etc.).
  - Widget flutuante de **Timer de Cozinha** para controle de tempo de preparo.

- **🔍 Busca Global de Receitas**:
  - Integração com a base de dados pública **TheMealDB API**.
  - Filtros rápidos por chips de categorias e busca dinâmica por ingredientes ou nome do prato.
  - Resultados detalhados com avaliações, tempos de preparo e origem culinária.

- **📖 Meu Caderno de Receitas (Cloud Firestore)**:
  - Salve suas receitas favoritas com apenas um toque.
  - Sincronização em tempo real entre dispositivos via **Google Cloud Firestore**.
  - Gerenciamento de acervo pessoal com busca interna e confirmação segura de exclusão.

- **🌐 Tradução Culinária Instantânea (pt-BR)**:
  - Botão de tradução gastronômica inteligente na tela de detalhes.
  - Dicionário culinário nativo para cortes, temperos, medidas e categorias com suporte a tradução via API pública.
  - Alternância imediata entre o texto original em inglês e a versão traduzida para o português.

- **👨‍🍳 Modo Cozinha & Checklist de Ingredientes**:
  - Lista interativa de ingredientes com efeito tachado (*strikethrough*) e contador dinâmico de itens separados.
  - Etapas do modo de preparo numeradas e organizadas cronologicamente.
  - Botão de acesso rápido ao **Modo Cozinha (Passo a Passo)**.

- **🔐 Autenticação Híbrida & Segura**:
  - Login e Cadastro completos com validação de senha e formulários ergonômicos.
  - Integração nativa com **Firebase Authentication**.
  - Suporte resiliente a fallback local para execução contínua em redes com proxy ou offline.
  - Botão de atalho para preenchimento de conta de demonstração com um clique.

---

## 🔑 Credenciais para Teste Rápido

Para testar o aplicativo sem necessidade de criar uma nova conta manualmente, utilize as credenciais de demonstração:

| Campo | Credencial |
| :--- | :--- |
| **E-mail** | `chef@chefshelf.com` |
| **Senha** | `123456` |

*(A tela de login possui o botão **"Preencher conta de teste"** que preenche esses campos automaticamente).*

---

## 🎨 Design System Oficial

O aplicativo adota a identidade visual gastronômica com suporte a **Material 3**:

| Token | Hexadecimal | Finalidade |
| :--- | :--- | :--- |
| `primary` | `#04442F` | Verde Floresta institucional e cabeçalhos |
| `primaryContainer` | `#245C45` | Botões de ação principal e indicadores ativos |
| `background` / `surface` | `#FFF8F5` | Fundo creme culinário acolhedor |
| `secondaryContainer` | `#DAE5DC` | Badges e pílulas secundárias |
| `cookingMode` | `#F4A261` | Botão destacado do Modo Cozinha |
| `tertiaryContainer` | `#7F4206` | Destaques quentes e notas do chef |
| `error` | `#BA1A1A` | Ações de exclusão e logout |

---

## 📂 Arquitetura do Projeto

O código foi desenvolvido seguindo as boas práticas do **Clean Code** e princípios **SOLID**, mantendo funções concisas e de responsabilidade única:

```text
chef_shelf/
├── lib/
│   ├── firebase_options.dart      # Configuração da plataforma Firebase
│   ├── main.dart                  # Inicialização do app e tema Material 3
│   ├── models/
│   │   └── recipe.dart            # Modelo de dados da receita e serialização
│   ├── screens/
│   │   ├── auth_gate.dart         # Controle de rotas autenticadas
│   │   ├── welcome_screen.dart    # Tela de boas-vindas e onboarding
│   │   ├── login_screen.dart      # Autenticação com e-mail e senha
│   │   ├── register_screen.dart   # Cadastro de novos usuários
│   │   ├── home_screen.dart       # Feed inicial, receita do dia e timer
│   │   ├── search_screen.dart     # Pesquisa de receitas na TheMealDB API
│   │   ├── cookbook_screen.dart   # Caderno de receitas salvas do usuário
│   │   ├── recipe_detail_screen.dart # Detalhes da receita e tradução
│   │   └── profile_screen.dart    # Perfil, configurações e métricas
│   ├── services/
│   │   ├── auth_service.dart      # Serviço de autenticação híbrido
│   │   ├── firestore_service.dart # Sincronização de receitas na nuvem
│   │   ├── recipe_api.dart        # Integração com a API TheMealDB
│   │   └── translation_service.dart # Tradutor culinário inteligente
│   ├── theme/
│   │   ├── app_colors.dart        # Tokens de cores oficiais
│   │   └── app_theme.dart         # Tema global Material 3
│   └── widgets/
│       └── recipe_card.dart       # Card reutilizável de receita
└── pubspec.yaml                   # Dependências e metadados do projeto
```

---

## 🚀 Como Executar o Projeto

### Pré-requisitos
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (versão 3.12.1 ou superior)
- [Dart SDK](https://dart.dev/get-dart)
- Emulador Android, dispositivo físico ou navegador Google Chrome

### Instalação

1. Clone ou acesse o diretório do projeto:
```bash
cd "chef_shelf"
```

2. Instale as dependências do Flutter:
```bash
flutter pub get
```

3. Verifique a integridade do código:
```bash
flutter analyze
```

4. Execute o aplicativo:
```bash
flutter run
```

---

## 🛠️ Tecnologias Utilizadas

- **[Flutter](https://flutter.dev/)** — Framework de interface multiplataforma.
- **[Firebase Authentication](https://firebase.google.com/products/auth)** — Gestão de identidade e usuários.
- **[Cloud Firestore](https://firebase.google.com/products/firestore)** — Banco de dados NoSQL em tempo real.
- **[TheMealDB API](https://www.themealdb.com/api.php)** — Base pública de receitas culinárias globais.
- **[HTTP](https://pub.dev/packages/http)** — Comunicação REST com serviços externos.

---

## 👨‍💻 Autor

Projeto desenvolvido como parte das atividades de desenvolvimento mobile — **SESI / SENAI**.
