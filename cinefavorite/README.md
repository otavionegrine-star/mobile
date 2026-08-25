# CineFavorite

Aplicativo Flutter para pesquisar filmes e series no TMDB, salvar favoritos por usuario e atribuir avaliacoes pessoais. O projeto possui uma experiencia local de registro/login e armazena os dados no proprio dispositivo Android.

## Funcionalidades

| Funcionalidade | Como funciona |
|---|---|
| Criar conta | O usuario informa nome e senha. As credenciais sao salvas localmente no dispositivo. |
| Login | Valida o nome e a senha salvos no aparelho e abre a tela principal. |
| Buscar filmes e series | Consulta a API TMDB em tempo real usando o endpoint `search/multi`. |
| Adicionar favorito | O filme ou serie pode ser adicionado pelo icone de favorito ou tocando no resultado. |
| Listar favoritos | A aba **Favoritos** exibe os itens do usuario em uma grade com posters. |
| Avaliar | Cada favorito pode receber uma nota de 1 a 5 estrelas. |
| Remover favorito | O icone de lixeira remove o item da lista pessoal. |

## Tecnologias utilizadas

| Tecnologia | Uso no projeto |
|---|---|
| Flutter | Framework da aplicacao mobile e toolkit de interface. |
| Dart | Linguagem de programacao. |
| Android SDK / Gradle | Compilacao e execucao no Android. |
| TMDB API | Pesquisa de filmes, series, titulos, posters e notas publicas. |
| `http` | Requisicoes HTTP para a API do TMDB. |
| SQLite | Banco local para persistir favoritos e avaliacoes. |
| `sqflite` | Integracao do SQLite com Flutter. |
| `path` | Montagem multiplataforma do caminho do banco. |
| `shared_preferences` | Persistencia local de contas e usuario ativo. |

## Requisitos

| Requisito | Observacao |
|---|---|
| Flutter | Versao compativel com Dart `^3.12.1` (o ambiente usado foi Flutter 3.44.1). |
| Android SDK | API 36 e Build Tools 36.0.0 foram usados na configuracao atual. |
| Java | JDK 21 LTS e recomendado para o Gradle deste projeto. |
| Dispositivo | Um celular Android com depuracao USB ou um emulador Android. |
| Internet | Necessaria para pesquisar no TMDB e carregar posters. |

## Estrutura do projeto

```text
lib/
├── main.dart                    # Inicializacao e tema do aplicativo
├── models/movie.dart             # Modelo Movie e conversoes JSON/SQLite
├── services/tmdb_service.dart    # Integracao com a API TMDB
├── database/db_helper.dart       # Criacao e operacoes do banco SQLite
└── screens/
	├── login_screen.dart         # Registro e login local
	└── home_screen.dart          # Busca, favoritos e avaliacoes
```

## Como instalar

No PowerShell, dentro da pasta do projeto:

```powershell
flutter pub get
flutter doctor
```

Se o Flutter estiver usando um Java incompatível com o Gradle, configure um JDK 21:

```powershell
flutter config --jdk-dir="C:\caminho\para\jdk-21"
```

Aceite as licencas Android quando solicitado:

```powershell
flutter doctor --android-licenses
```

## Executar no Android

Liste os dispositivos disponiveis:

```powershell
flutter devices
```

Para iniciar o AVD usado neste ambiente:

```powershell
emulator -avd CineFavorite_Android -gpu auto
```

Depois que o emulador terminar o boot, execute:

```powershell
flutter run -d emulator-5556
```

O identificador pode mudar. Use o valor exibido por `flutter devices` no lugar de `emulator-5556`.

Para gerar somente o APK de debug:

```powershell
flutter build apk --debug
```

O arquivo sera gerado em:

```text
build/app/outputs/flutter-apk/app-debug.apk
```

## Como usar

1. Abra o aplicativo e selecione **Criar uma conta**.
2. Informe um nome e uma senha com pelo menos quatro caracteres.
3. Na aba **Buscar**, digite o nome de um filme ou serie e envie a busca.
4. Toque no resultado ou no icone de favorito para salva-lo.
5. Abra a aba **Favoritos** para visualizar sua galeria.
6. Toque em **Avaliar** e escolha de 1 a 5 estrelas.
7. Use o icone de lixeira para remover um favorito.

## Como os dados sao armazenados

| Dado | Armazenamento | Escopo |
|---|---|---|
| Contas e usuario ativo | `SharedPreferences` | Local ao dispositivo/app |
| Favoritos | SQLite (`cinefavorite.db`) | Local ao dispositivo, filtrado pelo usuario |
| Avaliacao | Coluna `rating` da tabela `favorites` | Uma nota por favorito e usuario |

A tabela de favoritos usa uma chave composta por `id` do item e `userName`. Assim, usuarios diferentes podem favoritar o mesmo filme sem substituir o registro uns dos outros. O banco esta na versao 2 e possui migracao para instalacoes anteriores.

## API do TMDB

A busca usa:

```text
GET https://api.themoviedb.org/3/search/multi
```

Os resultados sao filtrados para os tipos `movie` e `tv`, e o idioma solicitado e `pt-BR`. Os posters sao carregados a partir de `image.tmdb.org`.

> **Nota de seguranca:** a chave do TMDB atualmente esta definida em `lib/services/tmdb_service.dart`. Isso e aceitavel para um prototipo local, mas uma aplicacao publicada deve mover a chave para um backend ou outro mecanismo seguro. As senhas tambem sao armazenadas localmente neste MVP e nao devem ser tratadas como autenticacao de producao.

## Comandos uteis

| Comando | Finalidade |
|---|---|
| `flutter pub get` | Instala dependencias. |
| `flutter analyze` | Verifica erros e avisos estaticos. |
| `flutter test` | Executa testes automatizados, quando existirem. |
| `flutter clean` | Remove artefatos de build. |
| `flutter build apk --debug` | Gera APK Android de debug. |
| `flutter run -d <dispositivo>` | Executa no dispositivo escolhido. |

## Limitacoes atuais

- O registro e o login funcionam apenas localmente, sem servidor ou sincronizacao entre dispositivos.
- A chave da API esta no codigo-fonte e deve ser protegida antes de publicar o app.
- Nao ha testes automatizados implementados no momento.
- A busca depende de internet e de uma chave TMDB valida.
