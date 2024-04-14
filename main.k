import manifests
import helm.redpanda as helm_redpanda
import helm.cert_manager as helm_cert_manager
import helm.nats as helm_nats

manifests.yaml_stream([
    helm_cert_manager.cert_manager
    helm_redpanda.redpanda_operator
    helm_nats.nats
])
