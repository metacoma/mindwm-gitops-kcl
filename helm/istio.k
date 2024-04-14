import k8s.api.core.v1 as k8core

import ..argocd_app

istio = argocd_app.ArgoCdHelmRelease {
    metadata = {
        name = "istio-base",
    },
    spec = {
        destination = {
            namespace = "istio-system"
        }
        source = {
            chart = "base",
            repoURL = "https://istio-release.storage.googleapis.com/charts",
            targetRevision = "1.21.0"
            helm = {
                valuesObject = {}
                releaseName = "istio-base"
            }
        }
        syncPolicy = {
            automated = {},
            syncOptions = ["CreateNamespace=true"]
        }
    }
}

