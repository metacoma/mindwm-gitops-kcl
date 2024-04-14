import k8s.apimachinery.pkg.apis.meta.v1 as meta

ArgoCdDefaultNamespace = "argocd"

schema ArgoCdHelmRelease:
    apiVersion: str = "argoproj.io/v1alpha1"
    kind: str = "Application"
    metadata: meta.ObjectMeta = {
        namespace = ArgoCdDefaultNamespace
    }
    spec: ArgoCdSpec

schema ArgoCdSpec: 
    project: str = "default"
    source: ArgoCdSpecSource
    syncPolicy: ArgoAppSyncPolicy
    destination: ArgoCdAppDestination

schema ArgoCdAppDestination:
    namespace: str
    server: str = "https://kubernetes.default.svc"

schema ArgoCdSpecSource:
    chart: str
    repoURL: str
    targetRevision: str
    helm: ArgoCdHelm

schema ArgoCdHelm:
    valuesObject?: any
    releaseName: str

schema ArgoAppSyncPolicy: 
    automated: any = {}
    syncOptions: [str] = ["CreateNamespace=true"]
