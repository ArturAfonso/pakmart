
# Pakmart

**pakmart** é uma loja de aplicativos desenvolvida em Dart/Flutter para Linux, focada inicialmente na instalação e gerenciamento de apps Flatpak.

## Sobre o projeto

O objetivo do pakmart é facilitar a instalação, atualização e remoção de aplicativos Flatpak em distribuições Linux, oferecendo uma interface moderna, amigável e centralizada.

### Futuro

Há planos para expandir o suporte, permitindo o gerenciamento de outros tipos de pacotes e softwares instalados nas principais distribuições Linux, tornando o pakmart uma central universal de aplicativos.

## Tecnologias

- 100% Dart/Flutter
- Suporte inicial para Flatpak
- Foco em multiplataforma Linux Desktop

## Capturas de tela

<table>
	<tr>
		<td><img src="assets/images/screenshot%201.png" alt="Pakmart em tema claro" width="100%"></td>
		<td><img src="assets/images/Screenshot%20%202.png" alt="Pakmart em tema escuro" width="100%"></td>
	</tr>
	<tr>
		<td><img src="assets/images/Screenshot%20%203.png" alt="Pakmart na tela de categorias" width="100%"></td>
		<td><img src="assets/images/Screenshot%20%204.png" alt="Pakmart na tela de detalhes" width="100%"></td>
	</tr>
</table>

## Release Linux

Gerar a build release:

```bash
flutter build linux --release
```

O bundle Linux gerado instala a licença do projeto e os avisos de terceiros em `share/doc/pakmart/`.
Ele também instala o arquivo AppStream metainfo em `share/metainfo/`.

## Licença

O Pakmart é licenciado sob GPL-3.0-or-later.

O código-fonte do projeto, as imagens originais, os ícones e os demais assets próprios do projeto são distribuídos sob GPL-3.0-or-later.

A fonte Avrile Serif incluída em `assets/fonts/Avrile-Serif-Bold-Italic/` é distribuída sob a SIL Open Font License 1.1. Consulte `THIRD_PARTY_NOTICES.md` e `LICENSES/OFL-1.1.txt` para os detalhes.

Instalar localmente a release atual com launcher e ícone no sistema:

---
Para saber mais sobre Flutter:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

Documentação oficial: [Flutter Docs](https://docs.flutter.dev/)
