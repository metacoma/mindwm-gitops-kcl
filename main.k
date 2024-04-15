import argoproj.v1alpha1 as argoproj
import manifests

redpanda: argoproj.Application = {
    metadata = {
        name = "redpanda"
        namespace = "argocd"
    } 
    spec = {
        destination = {
            namespace = "redpanda"
            server = "https://kubernetes.default.svc"
        }
        project = "default"
        source = {
            chart = "operator"
            repoURL = "https://charts.redpanda.com"
            targetRevision = "0.4.20"
            helm = {
                releaseName = "redpanda-operator"
            }
        }
        syncPolicy = {
            automated = {}
            syncOptions = [ "CreateNamespace=true" ]
        }
    }

} 

#import helm.redpanda as helm_redpanda
#import helm.cert_manager as helm_cert_manager
#import helm.nats as helm_nats
#import helm.istio as helm_istio
#
manifests.yaml_stream([
    redpanda
#    helm_cert_manager.cert_manager
#    helm_redpanda.redpanda_operator
#    helm_nats.nats
#    helm_istio.istio
])
