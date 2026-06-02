

# Pakmart

*[Leia em português](README.pt.md)*

**pakmart** is an app store developed in Dart/Flutter for Linux, initially focused on installing and managing Flatpak apps.

## About the project

The goal of pakmart is to make it easy to install, update, and remove Flatpak applications on Linux distributions, providing a modern, user-friendly, and centralized interface.

### Future

There are plans to expand support, allowing the management of other types of packages and software installed on major Linux distributions, making pakmart a universal app center.

## Technologies

- 100% Dart/Flutter
- Initial support for Flatpak
- Focus on Linux Desktop multiplatform

## Linux Release

Build a release bundle:

```bash
flutter build linux --release
```

Install the current release locally with launcher and icon integration:

```bash
./scripts/install_linux_release.sh
```

Remove the local installation:

```bash
./scripts/uninstall_linux_release.sh
```

Generate a tar.gz artifact ready for GitHub Releases:

```bash
./scripts/package_linux_release.sh
```

The generated archive is written to `dist/` and includes:

- the Linux release bundle
- `install.sh`
- `uninstall.sh`

---
To learn more about Flutter:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

Official documentation: [Flutter Docs](https://docs.flutter.dev/)
