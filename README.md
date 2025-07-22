# Toolkit

The following binaries are required for this to work:

  - `sha256sum`
  - `curl`
  - `tar` 

> Make sure you are at the root of the git repository when executing the following commands.

If you don't have `go` installed, you need to install it via:

```shell
make go
```

  * **[talhelper](https://github.com/budimanjojo/talhelper)** - `make talhelper`
  * **[talosctl ]()** - `make talosctl`
  * **[kubectl]()** - `make kubectl`
  * **[helm]()** - `make helm`
  * **[sops](https://github.com/getsops/sops)** - `make sops`
  * **[age](https://github.com/FiloSottile/age)** - `make age`
  * **[ejson](https://github.com/Shopify/ejson)** - `make ejson`
  * **[cilium](https://github.com/FiloSottile/age)** - `make cilium`
  * **[k9s](https://github.com/derailed/k9s)** - `make k9s`
  * **[opentofu/terraform](https://github.com/opentofu/opentofu)** - `make opentofu`
  * **[trivy](https://trivy.dev/v0.24.4/getting-started/cli/)** - `make trivy`
  * **[crane](https://github.com/google/go-containerregistry/tree/main/cmd/crane)** - `make crane`


This downloads the binaries into the `bin/` directory. To use them export the directory to your path:

```shell
export PATH="${PATH}:${PWD}/bin"
```

If you want to have these binaries permanently availble, do the following:

```shell
echo "export PATH=${PATH}:${PWD}/bin" >> ~/.bashrc
```

## Updates

Just run:

```shell
make update
```

This expects you can pull this repository without further authentication etc. This will update all your local binaries.

