import k8s.api.core.v1 as k8core


import ..argocd_app

ArgoCdNamespace = "argocd"


ns3: k8core.Namespace {
    metadata.name = "ns3"
}

cert_manager = argocd_app.ArgoCdHelmRelease {
    metadata = {
        name = "cert-manager3",
        namespace = ArgoCdNamespace
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

