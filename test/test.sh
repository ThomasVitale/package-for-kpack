#!/bin/bash

echo -e "\n🚢 Setting up Kubernetes cluster...\n"

kapp deploy -a test-setup -f test/test-setup -y
kubectl config set-context --current --namespace=carvel-test

# Wait for the generation of a token for the new Service Account
while [ $(kubectl get configmap kube-root-ca.crt --no-headers | wc -l) -eq 0 ] ; do
  sleep 3
done

echo -e "\n🔌 Installing test dependencies..."

kapp deploy -a test-registry -f test/test-dependencies/registry -y

echo -e "📦 Deploying Carvel package...\n"

cd package
ytt -f ../test/test-config -f package-resources.yml | kctrl dev -f- --local -y
cd ..

echo -e "🎮 Verifying package..."

status=$(kapp inspect -a kpack.app --status --json | jq '.Lines[1]' -)
if [[ '"Succeeded"' == ${status} ]]; then
    echo -e "✅ The package has been installed successfully.\n"
    exit 0
else
    echo -e "🚫 Something wrong happened during the installation of the package.\n"
    exit 1
fi

# echo -e "🖼️ Building OCI image...\n"

# kapp deploy -a test-kpack-dependencies -f test/test-dependencies/kpack-dependencies -y

# kapp deploy -a test-data -f test/test-data -y
