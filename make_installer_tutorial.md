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

## 9. Criar o arquivo .desktop do pacote

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

## 10. Criar o arquivo de controle do Debian

Crie este arquivo:

```bash
source=("$pkgname::git+https://github.com/<SEU_USUARIO>/<SEU_REPOSITORIO>.git")
```

Exemplo:

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

## 11. Ajustar permissões mínimas do pacote

```bash
chmod 755 pkg-deb/DEBIAN
chmod 644 pkg-deb/DEBIAN/control
chmod 644 pkg-deb/usr/share/applications/br.com.arturafonso.pakmart.desktop
```

## 12. Gerar o arquivo .deb

```bash
O arquivo final ficará no diretório atual.

## 13. Testar o pacote gerado

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

## 14. Conferir se o .deb não herdou caminhos da sua máquina

Se quiser validar o conteúdo do pacote sem instalar, você pode extrair em uma pasta temporária:

```bash
dpkg-deb -x pakmart_1.0.0_amd64.deb /tmp/pakmart-deb
```

Depois confira o desktop file extraído:

```bash
cat /tmp/pakmart-deb/usr/share/applications/br.com.arturafonso.pakmart.desktop
```

O esperado é algo como:

```ini
Exec=/opt/pakmart/pakmart
Icon=br.com.arturafonso.pakmart
## 15. Publicar no GitHub Releases



## Observação final

Esse processo é o mais seguro para evitar que o pacote final carregue caminhos absolutos do seu ambiente de desenvolvimento. O bundle de release do Flutter pode conter referências locais durante a geração, mas o `.deb` final deve usar apenas os caminhos de instalação do sistema, como `/opt/pakmart` e `/usr/share/...`.

---

# Pakmart: tutorial para criar release para baseados em Arch

Esta parte do guia cobre a geração do pacote para distribuições baseadas em Arch Linux, como Arch, EndeavourOS, Manjaro e derivadas.
Aqui o fluxo muda: em vez de criar um `.deb`, você vai gerar um pacote Arch com `PKGBUILD` e `makepkg`, que resulta em um arquivo `.pkg.tar.zst`.

O objetivo continua o mesmo: montar uma área limpa de empacotamento para não levar caminhos absolutos do ambiente de desenvolvimento para o pacote final.

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
license=('custom')
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

	install -Dm644 linux/runner/pakmart.desktop.in \
		"$pkgdir/usr/share/applications/br.com.arturafonso.pakmart.desktop"
}
```

Observações importantes:

- O `source` acima é só um exemplo local; você pode apontar para um clone limpo, um tarball ou um repositório remoto.
- Em pacotes finais, o arquivo `.desktop` deve ser ajustado para usar o caminho final do sistema, assim como no fluxo do Debian.
- Se você preferir, pode criar o `.desktop` diretamente dentro do `package()` em vez de copiar o template bruto.

## 8. Criar o arquivo .desktop para Arch

O conteúdo final deve ser semelhante a este:

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

O esperado é algo como:

```ini
Exec=/opt/pakmart/pakmart
Icon=br.com.arturafonso.pakmart
```

Se aparecer `/home/seu-usuario/...`, então o pacote foi montado do jeito errado.




# Pakmart: tutorial para criar release para baseados em Arch