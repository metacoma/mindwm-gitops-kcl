import k8s.api.core.v1 as k8core
import k8s.apimachinery.pkg.apis.meta.v1 as meta
#import argocd as "argo-cd"

ArgoCdNamespace = "argocd"

ns3: k8core.Namespace {
    metadata.name = "ns3"
}

schema ArgoCdHelmRelease:
    application: str = "argoproj.io/v1alpha1"
    kind: str = "Application"
    metadata: meta.ObjectMeta
    spec: ArgoCdSpec

schema ArgoCdSpec: 
    project: str = "default"
    source: ArgoCdSpecSource
    syncPolicy: ArgoAppSyncPolicy

schema ArgoCdSpecSource:
    chart: str
    repoURL: str
    targetRevision: str
    helm: ArgoCdHelm

schema ArgoCdHelm:
    valuesObject: any
    releaseName: str

schema ArgoAppSyncPolicy: 
    automated: any = {}
    syncOptions: [str] = ["CreateNamespace=true"]


cert_manager: ArgoCdHelmRelease {
    metadata = { 
        name = "cert-manager3",
        namespace = ArgoCdNamespace
    },
    spec = {
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

