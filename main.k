import k8s.api.core.v1 as k8core
import manifests
import helm_cert_manager

ns1: k8core.Namespace {
    metadata.name = "web-app"
}

ns2: k8core.Namespace {
    metadata.name = "web-app"
}


manifests.yaml_stream([
    ns1,
    ns2,
    helm_cert_manager.ns3
])
