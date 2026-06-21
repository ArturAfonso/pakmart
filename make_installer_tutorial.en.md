# Pakmart: tutorial to create your own release and generate a .deb

This guide shows the full flow for you to generate your own release build and then package everything into a `.deb` file to install on Debian/Ubuntu-based systems.

The goal here is to avoid absolute paths from your development machine inside the final package. The idea is always to build a clean packaging area before generating the `.deb`.

## What you will need

- 64-bit Linux
- Git
- Flutter installed and configured in the terminal
- Native Flutter dependencies for Linux
- `dpkg-deb` installed to generate the `.deb` package
- A code editor, such as VS Code

## 1. Clone the project

```bash
git clone <REPOSITORY_URL>
cd pakmart
```

If you already have the project open, just go into its folder.

## 2. Install Flutter dependencies

```bash
flutter pub get
```

If the project is using an old cache or something looks odd, you can clean first:

```bash
flutter clean
flutter pub get
```

## 3. Make your code change (if needed)

If you want, open the project, edit the desired files, and save everything.

If the change affects any screen, route, text, image, or icon, it is best to test it before packaging.

## 4. Test locally in debug mode

Before generating the release, run the app locally:
flutter run -d linux
```

This helps confirm whether the change is working without waiting for the final package.

## 5. Generate the official Flutter release build

This is the base artifact that will go into the Linux package.

```bash
flutter build linux --release
```

This bundle contains the executable, libraries, and app assets.

## 6. Create a clean area for the .deb package

Now comes the important part: do not use the content of `build/linux/...` directly as the final package.

Create a separate tree for Debian, for example:

```bash
rm -rf pkg-deb
mkdir -p pkg-deb/DEBIAN
mkdir -p pkg-deb/opt/pakmart
mkdir -p pkg-deb/usr/share/applications
mkdir -p pkg-deb/usr/share/icons/hicolor/256x256/apps
mkdir -p pkg-deb/usr/share/doc/pakmart
mkdir -p pkg-deb/usr/share/metainfo
```

This folder will be the root of the Debian package.

## 7. Copy the release bundle to /opt

Copy the content of the release bundle into the final app directory inside the package:

```bash
cp -a build/linux/x64/release/bundle/. pkg-deb/opt/pakmart/
```

After that, the app executable will be at `/opt/pakmart/pakmart` when the package is installed.

## 8. Install the icon in the correct system location

Use the project icon and rename it with the app's Application ID:

```bash
cp assets/icons/logo-custom.png pkg-deb/usr/share/icons/hicolor/256x256/apps/br.com.arturafonso.pakmart.png
```

## 9. Copy the license and third-party notices

Copy the project's license files into the package:

```bash
cp LICENSE pkg-deb/usr/share/doc/pakmart/
cp THIRD_PARTY_NOTICES.md pkg-deb/usr/share/doc/pakmart/
cp -r LICENSES pkg-deb/usr/share/doc/pakmart/
```

## 10. Copy the AppStream metainfo file

Also copy the project's AppStream file into the standard system location:

```bash
cp linux/br.com.arturafonso.pakmart.metainfo.xml pkg-deb/usr/share/metainfo/
```

If you are creating a fork or customizing this project, update that file before packaging so it matches your own name, contact details, URLs, and project license.

## 11. Create the package .desktop file

Create this file:

```bash
pkg-deb/usr/share/applications/br.com.arturafonso.pakmart.desktop
```

Suggested content:

```ini
[Desktop Entry]
Name=Pakmart
Comment=Explore and manage Flatpak applications
Exec=/opt/pakmart/pakmart
Icon=br.com.arturafonso.pakmart
Terminal=false
Type=Application
Categories=Utility;
StartupNotify=true
StartupWMClass=br.com.arturafonso.pakmart
```

Important notes:

- `Exec` points to the final path inside the system, not to your project folder.
- `Icon` uses the name of the file installed in the system icon theme.
- The package file must not depend on absolute paths from your machine.

## 12. Create the Debian control file

Create this file:

```bash
pkg-deb/DEBIAN/control
```

Example:

```debcontrol
Package: pakmart
Version: 1.0.0
Section: utils
Priority: optional
Architecture: amd64
Maintainer: Artur Afonso <your-email@example.com>
Depends: libgtk-3-0, libblkid1, liblzma5, libstdc++6, libglib2.0-0, libgcc-s1
Description: Install and manage Flatpak applications with Pakmart.
```

If your project uses another version, adjust the `Version` field according to the release you want to publish.

## 13. Set the minimum package permissions

```bash
chmod 755 pkg-deb/DEBIAN
chmod 644 pkg-deb/DEBIAN/control
chmod 644 pkg-deb/usr/share/applications/br.com.arturafonso.pakmart.desktop
chmod 644 pkg-deb/usr/share/metainfo/br.com.arturafonso.pakmart.metainfo.xml
find pkg-deb/usr/share/doc/pakmart -type f -exec chmod 644 {} \;
```

## 14. Generate the .deb file

```bash
dpkg-deb --build pkg-deb pakmart_1.0.0_amd64.deb
```

The final file will be in the current directory.

## 15. Test the generated package

Before publishing to GitHub, test it locally:

```bash
sudo apt install ./pakmart_1.0.0_amd64.deb
```

Then check:

- whether the app appears in the system menu
- whether the icon is correct
- whether the executable opens normally
- whether the displayed name is Pakmart

To remove it:

```bash
sudo apt remove pakmart
```

## 16. Check that the .deb did not inherit paths from your machine

If you want to validate the package content without installing it, you can extract it into a temporary folder:

```bash
dpkg-deb -x pakmart_1.0.0_amd64.deb /tmp/pakmart-deb
```

Then check the extracted desktop file:

```bash
cat /tmp/pakmart-deb/usr/share/applications/br.com.arturafonso.pakmart.desktop
```

Also check whether the license files were included:

```bash
find /tmp/pakmart-deb/usr/share/doc/pakmart -maxdepth 2 -type f
```

Also check whether the AppStream file was included:

```bash
ls /tmp/pakmart-deb/usr/share/metainfo/br.com.arturafonso.pakmart.metainfo.xml
```

The expected result is something like:

```ini
Exec=/opt/pakmart/pakmart
Icon=br.com.arturafonso.pakmart
```

If it shows `/home/your-user/...`, then the package was built the wrong way.

## 17. Publish on GitHub Releases



## Final note

This process is the safest way to avoid the final package carrying absolute paths from your development environment. The Flutter release bundle may contain local references during generation, but the final `.deb` must use only system installation paths, such as `/opt/pakmart` and `/usr/share/...`.

---

# Pakmart: tutorial to create release for Arch-based systems

This part of the guide covers generating the package for Arch Linux-based distributions, such as Arch, EndeavourOS, Manjaro, and derivatives.
Here the flow changes: instead of creating a `.deb`, you will generate an Arch package with `PKGBUILD` and `makepkg`, which results in a `.pkg.tar.zst` file.

The goal remains the same: build a clean packaging area so you do not carry absolute paths from the development machine into the final package.
For Arch specifically, the most important detail is not to reuse the `.desktop` generated by the Flutter build without adjustments, because it usually contains absolute paths from the build directory.

## What you will need

- 64-bit Arch-based Linux
- Git
- Flutter installed and configured in the terminal
- Arch packaging tools, such as `base-devel`
- `makepkg` available on the system
- A code editor, such as VS Code

## 1. Clone the project

```bash
git clone <REPOSITORY_URL>
cd pakmart
```

If you already have the project open, just go into its folder.

## 2. Install Flutter dependencies

```bash
flutter pub get
```

If needed, do a clean first:

```bash
flutter clean
flutter pub get
```

## 3. Make your code change

Open the project, make the desired change, and save everything.

## 4. Test locally in debug mode

```bash
flutter run -d linux
```

## 5. Generate the official Flutter release build

```bash
flutter build linux --release
```

The main output is located at:

```bash
build/linux/x64/release/bundle
```

## 6. Create the Arch package structure

Create a separate working folder for the package:

```bash
rm -rf pkg-arch
mkdir -p pkg-arch
```

Inside it, create a `PKGBUILD`.

## 7. PKGBUILD example

Create the file `pkg-arch/PKGBUILD` with content similar to this:

```bash
pkgname=pakmart
pkgver=1.0.0
pkgrel=1
pkgdesc="Install and manage Flatpak applications"
arch=('x86_64')
url='https://github.com/<YOUR_USERNAME>/<YOUR_REPOSITORY>'
license=('GPL-3.0-or-later')
depends=('gtk3' 'glib2' 'libblkid' 'xz' 'gcc-libs' 'hicolor-icon-theme')
makedepends=('base-devel')
source=("$pkgname::git+file:///home/art/FlutterProjects/pakmart")
sha256sums=('SKIP')

prepare() {
	cd "$srcdir/$pkgname"
	flutter pub get
}

build() {
	cd "$srcdir/$pkgname"
	flutter build linux --release
}

package() {
	cd "$srcdir/$pkgname"

	install -dm755 "$pkgdir/opt/pakmart"
	cp -a build/linux/x64/release/bundle/. "$pkgdir/opt/pakmart/"

	install -Dm644 assets/icons/logo-custom.png \
		"$pkgdir/usr/share/icons/hicolor/256x256/apps/br.com.arturafonso.pakmart.png"

	install -Dm644 LICENSE \
		"$pkgdir/usr/share/licenses/pakmart/LICENSE"

	install -Dm644 THIRD_PARTY_NOTICES.md \
		"$pkgdir/usr/share/doc/pakmart/THIRD_PARTY_NOTICES.md"

	install -Dm644 LICENSES/OFL-1.1.txt \
		"$pkgdir/usr/share/doc/pakmart/licenses/OFL-1.1.txt"

	install -Dm644 linux/br.com.arturafonso.pakmart.metainfo.xml \
		"$pkgdir/usr/share/metainfo/br.com.arturafonso.pakmart.metainfo.xml"

	cat > "$pkgdir/usr/share/applications/br.com.arturafonso.pakmart.desktop" <<'EOF'
[Desktop Entry]
Name=Pakmart
Comment=Explore and manage Flatpak applications
Exec=/opt/pakmart/pakmart
Icon=br.com.arturafonso.pakmart
Terminal=false
Type=Application
Categories=Utility;
StartupNotify=true
StartupWMClass=br.com.arturafonso.pakmart
EOF
}
```

Important notes:

- The `license=('GPL-3.0-or-later')` field tells the Arch ecosystem that the project uses GPL-3.0-or-later.
- The `source` above is just a local example; you can point it to a clean clone, a tarball, or a remote repository.
- The package `.desktop` file must be created with the final system path, just like in the Debian flow.
- Do not copy `linux/runner/pakmart.desktop.in` directly into the package, because it is a template and not the final file that the system should use.
- Install the main license under `/usr/share/licenses/pakmart/` and the third-party notices under `/usr/share/doc/pakmart/`.
- Install the AppStream file under `/usr/share/metainfo/`.
- If you are adapting this project into another app, customize `linux/br.com.arturafonso.pakmart.metainfo.xml` before generating the package.

## 8. Check the .desktop file for Arch

If you prefer to keep this file separate from the `PKGBUILD`, the final content should look like this:

```ini
[Desktop Entry]
Name=Pakmart
Comment=Explore and manage Flatpak applications
Exec=/opt/pakmart/pakmart
Icon=br.com.arturafonso.pakmart
Terminal=false
Type=Application
Categories=Utility;
StartupNotify=true
StartupWMClass=br.com.arturafonso.pakmart
```

## 9. Generate the Arch package

Go into the PKGBUILD folder and run:

```bash
makepkg -sf
```

If everything is correct, the result will be a file like:

```bash
pakmart-1.0.0-1-x86_64.pkg.tar.zst
```

## 10. Test the generated package

Install it locally:

```bash
sudo pacman -U ./pakmart-1.0.0-1-x86_64.pkg.tar.zst
```

Then check:

- whether the app appears in the system menu
- whether the icon is correct
- whether the executable opens normally
- whether the displayed name is Pakmart

To remove it:

```bash
sudo pacman -R pakmart
```

## 11. Check that the package did not inherit paths from your machine

You can extract the package to validate the desktop file:

```bash
mkdir -p /tmp/pakmart-arch
bsdtar -xf pakmart-1.0.0-1-x86_64.pkg.tar.zst -C /tmp/pakmart-arch
cat /tmp/pakmart-arch/usr/share/applications/br.com.arturafonso.pakmart.desktop
```

Then also check whether the license files were included:

```bash
find /tmp/pakmart-arch/usr/share -path '*/pakmart*' -type f
```

And check whether the AppStream file was included:

```bash
ls /tmp/pakmart-arch/usr/share/metainfo/br.com.arturafonso.pakmart.metainfo.xml
```

The expected result is something like:

```ini
Exec=/opt/pakmart/pakmart
Icon=br.com.arturafonso.pakmart
```

If it shows `/home/your-user/...`, then the package was built the wrong way.