import k8s.api.core.v1 as k8core


import ..argocd_app

cert_manager = argocd_app.ArgoCdHelmRelease {
    metadata = {
        name = "cert-manager",
    },
    spec = {
        destination = {
            namespace = "cert-manager"
        }
        source = {
            chart = "cert-manager",
            repoURL = "https://charts.jetstack.io",
            targetRevision = "1.14.4"
            helm = {
                valuesObject = {
                    installCRDs = True
                }
                releaseName = "cert-manager"
            }
        }
        syncPolicy = {
            automated = {},
            syncOptions = ["CreateNamespace=true"]
        }
    }
}

