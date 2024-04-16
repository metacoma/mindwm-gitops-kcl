CLUSTER_NAME := mindwm-quickstart
BOOTSTRAP_REPO := https://github.com/metacoma/mindwm-gitops-kcl

#export K3D_FIX_DNS=1 &&

#--volume /etc/resolv.conf:/etc/resolv.conf

.PHONY = mindwm create argocd argocd_password argocd_login argocd_kcl_app argocd_infrastructure_app


create: delete
	sh -c '\
	export K3D_FIX_DNS=1 && \
	k3d cluster create $(CLUSTER_NAME) --verbose --servers 1 --agents 1 --port 9080:80@loadbalancer --port 9443:443@loadbalancer --api-port 6443 --k3s-arg "--disable=traefik@server:*" --wait \
	'
	#k3d cluster lits | grep $(CLUSTER_NAME) || K3D_FIX_DNS=1 k3d cluster create $(CLUSTER_NAME) --verbose --servers 1 --agents 1 --port 9080:80@loadbalancer --port 9443:443@loadbalancer --api-port 6443 --k3s-arg "--disable=traefik@server:*" --wait
delete:
	k3d cluster delete $(CLUSTER_NAME)


argocd: create
	helm repo add argocd https://argoproj.github.io/argo-helm && \
	helm repo update argocd && \
	helm upgrade --install --namespace argocd --create-namespace argocd argocd/argo-cd --wait --timeout 5m && \
	kubectl apply -f bootstrap_manifests/kcl-cmp.yaml && \
	kubectl -n argocd patch deploy/argocd-repo-server -p "`cat bootstrap_manifests/patch-argocd-repo-server.yaml`" && \
	kubectl wait --for=condition=ready pod -n argocd -l app.kubernetes.io/name=argocd-repo-server --timeout=1200s

docker-image-pull:
	docker exec -ti k3d-$(CLUSTER_NAME)-server-0 ctr image pull docker.io/rancher/mirrored-pause:3.6
kubectl_proxy:
	kubectl port-forward service/argocd-server -n argocd 8080:443 &
argocd_password:
	$(eval ARGOCD_PASSWORD := $(shell kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}"  |base64 -d;echo))
argocd_login: kubectl_proxy argocd_password
	argocd login --insecure --username admin --password $(ARGOCD_PASSWORD) localhost:8080

argocd_kcl_app:
	argocd app create mindwm \
		--repo $(BOOTSTRAP_REPO) \
		--revision argocd_wave_test \
		--path . \
		--dest-namespace default \
		--dest-server https://kubernetes.default.svc \
		--config-management-plugin kcl-v1.0

mindwm: create argocd argocd_password argocd_login argocd_kcl_app
