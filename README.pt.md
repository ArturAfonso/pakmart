
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

## Release Linux

Gerar a build release:

```bash
flutter build linux --release
```

Instalar localmente a release atual com launcher e ícone no sistema:

```bash
./scripts/install_linux_release.sh
```

Remover a instalação local:

```bash
./scripts/uninstall_linux_release.sh
```

Gerar um `.tar.gz` pronto para publicar no GitHub Releases:

```bash
./scripts/package_linux_release.sh
```

O arquivo gerado sai em `dist/` e inclui:

- o bundle release para Linux
- `install.sh`
- `uninstall.sh`

---
Para saber mais sobre Flutter:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

Documentação oficial: [Flutter Docs](https://docs.flutter.dev/)
