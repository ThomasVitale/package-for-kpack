# Support for Injected Sidecars

If you run kpack in an environment requiring service mesh sidecars, you can enable the kpack support for injected sidecars.

```yaml
config:
  injected_sidecar_support: true
```

For more information, check the kpack documentation for [injected sidecars](https://github.com/pivotal/kpack/blob/main/docs/injected_sidecars.md) and how they affect the CPU and memory configuration for the image build Pods.
