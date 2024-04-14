import k8s.api.core.v1 as k8core

import .argocd_app

ArgoCdNamespace = "argocd"


redpanda_operator = argocd_app.ArgoCdHelmRelease {
    metadata = {
        name = "redpanda",
        namespace = ArgoCdNamespace
    },
    spec = {
        destination = {
            namespace = "redpanda"
        }
        source = {
            chart = "operator",
            repoURL = "https://charts.redpanda.com",
            targetRevision = "0.4.20"
            helm = {
                releaseName = "redpanda-operator"
            }
        }
        syncPolicy = {
            automated = {},
            syncOptions = ["CreateNamespace=true"]
        }
    }
}

