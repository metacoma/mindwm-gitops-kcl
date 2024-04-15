import manifests
import .helm.chart as charts
import .argocd.schema as argocdSchema
import .nats.config as nats



manifests.yaml_stream([

    argocdSchema.argoHelmRelease({
        namespace = "redpanda"
        name = "redpanda-operator"
        chart = charts.redpanda_operator
        version = "0.4.20"
    })

    argocdSchema.argoHelmRelease({
        namespace = "cert-manager"
        name = "cert-manager"
        chart = charts.cert_manager
        version = "1.14.4"
    })

    argocdSchema.argoHelmRelease({
        namespace = "nats"
        name = "nats"
        chart = charts.nats
        version = "1.1.10"
        values = {
            config = nats.config
            service = {
                merge.spec.type = 'NodePort'
                ports.cluster.enabled = True
            }
        }
    })

])
