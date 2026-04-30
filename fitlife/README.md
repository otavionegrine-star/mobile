# Fit Life - Monitor de Saúde e Atividades Físicas

O **Fit Life** é um protótipo funcional de um aplicativo mobile responsivo desenvolvido com **Flutter**. O objetivo principal do projeto é permitir que usuários acompanhem sua rotina de exercícios físicos e hábitos saudáveis através de uma interface moderna e intuitiva.

## Funcionalidades

- **Tela de Entrada Personalizada**: Login simulado com persistência de nome de usuário durante a sessão.
- **Registro de Atividades**: Lista interativa para marcar exercícios como concluídos (Caminhada, Corrida, Musculação e Yoga).
- **Dashboard de Desempenho**: Visualização em tempo real de indicadores como:
    - Total de atividades concluídas.
    - Atividades pendentes.
    - Estimativa de calorias queimadas.
    - Progresso percentual da meta semanal.
- **Configurações Dinâmicas**: 
    - Alternância entre Tema Claro e Tema Escuro (Dark Mode).
    - Edição do perfil do usuário.
- **Navegação Fluida**: Implementada via `NavigationBar` e controle de estado centralizado.

## Tecnologias e Conceitos Utilizados

- **Linguagem**: Dart
- **Framework**: Flutter (Material 3)
- **Gerenciamento de Estado**: [Provider]
- **Widgets de Estrutura**:
    - `Scaffold`, `AppBar`, `NavigationBar` (Navegação inferior).
    - `ListView.builder` para listas dinâmicas.
    - `GridView` para o painel de métricas responsivo.
    - `TabBarView` (implícito na estrutura de abas).
    - `Card`, `SwitchListTile`, `TextField`.

## Estrutura do Projeto

A organização segue as boas práticas de separação de responsabilidades:

```text
lib/
├── models/
│   └── atividade.dart          # Definição da classe Atividade
├── providers/
│   ├── atividade_provider.dart # Lógica de negócios das atividades e métricas
│   └── settings_provider.dart  # Lógica de configurações e tema
├── screens/
│   ├── atividades_screen.dart  # Lista de tarefas físicas
│   ├── dashboard_screen.dart   # Painel de indicadores (GridView)
│   ├── home_screen.dart        # Tela inicial com login
│   ├── main_navigation.dart    # Estrutura de navegação principal
│   └── settings_screen.dart    # Ajustes de usuário e tema
└── main.dart                   # Inicialização do app e MultiProvider