# Kpack

This project provides a [Carvel package](https://carvel.dev/kapp-controller/docs/latest/packaging) for [kpack](https://github.com/pivotal/kpack), a Kubernetes-native implementation of Cloud Native Buildpacks to build OCI images from within the cluster.

## Components

* kpack

## Prerequisites

* Install the [`kctrl`](https://carvel.dev/kapp-controller/docs/latest/install/#installing-kapp-controller-cli-kctrl) CLI to manage Carvel packages in a convenient way.
* Ensure [kapp-controller](https://carvel.dev/kapp-controller) is deployed in your Kubernetes cluster. You can do that with Carvel [`kapp`](https://carvel.dev/kapp/docs/latest/install) (recommended choice) or `kubectl`.

```shell
kapp deploy -a kapp-controller -y \
  -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/latest/download/release.yml
```

## Installation

You can install the kpack package directly or rely on the [Kadras package repository](https://github.com/arktonix/carvel-packages)
(recommended choice).

Follow the [instructions](https://github.com/arktonix/carvel-packages) to add the Kadras package repository to your Kubernetes cluster.

If you don't want to use the Kadras package repository, you can create the necessary `PackageMetadata` and
`Package` resources for the kpack package directly.

```shell
kubectl create namespace carvel-packages
kapp deploy -a kpack-package -n carvel-packages -y \
    -f https://github.com/arktonix/package-for-kpack/releases/latest/download/metadata.yml \
    -f https://github.com/arktonix/package-for-kpack/releases/latest/download/package.yml
```

Either way, you can then install the kpack package using [`kctrl`](https://carvel.dev/kapp-controller/docs/latest/install/#installing-kapp-controller-cli-kctrl).

```shell
kctrl package install -i kpack \
    -p kpack.packages.kadras.io \
    -v 0.8.0 \
    -n carvel-packages
```

You can retrieve the list of available versions with the following command.

```shell
kctrl package available list -p kpack.packages.kadras.io
```

You can check the list of installed packages and their status as follows.

```shell
kctrl package installed list -n carvel-packages
```

## Configuration

The kpack package has the following configurable properties.

| Config | Required/Optional | Description |
|--------|---------|-------------|
| `kp_default_repository` | Optional | OCI repository used for builder images and dependencies. Ex: Dockerhub: `mydockerhubusername/my-repo`; GCR: `gcr.io/my-project/my-repo`; Harbor: `myharbor.io/my-project/my-repo`. Required by the [kp cli](https://github.com/vmware-tanzu/kpack-cli).|
| `kp_default_repository_username` | Optional | Username for `kp_default_repository` (Note: use `_json_key` for GCR) |
| `kp_default_repository_password` | Optional | Password for `kp_default_repository` (Note: use contents of service account key json for GCR) |
| `proxy.http_proxy` | Optional | The HTTP proxy to use for network traffic |
| `proxy.https_proxy` | Optional | The HTTPS proxy to use for network traffic |
| `proxy.no_proxy` | Optional | A comma-separated list of hostnames, IP addresses, or IP ranges in CIDR format that should not use a proxy |
| `ca_cert_data` | Optional | CA Certificate to be injected into the kpack controller trust store for communicating with self signed registries. (Note: This will not be injected into builds, you need to use the cert injection webhook with the `kpack.io/build` label value) |

You can define your configuration in a `values.yml` file.

```yaml
kp_default_repository: test-registry.oci.svc.cluster.local:443/kpack
kp_default_repository_username: testuser
kp_default_repository_password: testpassword
```

Then, reference it from the `kctrl` command when installing or upgrading the package.

```shell
kctrl package install -i kpack \
    -p kpack.packages.kadras.io \
    -v 0.8.0 \
    -n carvel-packages \
    --values-file values.yml
```

## Documentation

For documentation specific to kpack, check out [github.com/pivotal/kpack](https://github.com/pivotal/kpack).

## References

This package is based on the original kpack package used in [Tanzu Community Edition](https://github.com/vmware-tanzu/community-edition) before its retirement.

## Supply Chain Security

This project is compliant with level 2 of the [SLSA Framework](https://slsa.dev).

<img src="https://slsa.dev/images/SLSA-Badge-full-level2.svg" alt="The SLSA Level 2 badge" width=200>
