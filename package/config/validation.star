load("@ytt:assert", "assert")
load("@ytt:data", "data")
load("/helpers.star", "exactly_one")

def validate():
  validate_default_repository()
  validate_default_repository_credentials()
end

def validate_default_repository():
  data.values.kp_default_repository.name or assert.fail("missing kp_default_repository.name")
end

def validate_default_repository_credentials():
  exclusive_values = [
    (data.values.kp_default_repository.credentials.username and data.values.kp_default_repository.credentials.password),
    (data.values.kp_default_repository.secret.name and data.values.kp_default_repository.secret.namespace),
    data.values.kp_default_repository.aws_iam_role_arn
  ]
  if not exactly_one(exclusive_values):
    assert.fail("must only use one of kp_default_repository.credentials, kp_default_repository.secret or kp_default_repository.aws_iam_role_arn")
  end
end

validate()
