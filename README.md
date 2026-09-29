# Sistema de Gerenciamento de Biblioteca em Dart

Sistema de gerenciamento de biblioteca desenvolvido em Dart para a disciplina de Programação para Dispositivos Móveis. A aplicação funciona em terminal e utiliza arquivos JSON para persistir usuários, livros, exemplares, empréstimos e reservas.

---

## Sumário

- [Visão geral](#visão-geral)
- [Funcionalidades](#funcionalidades)
- [Menu principal](#menu-principal)
- [Entidades e arquivos JSON](#entidades-e-arquivos-json)
- [Regras de negócio](#regras-de-negócio)
  - [Usuários](#usuários)
  - [Livros e títulos](#livros-e-títulos)
  - [Exemplares](#exemplares)
  - [Empréstimos](#empréstimos)
  - [Devoluções, multas e ocorrências](#devoluções-multas-e-ocorrências)
  - [Reservas](#reservas)
  - [Pendências financeiras](#pendências-financeiras)
  - [Relatórios](#relatórios)
- [Formato dos dados JSON](#formato-dos-dados-json)
- [Estrutura de pastas](#estrutura-de-pastas)
- [Pré-requisitos](#pré-requisitos)
- [Como executar](#como-executar)
- [Tecnologias utilizadas](#tecnologias-utilizadas)
- [Autor](#autor)

---

## Visão geral

O sistema representa as principais operações de uma biblioteca, permitindo:

- gerenciamento de usuários;
- gerenciamento de títulos do acervo;
- controle de exemplares físicos;
- realização e devolução de empréstimos;
- controle de atrasos, multas e ressarcimentos;
- registro e cancelamento de reservas;
- controle de pendências financeiras;
- geração de relatórios do acervo, empréstimos e reservas.

A aplicação é organizada em modelos, serviços, enumerações e arquivos JSON. Os dados são carregados no início da execução e salvos automaticamente após as operações de alteração e ao encerrar o sistema.

---

## Funcionalidades

### Gestão de usuários

- Cadastrar usuário.
- Listar usuários.
- Alterar nome e tipo de usuário.
- Consultar usuário por ID.
- Remover usuário.
- Listar usuários bloqueados.
- Registrar pagamento de pendência financeira.

### Gestão do acervo

- Cadastrar título de livro.
- Listar títulos cadastrados.
- Alterar título, autor, categoria e natureza.
- Consultar título por ID.
- Baixar/remover título.

### Gestão de exemplares

- Cadastrar exemplar físico associado a um título.
- Listar exemplares.
- Alterar disponibilidade de exemplar.
- Consultar exemplar por ID.
- Consultar exemplar disponível por título.
- Baixar/remover exemplar.

### Gestão de empréstimos

- Realizar empréstimo.
- Registrar devolução.
- Listar empréstimos.
- Consultar empréstimo por ID.
- Consultar empréstimos ativos de um usuário.
- Identificar empréstimos atrasados.
- Calcular multas e ressarcimentos durante a devolução.

### Gestão de reservas

- Reservar título indisponível.
- Listar fila de reservas.
- Consultar reserva por ID.
- Cancelar reserva.
- Remover automaticamente a reserva do usuário quando ele realiza o empréstimo do título reservado.

### Relatórios

- Relatório de livros e exemplares.
- Relatório de empréstimos.
- Relatório de reservas.
- Resumo geral do sistema.

---

## Menu principal

Ao executar o sistema, são exibidas as seguintes opções:

```text
1. Usuários
2. Títulos / Acervo
3. Exemplares
4. Empréstimos
5. Reservas
6. Pendências financeiras
7. Relatórios
0. Sair
```

Todas as operações de cadastro, alteração e remoção são realizadas pelo terminal. Os dados alterados são persistidos nos arquivos da pasta `dados/`.

---

## Entidades e arquivos JSON

O sistema utiliza cinco arquivos JSON, todos contendo uma lista de objetos:

| Entidade | Arquivo | Descrição |
|---|---|---|
| Usuário | `dados/usuarios.json` | Pessoas que podem utilizar a biblioteca |
| Livro | `dados/livros.json` | Títulos do acervo |
| Exemplar | `dados/exemplares.json` | Cópias físicas dos títulos |
| Empréstimo | `dados/emprestimos.json` | Registros de retirada e devolução |
| Reserva | `dados/reservas.json` | Reservas de títulos indisponíveis |

Os nomes dos campos devem ser mantidos exatamente como definidos nos exemplos, pois são utilizados pelos métodos `fromJson` e `toJson`.

---

## Regras de negócio

### Usuários

Cada usuário possui:

- `id`: identificador inteiro;
- `nome`: nome do usuário;
- `tipo`: tipo de vínculo com a biblioteca;
- `pendenciaFinanceira`: valor total pendente.

Tipos de usuário aceitos:

- `Aluno`;
- `Professor`;
- `Comunidade`.

Regras e validações:

- O ID do usuário deve ser informado como número inteiro positivo.
- Não é permitido cadastrar dois usuários com o mesmo ID.
- O nome é obrigatório.
- O tipo deve ser um dos três valores aceitos.
- Usuário com `pendenciaFinanceira > 0` é considerado **bloqueado**.
- Usuário bloqueado não pode realizar novos empréstimos.
- Não é possível remover um usuário que possua empréstimo ativo.
- A alteração de usuário modifica o nome e o tipo, mantendo sua pendência financeira.
- O pagamento deve ser maior que zero e não pode ultrapassar o valor da pendência existente.

A propriedade `bloqueado` é calculada pelo sistema e não deve ser gravada no JSON. Ela é verdadeira quando:

```text
pendenciaFinanceira > 0
```

---

### Livros e títulos

Cada título possui:

- `id`: identificador inteiro;
- `titulo`: nome da obra;
- `autor`: autor ou responsável pela publicação;
- `categoria`: categoria temática;
- `natureza`: tipo do material.

Naturezas aceitas:

- `Livro`;
- `Periódico`;
- `Referência`.

Regras e validações:

- O ID do título deve ser um número inteiro positivo.
- Não é permitido cadastrar dois títulos com o mesmo ID.
- Título, autor, categoria e natureza são obrigatórios no cadastro pelo terminal.
- A natureza deve ser `Livro`, `Periódico` ou `Referência`.
- Não é possível remover um título que ainda possua exemplares associados.
- Não é possível remover um título que ainda possua reservas.
- Para remover um título, primeiro é necessário remover seus exemplares e cancelar suas reservas.

A natureza do título influencia o limite de empréstimos, o prazo de devolução, a multa e o ressarcimento.

---

### Exemplares

Cada exemplar possui:

- `id`: identificador inteiro do exemplar;
- `livroId`: ID do título ao qual pertence;
- `disponivel`: indica se pode ser emprestado.

Regras e validações:

- O ID do exemplar deve ser um número inteiro positivo.
- Não é permitido cadastrar dois exemplares com o mesmo ID.
- O `livroId` deve corresponder a um título existente.
- Um exemplar recém-cadastrado é criado como disponível.
- Exemplar disponível pode ser usado em um novo empréstimo.
- Exemplar indisponível não pode ser emprestado.
- É possível alterar manualmente a disponibilidade do exemplar.
- Não é possível remover exemplar que esteja vinculado a um empréstimo ativo.
- Exemplar danificado ou perdido permanece indisponível após a devolução.
- Um exemplar devolvido em bom estado volta a ficar disponível.

---

### Empréstimos

Cada empréstimo possui:

- `id`: identificador do empréstimo;
- `usuarioId`: usuário responsável;
- `exemplarId`: exemplar emprestado;
- `dataEmprestimo`: data e hora da retirada;
- `dataPrevistaDevolucao`: prazo calculado pelo sistema;
- `dataDevolucao`: data real da devolução, ou `null` enquanto ativo;
- `multa`: valor da multa;
- `ressarcimento`: valor do ressarcimento;
- `ocorrencia`: situação do exemplar na devolução.

Um empréstimo é considerado **ativo** quando:

```text
dataDevolucao == null
```

Para realizar um empréstimo, o sistema valida:

1. O ID do empréstimo não pode estar cadastrado.
2. O usuário deve existir.
3. O título deve existir.
4. O usuário não pode estar bloqueado por pendência financeira.
5. O usuário não pode possuir empréstimo ativo atrasado.
6. O usuário não pode ter atingido seu limite de empréstimos.
7. Deve existir exemplar disponível para o título.
8. Não pode existir reserva pendente para outro usuário para o mesmo título.

Quando o empréstimo é realizado:

- um exemplar disponível é selecionado;
- o exemplar passa a ficar indisponível;
- a data prevista de devolução é calculada conforme o tipo de usuário e a natureza do título;
- se o usuário possuir reserva para o título, essa reserva é removida.

#### Limites e prazos

| Tipo de usuário | Limite padrão de empréstimos | Prazo padrão |
|---|---:|---:|
| Aluno | 3 exemplares | 14 dias |
| Professor | 5 exemplares | 21 dias |
| Comunidade | 2 exemplares | 7 dias |

Exceções por natureza do material:

- Título de natureza `Referência`:
  - limite de 1 exemplar;
  - prazo de 1 dia, independentemente do tipo de usuário.
- Título de natureza `Periódico`:
  - prazo de 3 dias;
  - o limite padrão do tipo de usuário continua sendo aplicado.

---

### Devoluções, multas e ocorrências

A devolução só pode ser registrada para um empréstimo existente e ainda ativo.

Durante a devolução, o sistema:

1. calcula se houve atraso;
2. calcula a multa diária conforme a natureza do título;
3. solicita a situação do exemplar;
4. calcula eventual ressarcimento;
5. registra a data da devolução;
6. adiciona multa e ressarcimento à pendência do usuário;
7. atualiza a disponibilidade do exemplar.

Ocorrências aceitas:

- `null`: exemplar devolvido em bom estado;
- `Danificado`: exemplar danificado;
- `Perdido`: exemplar perdido.

#### Multa diária

| Natureza do título | Multa diária |
|---|---:|
| Livro | R$ 1,00 |
| Periódico | R$ 1,50 |
| Referência | R$ 3,00 |

A multa é calculada apenas quando a data prevista de devolução já passou:

```text
multa = quantidade_de_dias_de_atraso × multa_diária
```

#### Ressarcimento

| Natureza do título | Ressarcimento |
|---|---:|
| Livro | R$ 50,00 |
| Periódico | R$ 30,00 |
| Referência | R$ 80,00 |

O ressarcimento é aplicado quando a ocorrência é `Danificado` ou `Perdido`.

Depois da devolução:

- sem ocorrência, o exemplar fica disponível;
- com ocorrência, o exemplar fica indisponível;
- multa e ressarcimento são somados à pendência financeira do usuário;
- se o total for maior que zero, o usuário fica bloqueado.

---

### Reservas

Cada reserva possui:

- `id`: identificador da reserva;
- `usuarioId`: usuário que reservou;
- `livroId`: título reservado;
- `dataReserva`: data e hora da reserva.

Para cadastrar uma reserva, o sistema valida:

1. O usuário deve existir.
2. O título deve existir.
3. O título não pode possuir exemplar disponível.
4. O usuário não pode possuir outra reserva para o mesmo título.
5. O ID da reserva não pode estar cadastrado.

A reserva representa uma fila para um título indisponível. Quando um usuário com reserva realiza o empréstimo do título, a reserva dele é removida automaticamente.

Operações disponíveis:

- cadastrar reserva;
- listar reservas;
- consultar reserva por ID;
- cancelar reserva;
- remover reserva.

Para excluir um título, todas as reservas associadas devem ser canceladas ou removidas antes.

---

### Pendências financeiras

O sistema possui um menu específico para pendências financeiras com as opções:

- listar usuários bloqueados;
- registrar pagamento.

A pendência pode ser gerada por:

- multa por atraso;
- ressarcimento de exemplar danificado;
- ressarcimento de exemplar perdido;
- inclusão manual por meio do serviço de usuários.

Quando a pendência é maior que zero, o usuário fica bloqueado para novos empréstimos. Após a quitação total, a pendência retorna a zero e o usuário deixa de estar bloqueado.

---

### Relatórios

#### Relatório de livros

Informa:

- total de títulos cadastrados;
- total de exemplares cadastrados;
- quantidade de exemplares disponíveis;
- quantidade de exemplares emprestados ou indisponíveis.

#### Relatório de empréstimos

Informa:

- total de empréstimos;
- quantidade de empréstimos ativos;
- quantidade de empréstimos atrasados;
- quantidade de empréstimos devolvidos.

Um empréstimo atrasado é aquele que está ativo e cuja `dataPrevistaDevolucao` é anterior à data de referência.

#### Relatório de reservas

Informa o total de reservas cadastradas.

#### Resumo

Combina o relatório de livros, o relatório de empréstimos e o relatório de reservas.

---

## Formato dos dados JSON

Todos os arquivos da pasta `dados/` devem conter uma lista JSON, mesmo quando não houver registros:

```json
[]
```

### Exemplo de `usuarios.json`

```json
[
  {
    "id": 1,
    "nome": "Ana Souza",
    "tipo": "Aluno",
    "pendenciaFinanceira": 0.0
  }
]
```

### Exemplo de `livros.json`

```json
[
  {
    "id": 101,
    "titulo": "Dart em Prática",
    "autor": "Marcos Ribeiro",
    "categoria": "Programação",
    "natureza": "Livro"
  }
]
```

### Exemplo de `exemplares.json`

```json
[
  {
    "id": 1001,
    "livroId": 101,
    "disponivel": true
  }
]
```

### Exemplo de `emprestimos.json`

```json
[
  {
    "id": 2001,
    "usuarioId": 1,
    "exemplarId": 1001,
    "dataEmprestimo": "2026-09-29T10:00:00.000Z",
    "dataPrevistaDevolucao": "2026-10-13T10:00:00.000Z",
    "dataDevolucao": null,
    "multa": 0.0,
    "ressarcimento": 0.0,
    "ocorrencia": null
  }
]
```

### Exemplo de `reservas.json`

```json
[
  {
    "id": 3001,
    "usuarioId": 1,
    "livroId": 102,
    "dataReserva": "2026-09-29T10:00:00.000Z"
  }
]
```

#### Datas

As datas devem ser armazenadas no formato ISO 8601, por exemplo:

```text
2026-09-29T10:00:00.000Z
```

Para empréstimo ativo, use:

```json
"dataDevolucao": null
```

Para empréstimo devolvido, informe uma data ISO 8601:

```json
"dataDevolucao": "2026-10-05T10:00:00.000Z"
```

#### Integridade dos relacionamentos

Os IDs relacionados devem existir nos arquivos correspondentes:

- `exemplares.livroId` deve existir em `livros.json`;
- `emprestimos.usuarioId` deve existir em `usuarios.json`;
- `emprestimos.exemplarId` deve existir em `exemplares.json`;
- `reservas.usuarioId` deve existir em `usuarios.json`;
- `reservas.livroId` deve existir em `livros.json`.

---

## Estrutura de pastas

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

- **`main.dart`**: ponto de entrada e menus da aplicação.
- **`dados/`**: arquivos JSON utilizados como armazenamento local.
- **`enums/`**: enumeração relacionada aos tipos de usuário.
- **`models/`**: classes que representam as entidades do sistema.
- **`services/`**: regras de negócio, persistência e relatórios.

---

## Pré-requisitos

É necessário ter o **Dart SDK** instalado.

Para verificar a instalação:

```bash
dart --version
```

---

## Como executar

1. Abra um terminal.
2. Acesse a pasta raiz do projeto:

```bash
cd Sistema_Biblioteca_Dart
```

3. Instale as dependências:

```bash
dart pub get
```

4. Execute o sistema:

```bash
dart run main.dart
```

Ao sair pelo menu principal, o sistema salva os dados nos arquivos JSON da pasta `dados/`.

---

## Tecnologias utilizadas

- Dart;
- Programação Orientada a Objetos;
- Arquivos JSON para persistência;
- Aplicação de terminal/console;
- Biblioteca `tint` para estilização das mensagens no terminal.

---

## Autor

- **Breno de Souza Guedes**
