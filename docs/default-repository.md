# Configuring a Default Container Image Repository

When installing kpack, you're required to provide information about the container image repository to use as the default.

```yaml
kp_default_repository:
  name: "ghcr.io/thomasvitale/buildpacks"
```

Credentials to authenticate with the given container registry can be provided in a few different ways. Only one strategy can be configured.

## Credentials via values

You can pass the container registry credentials via literal values when installing kpack.

```yaml
kp_default_repository:
  credentials:
    username: "<your-username>"
    password: "<your-token>"
```

When using the Google Container Registry, `kp_default_repository.credentials.username` should be `_json_key` and `kp_default_repository.credentials.password` the contents of the service account key json for GCR.

## Credentials via Secret

You can pass the container registry credentials via a Secret, which needs to be created in the cluster before installing kpack. 

```yaml
kp_default_repository:
  secret:
    name: supply-chain-registry-credentials
    namespace: kadras-system
```

If you use this package outside the Kadras Engineering Platform, you also need to configure it to export the Secret from the source namespace to the kpack namespace.

```yaml
kp_default_repository:
  secret:
    name: supply-chain-registry-credentials
    namespace: kadras-system
    create_export: true
```

## Credentials via AWS IAM

If the configured container registry is on AWS, IAM credentials are supported for authentication.

```yaml
kp_default_repository:
  aws_iam_role_arn: "<your-iam-role-arn>"
```
