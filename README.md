# Sistema de Gerenciamento de Biblioteca em Dart

Sistema de gerenciamento de biblioteca desenvolvido em Dart para a disciplina de Programação para Dispositivos Móveis. O projeto utiliza uma estrutura modular para organizar o cadastro de usuários, livros, exemplares, empréstimos, reservas e relatórios.

---

## Sumário

- [Visão Geral](#visão-geral)
- [Funcionalidades Principais](#funcionalidades-principais)
- [Estrutura de Pastas](#estrutura-de-pastas)
- [Pré-requisitos](#pré-requisitos)
- [Como Executar](#como-executar)
- [Tecnologias Utilizadas](#tecnologias-utilizadas)
- [Autor](#autor)

---

## Visão Geral

O sistema foi desenvolvido para representar as principais operações de uma biblioteca, permitindo o gerenciamento do acervo e dos usuários, além do controle de empréstimos, devoluções, reservas e geração de relatórios.

A aplicação foi organizada em diferentes módulos, separando os modelos de dados, os serviços responsáveis pelas operações do sistema e os tipos de usuários.

---

## Funcionalidades Principais

### Gestão de Usuários

- Cadastro de usuários.
- Controle dos diferentes tipos de usuários.
- Identificação do perfil do usuário por meio do `tipo_usuario.dart`.

### Gestão do Acervo

- Cadastro de livros.
- Cadastro e controle de exemplares físicos.
- Associação entre livros e seus respectivos exemplares.

### Gestão de Empréstimos

- Registro de empréstimos.
- Controle das datas de empréstimo e devolução.
- Registro da devolução de exemplares.

### Gestão de Reservas

- Registro de reservas.
- Controle da fila de reservas.
- Gerenciamento das reservas de exemplares.

### Relatórios

- Geração de relatórios relacionados aos dados e operações da biblioteca.

---

## Estrutura de Pastas

A estrutura do projeto está organizada da seguinte forma:

```text
Sistema_Biblioteca_Dart/
├── dados/
│   ├── emprestimos.json
│   ├── exemplares.json
│   ├── livros.json
│   ├── reservas.json
│   └── usuarios.json
│
├── enums/
│   └── tipo_usuario.dart
│
├── models/
│   ├── Emprestimo.dart
│   ├── Exemplar.dart
│   ├── Livro.dart
│   ├── Reserva.dart
│   └── Usuario.dart
│
├── services/
│   ├── emprestimo_service.dart
│   ├── exemplar_service.dart
│   ├── livro_service.dart
│   ├── politica_emprestimo_service.dart
│   ├── relatorio_service.dart
│   ├── reserva_service.dart
│   ├── storage_service.dart
│   └── usuario_service.dart
│
├── main.dart
├── pubspec.lock
├── pubspec.yaml
└── README.md
```

### Organização dos diretórios

- **`main.dart`**: ponto de entrada da aplicação.
- **`enums/`**: contém os tipos enumerados utilizados pelo sistema.
- **`models/`**: contém as classes que representam as principais entidades da biblioteca.
- **`services/`**: contém as classes responsáveis pelas operações e regras de gerenciamento do sistema.

---

## Pré-requisitos

Para executar o projeto, é necessário ter o **Dart SDK** instalado na máquina.

Para verificar se o Dart está instalado, execute:

```bash
dart --version
```

---

## Como Executar

1. Abra o terminal.

2. Acesse o diretório raiz do projeto:

```bash
cd Sistema_Biblioteca_Dart
```
3. Instale as dependências do projeto:

```bash
dart pub get
```

4. Execute a aplicação com o comando:

```bash
dart run main.dart
```

---

## Tecnologias Utilizadas

- Dart
- Programação Orientada a Objetos
- Estrutura modular de projeto
- Terminal/Console para interação com o usuário

## Autor
- **Breno de Souza Guedes**
