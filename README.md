# API GITHUB FLUTTER <img src="https://skillicons.dev/icons?i=flutter,dart,github" alt="Flutter, Dart & GitHub Icons" style="vertical-align: middle; height: 35px;"/>


## 1. Visão Geral

O projeto **API GitHub Flutter** é uma aplicação desenvolvida em Flutter que permite a interação com a API REST do GitHub, oferecendo funcionalidades como listar, criar e buscar repositórios. Esta solução tem como objetivo explorar os conceitos de integração de APIs, gerenciamento seguro de dados e design moderno e responsivo.

## 2. Funcionalidades

Abaixo estão listadas as principais funcionalidades do projeto:

| Funcionalidade               | Descrição                                                                               |
| ---------------------------- | --------------------------------------------------------------------------------------- |
| **Login Seguro**             | Gerenciamento seguro do token do usuário usando Flutter Secure Storage                  |
| **Listagem de Repositórios** | Exibição dos repositórios do usuário autenticado e de outros usuários do GitHub         |
| **Busca de Usuários**        | Interface para pesquisar repositórios de outros usuários pelo nome de usuário do GitHub |
| **Criação de Repositórios**  | Integração com a API do GitHub para criar novos repositórios                            |
| **Tela de Splash**           | Tela inicial animada para uma transição fluida ao aplicativo                            |
| **Design Responsivo**        | Layout adaptável a diferentes dispositivos                                              |

## 3. Tecnologias Utilizadas

- **Linguagens**: [Dart](https://dart.dev/)
- **Framework**: [Flutter](https://flutter.dev/)
- **Bibliotecas Principais**:
  - [HTTP](https://pub.dev/packages/http): Requisições à API do GitHub
  - [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage): Armazenamento seguro de dados
  - [Google Fonts](https://pub.dev/packages/google_fonts): Fontes personalizadas
  - [Shimmer](https://pub.dev/packages/shimmer): Feedback visual durante carregamento
  - [Device Preview](https://pub.dev/packages/device_preview): Simulação de dispositivos

## 4. Links para Recursos Adicionais

- **Documentação da API do GitHub**: [REST API Docs](https://docs.github.com/en/rest?apiVersion=2022-11-28)
- **Flutter**: [Documentação Oficial](https://flutter.dev/docs)
- **Dart**: [Dart Dev](https://dart.dev/guides)
- **Material Design**: [Material.io](https://material.io)
- **Pub.dev**: [Pacotes Flutter](https://pub.dev)

## 5. Configuração e Execução

Siga os passos abaixo para configurar e executar o projeto localmente:

### 5.1. Pré-requisitos
 
- Flutter SDK ≥ 3.0.0
- Dart SDK ≥ 3.0.0
- Editor de código (VS Code ou Android Studio)
- Git instalado

### 5.2. Clonar o Repositório

```bash
git clone git@github.com:FelipeTiLustosa/api_github-flutter.git
cd api_github-flutter
```

### 5.3. Configurar e Executar

```bash
flutter pub get
flutter run
```

## 6. Contribuição

Contribuições são bem-vindas! Para contribuir com o projeto, siga estas etapas:

1. Faça um fork do repositório
2. Crie uma branch para sua feature
3. Realize as alterações e teste
4. Envie um pull request para revisão

## 7. Estrutura de Pastas

```bash
api_github-flutter/
├── lib/
│   ├── models/
│   │   └── repository.dart          # Classe modelo para representar repositórios
│   ├── screens/
│   │   ├── splash_screen.dart       # Tela de splash inicial
│   │   ├── home_screen.dart         # Tela de listagem de repositórios
│   │   ├── create_repo_screen.dart  # Tela para criar novos repositórios
│   │   └── user_search_screen.dart  # Tela para buscar repositórios por usuário
│   ├── services/
│   │   └── github_service.dart      # Classe de serviço para interação com a API do GitHub
│   ├── widgets/
│   │   └── main_drawer.dart         # Menu lateral principal
│   └── main.dart                    # Arquivo principal
├── pubspec.yaml                     # Arquivo de configuração do projeto Flutter
```

## 8. Imagens do Projeto

<p align="center">
  <img src="https://github.com/user-attachments/assets/9837e83c-0e4f-4902-93d8-cd8b071c76f1" alt="Captura de tela 2025-02-26 235531" width="300" style="margin-right:10px;">
  <img src="https://github.com/user-attachments/assets/c923ae3d-7dcb-4414-bcd0-165a09f938df" alt="Captura de tela 2025-02-26 235603" width="305">
</p>




## 8. Link do vídeo explicativo sobre o projeto

[Link do vídeo demonstrativo](https://youtu.be/a6SSw6kvukw?si=uR3zhW79hlxwzJBE)

