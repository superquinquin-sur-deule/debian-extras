# debian-extras

Extra package Debian repository

## Add a new package

1. Create `package/<name>.deb.src` file with URL to real .deb file
2. Use `make download` to get your local copy of .deb files
3. Execute `sh -c "(cd public/deb && sha256sum <name>*.deb)" > packages/<name>.sha256`
4. Use `make` to test the entire workflow
