import manifests
import .helm.chart as charts
import .argocd.schema as argocdSchema
import .nats.config as nats
import k8s.api.core.v1 as k8core
import knative_operator.v1beta1 as knative
import knative as knativeConfig
import file
import yaml

import .istio as istio



manifests.yaml_stream([

    # istio-injection namespace
    [k8core.Namespace {
        metadata.name = ns.name
        metadata.labels = ns.labels
    } for ns in [
        {
          name = istio.gateway.namespace
          labels = {
            "istio-injection" = "enabled"
          }
        },
        {
          name = knativeConfig.serving.namespace
          labels = {
            "istio-injection" = "enabled"
          }
        },
        {
            name = knativeConfig.eventing.namespace
        }
        {
            name = "demo-namespaceXXX"
        }
        ]
    ]
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

    argocdSchema.argoHelmRelease({
        namespace = istio.system.namespace,
        name = "istio-base"
        chart = charts.istio_base
        version = istio.version
    }) | {
        spec.ignoreDifferences = [
            {
                group = "admissionregistration.k8s.io"
                kind = "ValidatingWebhookConfiguration"
                name = "istiod-default-validator"
                jsonPointers = ["/webhooks/0/failurePolicy"]
            }
        ]
    }

    argocdSchema.argoHelmRelease({
        namespace = istio.system.namespace,
        name = "istiod"
        chart = charts.istiod
        version = istio.version
    })


    argocdSchema.argoHelmRelease({
        namespace = istio.gateway.namespace
        name = "gateway"
        chart = charts.istio_gateway
        version = istio.version
    }) | { spec.syncPolicy.syncOptions = [] }

#    knative.KnativeServing {
#        metadata.name = "knative-serving"
#        metadata.namespace = knativeConfig.serving.namespace
#        spec.config.istio = {
#            "local-gateway.${istio.gateway.namespace}.knative-local-gateway" = "knative-local-gateway.${istio.system.namespace}.svc.cluster.local"
#        }
#    }
#
#    knative.KnativeEventing {
#        metadata.name = "knative-eventing"
#        metadata.namespace = knativeConfig.eventing.namespace
#    }

    #yaml.decode_all(file.read("manifests/net-istio.yaml"))

    #yaml.decode_all(file.read("manifests/knative-operator.yaml"))

])
