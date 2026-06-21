

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

## Screenshots

<table>
	<tr>
		<td><img src="assets/images/screenshot%201.png" alt="Pakmart in light theme" width="100%"></td>
		<td><img src="assets/images/Screenshot%20%202.png" alt="Pakmart in dark theme" width="100%"></td>
	</tr>
	<tr>
		<td><img src="assets/images/Screenshot%20%203.png" alt="Pakmart categories screen" width="100%"></td>
		<td><img src="assets/images/Screenshot%20%204.png" alt="Pakmart details screen" width="100%"></td>
	</tr>
</table>

## Linux Release

Build a release bundle:

```bash
flutter build linux --release
```

The generated Linux bundle installs the project license and third-party notices under `share/doc/pakmart/`.
It also installs the AppStream metainfo file under `share/metainfo/`.

## License

Pakmart is licensed under GPL-3.0-or-later.

The project's source code, original images, icons, and other project-owned assets are distributed under GPL-3.0-or-later.

The bundled Avrile Serif font in `assets/fonts/Avrile-Serif-Bold-Italic/` is distributed under the SIL Open Font License 1.1. See `THIRD_PARTY_NOTICES.md` and `LICENSES/OFL-1.1.txt` for details.

---
To learn more about Flutter:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

Official documentation: [Flutter Docs](https://docs.flutter.dev/)
