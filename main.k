import manifests
import .helm.chart as charts
import .argocd.schema as argocdSchema
import .nats.config as nats
import k8s.api.core.v1 as k8core
import k8s.api.apps.v1 as k8apps
import knative_operator.v1beta1 as knative
import knative as knativeConfig
import file
import yaml

import .istio as istio


ns = k8core.Namespace {
  metadata = {
    name = "test-namespace"
    annotations = {
        test = "test"
    } 
  } 
} 

configmap = k8core.ConfigMap {
    metadata = {
        name = "test-configmap"
        namespace = "test-namespace"
    } 
    data = {
        a = "abc"
    }
} 



manifests.yaml_stream([
    ns
    configmap
])
