load("@ytt:assert", "assert")
load("@ytt:base64", "base64")
load("@ytt:data", "data")
load("@ytt:json", "json")

# Split "ca_cert_data" into a list of certificates.
def get_ca_certificates():
  ca_certs_lines=data.values.ca_cert_data.splitlines()
  ca_certs = []
  i1=0
  i2=0
  found_cert = True
  for ca_cert_line in ca_certs_lines:
    found_cert = False
    if ca_cert_line == "-----END CERTIFICATE-----" :
      ca_certs.append("\n".join(ca_certs_lines[i1:i2+1]))
      i1=i2+1
      found_cert = True
    end
    i2+=1
  end
  found_cert or assert.fail("misconfigured ca_cert_data")
  return ca_certs
end

# Compute the container registry that kpack will use by default.
def get_default_registry():
  if data.values.kp_default_repository.name == "":
    return ""
  end

  kp_default_registry = ""
  parts = data.values.kp_default_repository.name.split("/", 1)
  if len(parts) == 2:
    if ('.' in parts[0] or ':' in parts[0]) and parts[0] != "index.docker.io":
      kp_default_registry = parts[0]
    else:
      kp_default_registry = "https://index.docker.io/v1/"
    end
  elif len(parts) == 1:
    assert.fail("kp_default_repository.name must be a valid writeable repository and must include a '/'")
  end
  return kp_default_registry
end

# Compute the .dockerconfigjson content for defining a Secret with the default registry credentials.
def get_default_registry_docker_config_json():
  if not data.values.kp_default_repository.credentials:
    return ""
  end

  registry_auth = base64.encode("{}:{}".format(data.values.kp_default_repository.credentials.username, data.values.kp_default_repository.credentials.password))
  registry_credentials = {
      "username": data.values.kp_default_repository.credentials.username, 
      "password": data.values.kp_default_repository.credentials.password, 
      "auth": registry_auth
  }
  registry_docker_config_json = base64.encode(json.encode({
    "auths": {
      get_default_registry(): registry_credentials
    }
  }))
  return registry_docker_config_json
end

# Compute the Secret name for the default container registry.
def get_default_registry_secret_name():
  kp_default_registry_secret_name = ""
  if not data.values.kp_default_repository.aws_iam_role_arn:
    kp_default_registry_secret_name = "kp-default-repository-secret"
  end
  if data.values.kp_default_repository.secret:
    kp_default_registry_secret_name = data.values.kp_default_repository.secret.name
  end
  return kp_default_registry_secret_name
end
