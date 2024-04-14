import manifests
import helm.redpanda as helm_redpanda
import helm.cert_manager as helm_cert_manager
import helm.nats as helm_nats
import helm.istio as helm_istio

manifests.yaml_stream([
    helm_cert_manager.cert_manager
    helm_redpanda.redpanda_operator
    helm_nats.nats
    helm_istio.istio
])
