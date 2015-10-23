pkgname=guntalina
pkgver=autogenerated
pkgrel=1
pkgdesc="utility for creating and executing command list"
arch=('i686' 'x86_64')
license=('GPL')
makedepends=('go' 'git')

source=(
    "guntalina::git+ssh://git.rn/devops/guntalina"
)

md5sums=(
    'SKIP'
)

backup=(
    'etc/guntalina/guntalina.conf'
)

pkgver() {
    cd "$srcdir/$pkgname"
    local date=$(git log -1 --format="%cd" --date=short | sed s/-//g)
    local count=$(git rev-list --count HEAD)
    local commit=$(git rev-parse --short HEAD)
    echo "$date.${count}_$commit"
}

build() {
    cd "$srcdir/$pkgname"

    if [ -L "$srcdir/$pkgname" ]; then
        rm "$srcdir/$pkgname" -rf
        mv "$srcdir/.go/src/$pkgname/" "$srcdir/$pkgname"
    fi

    rm -rf "$srcdir/.go/src"

    mkdir -p "$srcdir/.go/src"

    export GOPATH="$srcdir/.go"

    mv "$srcdir/$pkgname" "$srcdir/.go/src/"

    cd "$srcdir/.go/src/$pkgname/"
    ln -sf "$srcdir/.go/src/$pkgname/" "$srcdir/$pkgname"

    git submodule init
    git submodule update

    GO15VENDOREXPERIMENT=1 go get -v -ldflags "-X main.version=$pkgver"
}

package() {
    install -DT "$srcdir/.go/bin/$pkgname" "$pkgdir/usr/bin/$pkgname"
    install -DT "$srcdir/../guntalina.conf" "$pkgdir/etc/guntalina/guntalina.conf"
    mkdir -p "$pkgdir/etc/guntalina/conf.d/"
}
