# Registro de Ponto Eletrônico Mobile (`atv3`)

Aplicativo móvel desenvolvido em **Flutter** para controle e registro de ponto eletrônico de funcionários, integrando recursos nativos de hardware como **Autenticação Biométrica** e **Geolocalização (GPS)** com validação de raio de presença física.

---

## 📌 Sumário
- [Recursos e Funcionalidades](#-recursos-e-funcionalidades)
- [Tecnologias e Dependências](#-tecnologias-e-dependências)
- [Arquitetura e Clean Code](#-arquitetura-e-clean-code)
- [Estrutura de Pastas](#-estrutura-de-pastas)
- [Pré-requisitos](#-pré-requisitos)
- [Como Executar o Projeto](#-como-executar-o-projeto)
- [Guia de Uso e Testes](#-guia-de-uso-e-testes)
  - [1. Cadastro e Login](#1-cadastro-e-login)
  - [2. Autenticação Biométrica](#2-autenticação-biométrica)
  - [3. Registro de Ponto por GPS](#3-registro-de-ponto-por-gps)
- [Configuração com o Firebase](#-configuração-com-o-firebase)

---

## Recursos e Funcionalidades

### 1. Autenticação Flexível
- **Login por E-mail ou NIF**: Permite login informando um e-mail completo ou apenas o **NIF** (Número de Identificação do Funcionário). Caso seja digitado apenas o NIF (sem `@`), o sistema completa automaticamente para `@empresa.com`.
- **Tela de Cadastro**: Permite criar novas contas com validação de campos, exigência mínima de 6 caracteres na senha e confirmação de senha.
- **Biometria / Face ID**: Integração com sensor biométrico do aparelho (`local_auth`) para desbloqueio rápido de sessão.
- **Fallback Inteligente**: Suporta tanto conexão com o **Firebase Authentication** quanto modo de desenvolvimento local caso o Firebase não esteja configurado ou sem internet.

### 2. Validação Geográfica de Ponto (GPS)
- **Captura em Tempo Real**: Obtém as coordenadas geográficas exatas (`Latitude` e `Longitude`) do colaborador via GPS (`geolocator`).
- **Validação de Raio de Tolerância**: Compara a localização atual com as coordenadas da sede da empresa utilizando a fórmula de *Haversine*.
  - **Raio Máximo Permitido**: 100 metros.
  - **Fora do Raio**: O registro é recusado e informa na tela a distância exata em metros que o colaborador está do local de trabalho.
  - **Dentro do Raio**: O registro é aprovado e gravado com sucesso.

### 3. Painel e Histórico
- **Painel do Funcionário**: Exibe o identificador/e-mail da sessão atual e botão de ação direta para registrar ponto.
- **Feed em Tempo Real**: Lista os registros mais recentes com data, horário (`dd/MM/yyyy HH:mm:ss`) e coordenadas geográficas gravadas no Cloud Firestore.

---

## 🛠 Tecnologias e Dependências

| Pacote | Função |
| :--- | :--- |
| **`flutter`** | Framework base para desenvolvimento mobile multiplataforma |
| **`provider`** | Gerenciamento de estado reativo e injeção de dependências |
| **`firebase_core`** | Inicialização dos serviços Firebase |
| **`firebase_auth`** | Autenticação e gestão de usuários |
| **`cloud_firestore`** | Banco de dados NoSQL em nuvem e sincronização em tempo real |
| **`local_auth`** | Acesso ao leitor biométrico (impressão digital e reconhecimento facial) |
| **`geolocator`** | Acesso ao hardware de GPS e cálculo de distâncias geográficas |
| **`intl`** | Formatação de datas e horários |

---

##  Arquitetura e Clean Code

O projeto foi construído respeitando as melhores práticas de engenharia de software:
- **Princípio da Responsabilidade Única (SOLID)**: Divisão clara entre camadas de interface (`screens`), controle de estado (`providers`) e acesso ao hardware/nuvem (`services`).
- **Funções Curtas**: Todas as funções e métodos foram estruturados com no máximo 20 linhas de código para maximizar legibilidade e manutenibilidade.
- **Código Documentado**: Comentários e mensagens de feedback inteiramente em Português do Brasil (`pt-BR`).

---

## Estrutura de Pastas

```text
atv3/
├── android/                   # Configurações nativas Android (Manifest, Gradle, google-services)
├── lib/
│   ├── main.dart              # Ponto de entrada do app e AuthWrapper
│   ├── providers/
│   │   ├── auth_provider.dart  # Gerenciamento de login, cadastro e biometria
│   │   └── ponto_provider.dart # Fluxo de validação de GPS e gravação de ponto
│   ├── screens/
│   │   ├── login_screen.dart   # Tela de login e atalho biométrico
│   │   ├── register_screen.dart# Formulário de cadastro de novos usuários
│   │   └── home_screen.dart    # Painel de registro e histórico
│   └── services/
│       ├── biometric_service.dart # Integração nativa com sensor biométrico
│       ├── firebase_service.dart  # Conexão com FirebaseAuth e Cloud Firestore
│       └── location_service.dart  # Serviços de GPS e cálculo de raio
├── pubspec.yaml               # Dependências do projeto
└── README.md                  # Documentação completa
```

---

##  Pré-requisitos

- **Flutter SDK**: Versão 3.12.1 ou superior instalada e configurada no `PATH`.
- **Android Studio / VS Code**: Com extensões Flutter e Dart.
- **Emulador Android** (API 26+) ou dispositivo físico Android com depuração USB ativada.

---

##  Como Executar o Projeto

1. **Clone o repositório ou abra a pasta do projeto**:
   ```bash
   cd caminho/para/atv3
   ```

2. **Instale as dependências**:
   ```bash
   flutter pub get
   ```

3. **Verifique se há dispositivos conectados**:
   ```bash
   flutter devices
   ```

4. **Inicie o aplicativo no emulador ou dispositivo conectado**:
   ```bash
   flutter run
   ```
   *(Caso tenha mais de um dispositivo, especifique com `flutter run -d <id-do-dispositivo>`)*

---

##  Guia de Uso e Testes

### 1. Cadastro e Login
1. Ao abrir o aplicativo, na tela de Login clique em **"Não possui uma conta? Cadastre-se"**.
2. No campo **NIF ou E-mail**, insira seu e-mail (ex: `usuario@gmail.com`) ou apenas seu NIF (ex: `123456`).
3. Defina uma senha de pelo menos 6 caracteres e confirme a senha.
4. Clique em **CADASTRAR**. O app autenticará sua conta e redirecionará direto para o painel principal.
5. Ao fazer Logout, você pode entrar novamente digitando o mesmo NIF/e-mail e senha.

### 2. Autenticação Biométrica
1. Após efetuar o primeiro login manual, você pode utilizar o botão **"Entrar com Biometria / Face ID"**.
2. **Como testar no Emulador Android**:
   - Abra o menu lateral do emulador (`...` / *Extended Controls*).
   - Vá na aba **Fingerprint**.
   - Clique em **Touch the sensor** para simular o toque do dedo cadastrado.

### 3. Registro de Ponto por GPS
1. No painel principal (**Painel de Registro**), clique no botão azul **"BATER PONTO AGORA"**.
2. O aplicativo solicitará permissão de localização (conceda a permissão).
3. **Validação de Raio**:
   - A sede cadastrada no código fica nas coordenadas `-23.550520, -46.633309` (São Paulo).
   - Se o seu GPS estiver a mais de 100m de distância, a mensagem vermelha indicará que o ponto foi recusado com a distância exata.
   - **Para simular que você está na empresa**:
     - No menu do emulador Android (`...` > **Location**), digite:
       - **Latitude**: `-23.550520`
       - **Longitude**: `-46.633309`
     - Clique em **Save Point** ou **Set Location**.
     - Clique novamente em **"BATER PONTO AGORA"** no app. O ponto será aceito com sucesso!

---

##  Configuração com o Firebase

O projeto já possui as dependências e o plugin do Google Services configurados. Caso deseje conectar a um projeto de produção próprio no Firebase:

1. Acesse o [Firebase Console](https://console.firebase.google.com/) e crie um novo projeto.
2. Adicione um aplicativo **Android** com o pacote:
   - **Package name**: `com.example.atv3`
3. Baixe o arquivo `google-services.json` gerado.
4. Substitua o arquivo existente em:
   ```text
   android/app/google-services.json
   ```
5. No Firebase Console, ative os serviços:
   - **Authentication**: Habilite o provedor de login por **E-mail/Senha**.
   - **Firestore Database**: Crie o banco de dados e libere as regras de leitura e escrita para `registros_ponto`.

