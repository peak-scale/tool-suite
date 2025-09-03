REVISION  ?= "main"
GO_BIN    ?= $(LOCALBIN)/go/bin/go
GO_OS     := Linux
GO_OS_LOW := $(shell echo $(GO_OS) | tr A-Z a-z)

GO_ARCH   := amd64
TMP_DIR   := $(shell pwd)/.tmp

LOCALBIN  ?= $(shell pwd)/bin
$(LOCALBIN):
	mkdir -p $(LOCALBIN)

$(TMP_DIR):
	mkdir -p $(TMP_DIR)

update:
	git pull origin $(REVISION)
	$(MAKE) --no-print-directory update-loop

SUBDIRS := $(LOCALBIN)/.*
update-loop: $(LOCALBIN)/*
	@for bin in $^; do \
		echo "... 🍃 Updating Binary" $$(basename "$$bin") && \
		$(MAKE) $$(basename "$$bin") \
 	; done

CRANE         := $(LOCALBIN)/crane
CRANE_VERSION := v0.20.6
CRANE_LOOKUP  := google/go-containerregistry
crane:
	@mkdir -p $(TMP_DIR)
	@curl -sL "https://github.com/google/go-containerregistry/releases/download/$(CRANE_VERSION)/go-containerregistry_$(GO_OS)_x86_64.tar.gz" -o $(TMP_DIR)/crane.tar.gz
	@cd $(TMP_DIR) && tar xf crane.tar.gz && mv crane $(CRANE)
	@rm -rf $(TMP_DIR)

K9S         := $(LOCALBIN)/k9s
K9S_VERSION := v0.50.9
K9S_LOOKUP  := derailed/k9s
k9s:
	@mkdir -p $(TMP_DIR)
	@curl -s -L https://github.com/derailed/k9s/releases/download/$(K9S_VERSION)/k9s_Linux_$(GO_ARCH).tar.gz -o $(TMP_DIR)/k9s.tar.gz
	@cd $(TMP_DIR) && tar xf k9s.tar.gz && mv k9s $(K9S)
	@rm -rf $(TMP_DIR)

TRIVY           := $(LOCALBIN)/trivy
TRIVY_VERSION   := v0.64.1
TRIVY_STRIPPED  := $(subst v,,$(TRIVY_VERSION))
TRIVY_LOOKUP    := aquasecurity/trivy
trivy:
	@mkdir -p $(TMP_DIR)
	@curl -s -L https://github.com/aquasecurity/trivy/releases/download/$(TRIVY_VERSION)/trivy_$(TRIVY_STRIPPED)_Linux-64bit.tar.gz -o $(TMP_DIR)/trivy.tar.gz
	@cd $(TMP_DIR) && tar xf trivy.tar.gz && mv trivy $(TRIVY)
	@rm -rf $(TMP_DIR)

TALHELPER          := $(LOCALBIN)/talhelper
TALHELPER_VERSION  := v3.0.31
TALHELPER_LOOKUP   := budimanjojo/talhelper
talhelper:
	@mkdir -p $(TMP_DIR)
	@curl -s -L https://github.com/budimanjojo/talhelper/releases/download/$(TALHELPER_VERSION)/talhelper_linux_amd64.tar.gz -o $(TMP_DIR)/talhelper.tar.gz
	@cd $(TMP_DIR) && tar xf talhelper.tar.gz && mv talhelper $(TALHELPER)
	@rm -rf $(TMP_DIR)

AGE_KEYGEN    := $(LOCALBIN)/age-keygen
AGE           := $(LOCALBIN)/age
AGE_VERSION   := v1.2.1
AGE_LOOKUP    := FiloSottile/age
age:
	@$(call go-install-tool,$(AGE_KEYGEN),filippo.io/age/cmd/age-keygen@$(AGE_VERSION))
	@$(call go-install-tool,$(AGE),filippo.io/age/cmd/age@$(AGE_VERSION))

SOPS          := $(LOCALBIN)/sops
SOPS_VERSION  := v3.10.2
SOPS_LOOKUP   := getsops/sops
sops:
	@$(call go-install-tool,$(SOPS),github.com/$(SOPS_LOOKUP)/v3/cmd/sops@$(SOPS_VERSION))


EJSON         := $(LOCALBIN)/ejson
EJSON_VERSION := v1.5.4
EJSON_LOOKUP  := Shopify/ejson
EJSON_STRIPPED  := $(subst v,,$(EJSON_VERSION))
ejson:
	@mkdir -p $(TMP_DIR)
	@curl -s -L https://github.com/Shopify/ejson/releases/download/$(EJSON_VERSION)/ejson_$(EJSON_STRIPPED)_$(GO_OS)_$(GO_ARCH).tar.gz -o $(TMP_DIR)/ejson.tar.gz
	@cd $(TMP_DIR) && tar xf ejson.tar.gz && mv ejson $(EJSON)
	@rm -rf $(TMP_DIR) 


OPENTOFU          := $(LOCALBIN)/opentofu
OPENTOFU_VERSION  := v1.10.6
OPENTOFU_LOOKUP   := opentofu/opentofu
OPENTOFU_STRIPPED  := $(subst v,,$(OPENTOFU_VERSION))
tofu:
	@mkdir -p $(TMP_DIR)
	@curl -s -L https://github.com/opentofu/opentofu/releases/download/$(OPENTOFU_VERSION)/tofu_$(OPENTOFU_STRIPPED)_$(GO_OS)_$(GO_ARCH).tar.gz -o $(TMP_DIR)/opentofu.tar.gz
	@cd $(TMP_DIR) && tar xf opentofu.tar.gz && mv tofu $(OPENTOFU)
	@cd $(LOCALBIN) && ln -s "$(LOCALBIN)/tofu" "$(LOCALBIN)/terraform" || true
	@chmod +x $(OPENTOFU)
	@rm -rf $(TMP_DIR) 

GO           := $(LOCALBIN)/go
GO_VERSION   := 1.24.2
GO_LOOKUP    := golang/go
go:
	@mkdir -p $(TMP_DIR)
	@mkdir -p $(LOCALBIN)
	@curl -s -L https://go.dev/dl/go$(GO_VERSION).$(GO_OS_LOW)-$(GO_ARCH).tar.gz -o $(TMP_DIR)/go.tar.gz
	@cd $(TMP_DIR) && tar xf go.tar.gz -C $(LOCALBIN)
	@rm -rf $(TMP_DIR)

HELM         ?= $(LOCALBIN)/helm
HELM_VERSION := v3.18.4
HELM_LOOKUP  := helm/helm
helm:
	@mkdir -p $(TMP_DIR)
	@curl -s -L https://get.helm.sh/helm-$(HELM_VERSION)-$(GO_OS_LOW)-$(GO_ARCH).tar.gz -o $(TMP_DIR)/helm.tar.gz
	@cd $(TMP_DIR) && tar xf helm.tar.gz && mv linux-$(GO_ARCH)/helm $(LOCALBIN)/helm
	@rm -rf $(TMP_DIR)

KUBECTL         ?= $(LOCALBIN)/kubectl
KUBECTL_VERSION := v1.33.2
KUBECTL_LOOKUP  := kubernetes/kubernetes
kubectl:
	@curl -s -L https://dl.k8s.io/release/$(KUBECTL_VERSION)/bin/$(GO_OS_LOW)/$(GO_ARCH)/kubectl -o $(KUBECTL)
	@chmod +x $(KUBECTL)

TALOS         := $(LOCALBIN)/talosctl
TALOS_VERSION  := v1.10.5
TALOS_LOOKUP  := siderolabs/talos
talosctl:
	@curl -s -L https://github.com/siderolabs/talos/releases/download/$(TALOS_VERSION)/talosctl-$(GO_OS_LOW)-$(GO_ARCH) -o $(TALOS)
	@chmod +x $(TALOS)

CILIUM         ?= $(LOCALBIN)/cilium
CILIUM_VERSION := v0.18.5
CILIUM_LOOKUP  := cilium/cilium-cli
cilium:
	curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_VERSION}/cilium-$(GO_OS)-$(GO_ARCH).tar.gz{,.sha256sum}
	sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
	tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz $(LOCALBIN)
	rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}

GOMPLATE  := $(LOCALBIN)/gomplate
GOMPLATE_VERSION  := v4.3.3
GOMPLATE_LOOKUP  := hairyhenderson/gomplate
gomplate:
	@curl -s -L https://github.com/hairyhenderson/gomplate/releases/download/$(GOMPLATE_VERSION)/gomplate_$(GO_OS_LOW)-$(GO_ARCH) -o $(GOMPLATE)
	@chmod +x $(GOMPLATE)

# go-install-tool will 'go install' any package $2 and install it to $1.
PROJECT_DIR := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))
define go-install-tool
[ -f $(1) ] || { \
    set -e ;\
    GOBIN=$(LOCALBIN) $(GO_BIN) install $(2) ;\
}
endef
