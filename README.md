# Kpack

![Test Workflow](https://github.com/kadras-io/package-for-kpack/actions/workflows/test.yml/badge.svg)
![Release Workflow](https://github.com/kadras-io/package-for-kpack/actions/workflows/release.yml/badge.svg)
[![The SLSA Level 3 badge](https://slsa.dev/images/gh-badge-level3.svg)](https://slsa.dev/spec/v0.1/levels)
[![The Apache 2.0 license badge](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Follow us on Twitter](https://img.shields.io/static/v1?label=Twitter&message=Follow&color=1DA1F2)](https://twitter.com/kadrasIO)

A Carvel package for [kpack](https://github.com/pivotal/kpack), a Kubernetes-native implementation of Cloud Native Buildpacks to build OCI images from within the cluster.

## 🚀&nbsp; Getting Started

### Prerequisites

* Kubernetes 1.25+
* Carvel [`kctrl`](https://carvel.dev/kapp-controller/docs/latest/install/#installing-kapp-controller-cli-kctrl) CLI.
* Carvel [kapp-controller](https://carvel.dev/kapp-controller) deployed in your Kubernetes cluster. You can install it with Carvel [`kapp`](https://carvel.dev/kapp/docs/latest/install) (recommended choice) or `kubectl`.

  ```shell
  kapp deploy -a kapp-controller -y \
    -f https://github.com/carvel-dev/kapp-controller/releases/latest/download/release.yml
  ```

### Installation

Add the Kadras [package repository](https://github.com/kadras-io/kadras-packages) to your Kubernetes cluster:

  ```shell
  kctrl package repository add -r kadras-packages \
    --url ghcr.io/kadras-io/kadras-packages \
    -n kadras-packages --create-namespace
  ```

<details><summary>Installation without package repository</summary>
The recommended way of installing the kpack package is via the Kadras <a href="https://github.com/kadras-io/kadras-packages">package repository</a>. If you prefer not using the repository, you can add the package definition directly using <a href="https://carvel.dev/kapp/docs/latest/install"><code>kapp</code></a> or <code>kubectl</code>.

  ```shell
  kubectl create namespace kadras-packages
  kapp deploy -a kpack-package -n kadras-packages -y \
    -f https://github.com/kadras-io/package-for-kpack/releases/latest/download/metadata.yml \
    -f https://github.com/kadras-io/package-for-kpack/releases/latest/download/package.yml
  ```
</details>

Install the kpack package:

  ```shell
  kctrl package install -i kpack \
    -p kpack.packages.kadras.io \
    -v ${VERSION} \
    -n kadras-packages
  ```

> **Note**
> You can find the `${VERSION}` value by retrieving the list of package versions available in the Kadras package repository installed on your cluster.
> 
>   ```shell
>   kctrl package available list -p kpack.packages.kadras.io -n kadras-packages
>   ```

Verify the installed packages and their status:

  ```shell
  kctrl package installed list -n kadras-packages
  ```

## 📙&nbsp; Documentation

Documentation, tutorials and examples for this package are available in the [docs](docs) folder.
For documentation specific to kpack, check out [github.com/pivotal/kpack](https://github.com/pivotal/kpack).

## 🎯&nbsp; Configuration

The kpack package can be customized via a `values.yml` file.

  ```yaml
  kp_default_repository:
    name: ghcr.io/thomasvitale/buildpacks
    credentials:
      username: "jon.snow"
      password: "youknownothing"
  ```

Reference the `values.yml` file from the `kctrl` command when installing or upgrading the package.

  ```shell
  kctrl package install -i kpack \
    -p kpack.packages.kadras.io \
    -v ${VERSION} \
    -n kadras-packages \
    --values-file values.yml
  ```

### Values

The kpack package has the following configurable properties.

<details><summary>Configurable properties</summary>

| Config | Default | Description |
|-------|-------------------|-------------|
| `ca_cert_data` | `""` | PEM-encoded certificate data that kpack controller will use to trust TLS connections based on a custom CA with a container registry. Note: This will not be injected into builds, you need to use the cert injection webhook with the `kpack.io/build` label value. |

Settings for the default container repository used by kpack.

| Config | Default | Description |
|-------|-------------------|-------------|
| `kp_default_repository.name` | `""` | The default repository to use for builder images and dependencies. For example, GitHub Container Registry: `ghcr.io/my-org/buildpacks`; GCR: `gcr.io/my-project/buildpacks`; Harbor: `myharbor.io/my-project/buildpacks`, Dockerhub: `docker.io/my-username/buildpacks`.|
| `kp_default_repository.credentials.username` | `""` | Username to access the default container repository. Note: Use `_json_key` for GCR. |
| `kp_default_repository.credentials.password` | `""` | Token to access the default container repository. Note: Use contents of service account key json for GCR. |
| `kp_default_repository.secret.name` | `""` | The name of the Secret holding the credentials to access the default container repository. |
| `kp_default_repository.secret.namespace` | `""` | The namespace of the Secret holding the credentials to access the default container repository. |
| `kp_default_repository.secret.create_export` | `false` | Whether to create a SecretExport resource to export the Secret from the source namespace to the kpack namespace. Not needed when installing kpack as part of the Kadras Enginnering Platform. |
| `kp_default_repository.aws_iam_role_arn` | `""` | IAM credentials to access the default container repository if the registry is on AWS. |

Setting for the kpack controller.

| Config | Default | Description |
|-------|-------------------|-------------|
| `controller.resources.requests.memory` | `"1Gi"` | Memory requests configuration for the kpack-controller Deployment. In a resource-constrained environment, you can lower this up to `100Mi`. |
| `controller.resources.limits.memory` | `"1Gi"` | Memory limits configuration for the kpack-controller Deployment. In a resource-constrained environment, you can lower this up to `500Mi`. |
| `config.injected_sidecar_support` | `false` | Enable support for injected sidecars. |

Settings for the corporate proxy.

| Config | Default | Description |
|-------|-------------------|-------------|
| `proxy.http_proxy` | `""` | The HTTP proxy to use for network traffic. |
| `proxy.https_proxy` | `""` | The HTTPS proxy to use for network traffic. |
| `proxy.no_proxy` | `""` | A comma-separated list of hostnames, IP addresses, or IP ranges in CIDR format that should not use a proxy (e.g. Kubernetes API address). |

</details>

## 🛡️&nbsp; Security

The security process for reporting vulnerabilities is described in [SECURITY.md](SECURITY.md).

## 🖊️&nbsp; License

This project is licensed under the **Apache License 2.0**. See [LICENSE](LICENSE) for more information.

## 🙏&nbsp; Acknowledgments

This package is inspired by the original kpack package used in the [Tanzu Community Edition](https://github.com/vmware-tanzu/community-edition) project before its retirement.
