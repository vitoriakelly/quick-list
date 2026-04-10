# QuickList

App iOS em **SwiftUI** para gerir listas de compras: várias listas com nome próprio, itens com quantidade, marcar como comprado, apagar com gesto e exportar a lista em **PDF** para partilhar.

## Requisitos

- **Xcode** 16 (ou superior recomendado)
- **iOS** 18.5+ (conforme definido no projeto)
- Conta de desenvolvedor Apple para correr em dispositivo físico (assinatura em *Signing & Capabilities*)

## Como abrir e correr

1. Abre `QuickList.xcodeproj` no Xcode.
2. Seleciona um simulador ou o teu iPhone como destino.
3. Em *Signing & Capabilities*, escolhe a tua **Team** se fores instalar no dispositivo.
4. Carrega em **Run** (⌘R).

## Funcionalidades

- **Minhas Listas**: inicial com todas as listas criadas.
- **Nova lista**: botão no fundo abre um modal para definir o nome; depois abre a lista.
- **Itens**: adicionar nome e quantidade; não é permitido item com nome vazio.
- **Marcar comprado**: toque no item para alternar riscado / não riscado.
- **Apagar item**: deslizar para a esquerda.
- **Emoji sugerido**: dicionário em `ItemEmojiMap.plist` (português) + fallback; ícone 🛒 quando não há correspondência.
- **Partilhar PDF**: gera um PDF com o nome da lista e os itens (incluindo emoji e estado comprado).
- **Persistência**: dados guardados localmente com `UserDefaults` (várias listas em `QuickList.boards.v1`). Listas antigas guardadas só com itens (`QuickList.shoppingItems`) são migradas automaticamente para uma lista chamada *Lista de Compras*.

