# 🚀 Setup do Ambiente de Desenvolvimento

Este documento registra as configurações iniciais realizadas para preparar o ambiente de trabalho e estudos para o ano letivo.

## 📅 Data: 27/01/2026            ## 📝 Resumo das Atividades

Realizamos a padronização e preparação das ferramentas essenciais para o fluxo de desenvolvimento. O foco foi garantir que tanto a identidade do desenvolvedor quanto as ferramentas (IDE e Versionamento) estejam prontas para uso em aula.

### ✅ Detalhamento das Tarefas:

- [x] **Configuração de Perfil Anual:**
  - Organização do ambiente de trabalho para o novo ciclo.
  - Definição de preferências de sistema e organização de pastas.

- [x] **Criação do Perfil Dev:**
  - Estabelecimento da identidade de desenvolvedor.
  - Padronização de nomes de usuário e e-mails para uso profissional/acadêmico.

- [x] **Integração com GitHub:**
  - Configuração da conta e vinculação com o ambiente local.
  - Testes de autenticação e preparação para versionamento de código.

- [x] **Otimização do VS Code:**
  - Ajuste de preferências do editor (settings).
  - Instalação de extensões essenciais para as aulas.
  - Personalização do layout para melhor produtividade.

## Conteúdo da Aula Anterior

## Introdução ao Desenvolvimento Mobile

### Tipo de Desenvolvimento

- Nativo
    - Android:
        - SDK : Android SDK
        - IDE : Android Studio
        - Linguagens: Kotlin e Java
        - Ambientes: Mac, Win, Linux

    - Ios:
        - SDK: Cocoa Touch
        - IDE: Xcode
        - Liguagens: Swift / Objectype-C
        - Ambientes: Mac

- Multiplataforma
    - React Native:
        - SDK: Node.JS
        - IDE: VSCode, 
        - Linguagens: JavaScript / TypeScript
        - Ambientes: Mac, Win, Linux
    
    - Flutter
        - SDK: Flutter SDK
        - IDE: VSCode, Android Studio
        - Linguagens: Dart
        - Ambientes: Mac, Win, Linux

## Preparação do Ambiente de Desenvolvimento

### Instalação do FlutterSDK
- download do arquivo ZIP na página flutter.dev
- inclusão do flutter na pasta C:\src
- inclusão do flutter\bin nas varáveis de ambiente
- teste o flutter --version

### Instalação do AndroidSDK
- download do Android SDK - Command Line Tools
- adicionar o Command-line ao c:\src\AndroidSDK
- adicionar o SDKManager as Variáveis de Ambiente
- download dos pacotes
    - emulador
    - platforms
    - platform-tools
    - build-tools
- adicionar ADB e o Emulator as Variáveis de Ambiente
- Criação da Imagem do Emulador - via sdkmanager
- Build do Emulador - via sdkmanager

### Criação de Projetos e Códigos da Linha de Comando

- criação de projetos
    - flutter create nome_do_app
        - flags(parâmetros):
            - --empty : Cria um aplicativo "vazio"(hello World!)
            - --platforms : permite a seleção de uma plataforma de desenvolvimento
                - ex: --platforms=android (a criação do projeto será somente para a plataforma android)
    - exemplo de criação de uma aplicativo android vazio
        - flutter create nome_do_app --empty --platforms=android
        - obs: nome do aplicativo: todas as letras minúsculas, separação de palavras com "_";
    - flutter doctor
        - permite correção de pequenos problemas no flutter e identificação dos parâmetros funcionais em relação as plataforma de desenvolvimento
        - sempre rodar o flutter doctor no começo do desenvolvimento
    - flutter clean
        - limpa cache do build(apaga o apk anterior)
    - flutter run -v 
        - build do app (apk)

- gerenciamento de dependências do PubSpec()
    - instalação
        - flutter pub add nome_dependencia
    - baixar e instalar dependências projetadas 
        - flutter pub get
    - outros comando do flutter pub(dependências)
        - flutter pub outdated (verifica se as dependências estão desatualizadas)
        - flutter pub upgrade (atualiza as dependências do flutter pub)

