# Pakmart: tutorial para criar sua própria release e gerar um .deb

Este guia mostra o fluxo completo para você gerar sua própria build de release e, depois, empacotar tudo em um arquivo `.deb` para instalar em sistemas baseados em Debian/Ubuntu.

O objetivo aqui é evitar caminhos absolutos da sua máquina de desenvolvimento dentro do pacote final. A ideia é sempre montar uma área limpa de empacotamento antes de gerar o `.deb`.

## O que você vai precisar

- Linux 64 bits
- Git
- Flutter instalado e configurado no terminal
- Dependências nativas do Flutter para Linux
- `dpkg-deb` instalado para gerar o pacote `.deb`
- Um editor de código, como VS Code

## 1. Clonar o projeto

```bash
git clone <URL_DO_REPOSITORIO>
cd pakmart
```

Se você já tem o projeto aberto, apenas entre na pasta dele.

## 2. Instalar dependências do Flutter

```bash
flutter pub get
```

Se o projeto usar cache antigo ou algo estiver estranho, você pode limpar antes:

```bash
flutter clean
flutter pub get
```

## 3. Fazer sua alteração no código(se for o caso)

Se desejar,abra o projeto, edite os arquivos desejados e salve tudo.

Se a alteração afetar alguma tela, rota, texto, imagem ou ícone, o ideal é testar antes de empacotar.

## 4. Testar localmente em modo debug

Antes de gerar a release, rode o aplicativo localmente:
flutter run -d linux
```

Isso ajuda a confirmar se a alteração está funcionando sem precisar esperar o pacote final.

## 5. Gerar a build release oficial do Flutter

Esse é o artefato base que vai para o pacote Linux.

```bash
flutter build linux --release
```

Esse bundle contém o executável, as bibliotecas e os assets do app.

## 6. Criar uma área limpa para o pacote .deb

Agora vem a parte importante: não use diretamente o conteúdo de `build/linux/...` como pacote final.

Crie uma árvore separada para o Debian, por exemplo:

```bash
rm -rf pkg-deb
mkdir -p pkg-deb/DEBIAN
mkdir -p pkg-deb/opt/pakmart
mkdir -p pkg-deb/usr/share/applications
mkdir -p pkg-deb/usr/share/icons/hicolor/256x256/apps
mkdir -p pkg-deb/usr/share/doc/pakmart
mkdir -p pkg-deb/usr/share/metainfo
```

Essa pasta será a raiz do pacote Debian.

## 7. Copiar o bundle de release para /opt

Copie o conteúdo do bundle release para o diretório final do app dentro do pacote:

```bash
cp -a build/linux/x64/release/bundle/. pkg-deb/opt/pakmart/
```

Depois disso, o executável do app ficará em `/opt/pakmart/pakmart` quando o pacote for instalado.

## 8. Instalar o ícone no local correto do sistema

Use o ícone do projeto e renomeie com o Application ID do app:

```bash
cp assets/icons/logo-custom.png pkg-deb/usr/share/icons/hicolor/256x256/apps/br.com.arturafonso.pakmart.png
```

## 9. Copiar a licença e os avisos de terceiros

Copie os arquivos de licença do projeto para o pacote:

```bash
cp LICENSE pkg-deb/usr/share/doc/pakmart/
cp THIRD_PARTY_NOTICES.md pkg-deb/usr/share/doc/pakmart/
cp -r LICENSES pkg-deb/usr/share/doc/pakmart/
```

## 10. Copiar o arquivo AppStream metainfo

Copie também o arquivo AppStream do projeto para o local padrão do sistema:

```bash
cp linux/br.com.arturafonso.pakmart.metainfo.xml pkg-deb/usr/share/metainfo/
```

Se você estiver criando um fork ou personalizando este projeto, ajuste esse arquivo antes de empacotar para refletir seu próprio nome, contato, URLs e licença do projeto.

## 11. Criar o arquivo .desktop do pacote

Crie este arquivo:

```bash
pkg-deb/usr/share/applications/br.com.arturafonso.pakmart.desktop
```

Conteúdo sugerido:

```ini
[Desktop Entry]
Name=Pakmart
Comment=Explore e gerencie aplicativos Flatpak
Exec=/opt/pakmart/pakmart
Icon=br.com.arturafonso.pakmart
Terminal=false
Type=Application
Categories=Utility;
StartupNotify=true
StartupWMClass=br.com.arturafonso.pakmart
```

Observações importantes:

- `Exec` aponta para o caminho final dentro do sistema, não para a pasta do seu projeto.
- `Icon` usa o nome do arquivo instalado no tema de ícones do sistema.
- O arquivo do pacote não deve depender de caminhos absolutos da sua máquina.

## 12. Criar o arquivo de controle do Debian

Crie o arquivo `pkg-deb/DEBIAN/control` com este conteúdo:

```debcontrol
Package: pakmart
Version: 1.0.0
Section: utils
Priority: optional
Architecture: amd64
Maintainer: Artur Afonso <seu-email@exemplo.com>
Depends: libgtk-3-0, libblkid1, liblzma5, libstdc++6, libglib2.0-0, libgcc-s1
Description: Instale e gerencie aplicativos Flatpak com o Pakmart.
```

Se o seu projeto usar outra versão, ajuste o campo `Version` de acordo com o release que você quer publicar.

## 13. Ajustar permissões mínimas do pacote

```bash
chmod 755 pkg-deb/DEBIAN
chmod 644 pkg-deb/DEBIAN/control
chmod 644 pkg-deb/usr/share/applications/br.com.arturafonso.pakmart.desktop
chmod 644 pkg-deb/usr/share/metainfo/br.com.arturafonso.pakmart.metainfo.xml
find pkg-deb/usr/share/doc/pakmart -type f -exec chmod 644 {} \;
```

## 14. Gerar o arquivo .deb

```bash
dpkg-deb --build pkg-deb pakmart_1.0.0_amd64.deb
```

O arquivo final ficará no diretório atual.

## 15. Testar o pacote gerado

Antes de publicar no GitHub, teste localmente:

```bash
sudo apt install ./pakmart_1.0.0_amd64.deb
```

Depois confira:

- se o app aparece no menu do sistema
- se o ícone está correto
- se o executável abre normalmente
- se o nome exibido está como Pakmart

Para remover:

```bash
sudo apt remove pakmart
```

## 16. Conferir se o .deb não herdou caminhos da sua máquina

Se quiser validar o conteúdo do pacote sem instalar, você pode extrair em uma pasta temporária:

```bash
dpkg-deb -x pakmart_1.0.0_amd64.deb /tmp/pakmart-deb
```

Depois confira o desktop file extraído:

```bash
cat /tmp/pakmart-deb/usr/share/applications/br.com.arturafonso.pakmart.desktop
```

E confira também se os arquivos de licença foram incluídos:

```bash
find /tmp/pakmart-deb/usr/share/doc/pakmart -maxdepth 2 -type f
```

Confira ainda se o metainfo AppStream foi incluído:

```bash
ls /tmp/pakmart-deb/usr/share/metainfo/br.com.arturafonso.pakmart.metainfo.xml
```

O esperado é algo como:

```ini
Exec=/opt/pakmart/pakmart
Icon=br.com.arturafonso.pakmart
```

## 17. Publicar no GitHub Releases



## Observação final

Esse processo é o mais seguro para evitar que o pacote final carregue caminhos absolutos do seu ambiente de desenvolvimento. O bundle de release do Flutter pode conter referências locais durante a geração, mas o `.deb` final deve usar apenas os caminhos de instalação do sistema, como `/opt/pakmart` e `/usr/share/...`.

---





# Pakmart: tutorial para criar release para baseados em Arch

Esta parte do guia cobre a geração do pacote para distribuições baseadas em Arch Linux, como Arch, EndeavourOS, Manjaro e derivadas.
Aqui o fluxo muda: em vez de criar um `.deb`, você vai gerar um pacote Arch com `PKGBUILD` e `makepkg`, que resulta em um arquivo `.pkg.tar.zst`.

O objetivo continua o mesmo: montar uma área limpa de empacotamento para não levar caminhos absolutos do ambiente de desenvolvimento para o pacote final.
No caso do Arch, o ponto mais importante é não reutilizar o `.desktop` gerado pela build do Flutter sem ajuste, porque ele costuma sair com caminhos absolutos da pasta de compilação.

## O que você vai precisar

- Linux 64 bits baseado em Arch
- Git
- Flutter instalado e configurado no terminal
- Ferramentas do Arch para empacotamento, como `base-devel`
- `makepkg` disponível no sistema
- Um editor de código, como VS Code

## 1. Clonar o projeto

```bash
git clone <URL_DO_REPOSITORIO>
cd pakmart
```

Se você já tem o projeto aberto, apenas entre na pasta dele.

## 2. Instalar dependências do Flutter

```bash
flutter pub get
```

Se necessário, faça uma limpeza antes:

```bash
flutter clean
flutter pub get
```

## 3. Fazer sua alteração no código

Abra o projeto, faça a alteração desejada e salve tudo.

## 4. Testar localmente em modo debug

```bash
flutter run -d linux
```

## 5. Gerar a build release oficial do Flutter

```bash
flutter build linux --release
```

A saída principal fica em:

```bash
build/linux/x64/release/bundle
```

## 6. Criar a estrutura do pacote Arch

Crie uma pasta de trabalho separada para o pacote:

```bash
rm -rf pkg-arch
mkdir -p pkg-arch
```

Dentro dela, crie um `PKGBUILD`.

## 7. Exemplo de PKGBUILD

Crie o arquivo `pkg-arch/PKGBUILD` com um conteúdo parecido com este:

```bash
pkgname=pakmart
pkgver=1.0.0
pkgrel=1
pkgdesc="Instale e gerencie aplicativos Flatpak"
arch=('x86_64')
url='https://github.com/<SEU_USUARIO>/<SEU_REPOSITORIO>'
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
Comment=Explore e gerencie aplicativos Flatpak
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

Observações importantes:

- O campo `license=('GPL-3.0-or-later')` informa ao ecossistema Arch que o projeto usa GPL-3.0-or-later.
- O `source` acima é só um exemplo local; ele serve apenas para o `makepkg` buscar o código na hora da build e não vai parar no pacote final.
- O arquivo `.desktop` do pacote deve ser criado no `package()` com o caminho final do sistema, como no exemplo acima.
- Não copie `linux/runner/pakmart.desktop.in` direto para o pacote, porque ele é um template e não o arquivo final que o sistema vai usar.
- Instale também a licença principal em `/usr/share/licenses/pakmart/` e os avisos de terceiros em `/usr/share/doc/pakmart/`.
- Instale também o arquivo AppStream em `/usr/share/metainfo/`.
- Se você estiver adaptando este projeto para outro app, personalize o arquivo `linux/br.com.arturafonso.pakmart.metainfo.xml` antes de gerar o pacote.

## 8. Conferir o arquivo .desktop para Arch

Se você quiser manter esse arquivo separado do `PKGBUILD`, o conteúdo final deve ser semelhante a este:

```ini
[Desktop Entry]
Name=Pakmart
Comment=Explore e gerencie aplicativos Flatpak
Exec=/opt/pakmart/pakmart
Icon=br.com.arturafonso.pakmart
Terminal=false
Type=Application
Categories=Utility;
StartupNotify=true
StartupWMClass=br.com.arturafonso.pakmart
```

## 9. Gerar o pacote Arch

Entre na pasta do PKGBUILD e rode:

```bash
makepkg -sf
```

Se tudo estiver certo, o resultado será um arquivo como:

```bash
pakmart-1.0.0-1-x86_64.pkg.tar.zst
```

## 10. Testar o pacote gerado

Instale localmente:

```bash
sudo pacman -U ./pakmart-1.0.0-1-x86_64.pkg.tar.zst
```

Depois confira:

- se o app aparece no menu do sistema
- se o ícone está correto
- se o executável abre normalmente
- se o nome exibido está como Pakmart

Para remover:

```bash
sudo pacman -R pakmart
```

## 11. Conferir se o pacote não herdou caminhos da sua máquina

Você pode extrair o pacote para validar o desktop file:

```bash
mkdir -p /tmp/pakmart-arch
bsdtar -xf pakmart-1.0.0-1-x86_64.pkg.tar.zst -C /tmp/pakmart-arch
cat /tmp/pakmart-arch/usr/share/applications/br.com.arturafonso.pakmart.desktop
```

Depois confira também se os arquivos de licença foram incluídos:

```bash
find /tmp/pakmart-arch/usr/share -path '*/pakmart*' -type f
```

E confira se o arquivo AppStream foi incluído:

```bash
ls /tmp/pakmart-arch/usr/share/metainfo/br.com.arturafonso.pakmart.metainfo.xml
```

O esperado é algo como:

```ini
Exec=/opt/pakmart/pakmart
Icon=br.com.arturafonso.pakmart
```

Se aparecer `/home/seu-usuario/...`, então o pacote foi montado do jeito errado.
