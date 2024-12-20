# Introducing The Cajun Navy Response System

This work is inspired by, and principally based on [Emergency Response Demo](https://erdemo.io).  For a working application, follow that link.

I am doing this re-write for my own education.  If you want to come along on the journey, we're going to use the principles of Domain Driven Design to create an application that is deployed across three "regions" for maximum resiliency.

Along the way, we'll be using OpenShift as our cloud platform, Cassandra for persistence, Kafka for eventing, and the Quarkus Java framework for coding.

But, first things first.  Let's talk about our Domains and establish a common domain vocabulary.

We're going to establish our high level domain vocabulary through an interview style conversation, with questions which result in answers that define a vocabulary word for our Domains.

## Defining our Domain Vocabulary

Why are we here?  Because a Disaster has ocurred, and people need to be rescued.

This application is implementing a fictional system based on the coordination of rescue operations loosely termed the Cajun Navy: [https://en.wikipedia.org/wiki/Cajun_Navy](https://en.wikipedia.org/wiki/Cajun_Navy).  It's origins go back to Hurricane Katrina in 2005.

The scenario is that a flood disaster of some sort has occurred and volunteer resources with boats are needed to carry out immediate rescue operations.

__Question__: What is a disaster?

__Answer__: A disaster is an event that significantly disrupts the normal operations for a locality.  Now, the locality can be pretty narrow.  For example, your basement...  The washing machine overflows and your sump pump failed.  That's a pretty significant disruption, but not one that is likely to require the attention of the Cajun Navy.  So, let's define locality a bit more broadly.  In our case, a locality represents a population on the order of a town, city, or one or more counties, which may span one or more States.  For simplicity, the examples here will be US centric.

__Domain Vocabulary__: A `Disaster` is an event that significantly disrupts the normal operations for a population on the order of a town, city, or one or more counties, which may span one or more States.  In the case of this application, the `Disaster` is a flood.

__Question__: What do we need to do in order to deal with the disaster, in the immediate term?

__Answer__: Get the affected people to safety.

OK. So, let's focus on that.

__Domain Vocabulary__: Let's call the affected people, `Victims`.

__Question__: What defines a `Victim`?

__Answer__: A `Victim` is an individual who is unable to extricate themselves from a dangerous situation caused by a `Disaster`.

OK, so the goal of our application is to help get `Victims` of a `Disaster` out of danger and to a place of safety.

__Question__: What is a place of safety?

__Answer__: A place of safety is a location that mitigates the immediate effects of the disaster.

__Domain Vocabulary__: Let's call the places of safety `Shelters`.

__Question__: How will we get `Victims` from where they are to a `Shelter`?

__Answer__: We need someone with the appropriate resources and skills to move them.

__Domain Vocabulary__: Let's call the `Victim` movers, `Responders`.

__Question__: How will the `Responders` know how to find `Victims` to move?

__Answer__: `Victims` in close proximity should be handled as a unit of work so that `Responders` can move them efficiently.

__Domain Vocabulary__: Let's call the units of work, `Incidents`.

__Question__: How will the `Responders` know what `Shelter` they should take to take the `Victims` associated with an `Incident` to?

__Answer__: A `Shelter` will be designated for the `Victims` of a given `Incident`, and a link between the `Incident` and the `Shelter` will be provided to the `Responder`.

__Domain Vocabulary__: Let's call the link from `Incident` to `Shelter`, a `Mission`.

__Question__: How do we define the area impacted by a `Disaster`?

__Answer__:  The area of impact will be determined by a contiguous geographic zone which encompasses all of the `Victims` and `Shelters` which can be managed by a regional grouping of `Responders`.  It is possible for a single `Disaster` to have multiple, geographically separated impact areas with their own `Shelters`, `Victims`, and `Responders`

__Domain Vocabulary__: Let's call the area of impact an `Impact Zone`

OK...  let's pause for a minute and analyze our domain vocabulary.  So far, we have:

| Domain Vocabulary | Description |
| --- | --- |
| `Disaster` | An event that significantly disrupts the normal operations for a population on the order of a town, city, or one or more counties, which may span one or more States. |
| `Victim` | An individual who is unable to extricate themselves from a dangerous situation caused by a `Disaster` |
| `Shelter` | A location that mitigates the immediate effects of the disaster |
| `Responder` | Someone with the appropriate resources and skills to move `Victims` to `Shelters` |
| `Incident` | A group of one or more `Victims` who are in close proximity to be handled as a unit of work |
| `Mission` | The link between `Incident` to `Shelter` |
| `Impact Zone` | A geographical area with `Shelters` and `Responders` who can help `Victims` within the boundaries of the zone |

The goal of this operation is for `Responders` to complete `Missions` which move the `Victims` of a `Disaster` from `Incidents` to `Shelters` within a given `Impact Zone`.

Let's build an app to help realize that goal.

## The Domain Processes:

1. Register a `Disaster` with at least one `Impact Zone`.

1. Register one or more `Shelters` associated with an `Impact Zone`.

1. `Victims` are registered for assistance.

1. `Responders` indicate their availability to help `Victims`

1. `Incidents` are created for one or more `Victims` that are in close proximity.

1. An appropriate `Shelter` is identified to accept the `Victims` associated with an `Incident`

1. Create a `Mission` and assign one or more `Incidents` to a `Shelter`

1. Assign a `Mission` to a `Responder`

1. A `Responder` accepts a `Mission`

1. A `Responder` completes a `Mission` by traveling to the location of the `Incident`, retrieving the `Victims`, and moving them to the assigned `Shelter`

## The Domain Aggregates

### Disaster

The `Disaster` aggregate defines the geographical boundaries of the area affected by the disaster.  

`Disaster` maintains a relationship with:

* Impact Zones
* Registered `Shelters`
* Registered `Responders`
* Registered `Victims`

A `Disaster` has the following entities:

| Entity | Description |
| --- | --- |
| `Impact Zone` | A geographical region where `Incidents` are likely to be registered |
| `Shelter` | A facility that can accept `Victims` |
| `Responder` | A rescue team with the skills and resources to rescue `Victims` |
| `Victim` | An individual impacted by the disaster and in need of rescue |

### Shelter

| Entity | Description |
| --- | --- |


### Incident

### Mission

### Responder


## WIP...

## How it will work:

1. A disaster is registered
    1. Shelters
    1. Inclusion Zones
1. Incidents are registered (Asynchronous Activity)
    1. Victims
1. Responders enroll (Asynchronous Activity)
1. Responders are assigned to Incidents
    1. Missions

### Services:

1. ___[Disaster Service](https://github.com/cgruver-cajun-navy/disaster)___

    * Registers a disaster
    * Responds to the creation of Incidents and creates Missions with available Responders
    * Records the rescue status of Victim to Shelters
    * Manages the prioritization of Incidents when there are not enough Responders 

1. ___[Incident Service](https://github.com/cgruver-cajun-navy/incident)___

    * Manages Incident State

1. ___[Responder Service](https://github.com/cgruver-cajun-navy/responder)___

    * Manages Responder State

1. ___[Mission Service](https://github.com/cgruver-cajun-navy/mission)___

    * Creates Missions for Responders

### Kafka Topics:

| Topic  | Description | Producer | Consumers |
| - | - | - | - |
| incident-reported | | Incident Service | Disaster Service |
| incident-updated | | Incident Service | |
| incident-update-location | | Disaster Service | Incident Service |
| incident-update-status | | Disaster Service | Incident Service |
| incident-assigned | | Disaster Service | Incident Service |
| | | | |
| responder-info-update | | Disaster Service | Responder Service |
| responder-location-update | | Disaster Service | Responder Service, Mission Service |
| responder-availability-update | | Disaster Service | Responder Service |
| responder-created | | Responder Service | |
| responder-updated | | Responder Service | Disaster Service |
| responder-location-updated | | Responder Service | |
| | | | |
| priority-zone-clear | | | Incident Service |
| mission-command | | Disaster Service | Mission Service |
| mission-event | | Mission Service | Disaster Service |
| | | |

### Kafka Topics by Service

| Service | Produces | Consumes |
| - | - | - |
| Incident Service | | |
| | incident-reported | incident-update-location |
| | incident-updated | incident-update-status |
| | | incident-assigned |
| Disaster Service | | |
| | incident-update-location | incident-reported |
| | incident-update-status | incident-updated |
| | incident-assigned | responder-updated |
| | responder-info-update | responder-created |
| | responder-location-update | mission-event |
| | responder-availability-update | victim-rescued |
| | mission-command |
| Responder Service | | |
| | responder-created | responder-info-update |
| | responder-updated | responder-location-update |
| | responder-location-updated | responder-availability-update |
| | | |
| Mission Service | | |
| | mission-event | mission-command |
| | | responder-location-updated |

### Development Roadmap:

1. MVP

    * Record Disaster
    * Add Shelters

1. Incident

    * Register Incident and associate with Disaster

1. Responder

    * Register Responders and associate with Disaster

1. Assignments

    Assign Responder to Incident

1. TBD

## Install

Install subctl

```bash
curl -Ls https://get.submariner.io | DESTDIR=${OPENSHIFT_LAB_PATH}/bin VERSION=v0.18.0 bash
```

Prepare Nodes:

```bash
labctx control-plane
for node in $(oc --kubeconfig ${KUBE_INIT_CONFIG} get nodes -o name -l node-role.kubernetes.io/worker="")
do
  oc --kubeconfig ${KUBE_INIT_CONFIG} label ${node} submariner.io/gateway=true --overwrite
  oc --kubeconfig ${KUBE_INIT_CONFIG} annotate ${node} gateway.submariner.io/public-ip=dns:$(echo ${node} | cut -d "/" -f2).${DOMAIN} --overwrite
done

for region in region-01 region-02 region-03
do
  labctx ${region}
  for node in $(oc --kubeconfig ${KUBE_INIT_CONFIG} get nodes -o name -l node-role.kubernetes.io/worker="")
  do
    oc --kubeconfig ${KUBE_INIT_CONFIG} label ${node} submariner.io/gateway=true --overwrite
    oc --kubeconfig ${KUBE_INIT_CONFIG} annotate ${node} gateway.submariner.io/public-ip=dns:$(echo ${node} | cut -d "/" -f2).${DOMAIN} --overwrite
  done
done
```

Install Submariner:

```bash
labctx control-plane
subctl deploy-broker --kubeconfig ${KUBE_INIT_CONFIG} --globalnet=false
mv broker-info.subm ${OPENSHIFT_LAB_PATH}/lab-config/broker-info.subm

for i in control-plane region-01 region-02 region-03
do
  labctx ${i}
  subctl join ${OPENSHIFT_LAB_PATH}/lab-config/broker-info.subm --kubeconfig ${KUBE_INIT_CONFIG} --natt=false --cable-driver libreswan --globalnet=false
done
```

Uninstall Submariner:

```bash
for i in control-plane region-01 region-02 region-03
do
  labctx ${i}
  subctl uninstall --kubeconfig ${KUBE_INIT_CONFIG} --yes
done
```

## Notes

```bash
subctl show all --kubeconfig ${KUBE_INIT_CONFIG}
subctl diagnose all --kubeconfig ${KUBE_INIT_CONFIG}
subctl diagnose firewall inter-cluster ${OPENSHIFT_LAB_PATH}/lab-config/okd4-region-01-dc1-${LAB_DOMAIN}/kubeconfig ${OPENSHIFT_LAB_PATH}/lab-config/okd4-region-02-dc2-${LAB_DOMAIN}/kubeconfig

oc patch pod ${POD} --type json -p '[{"op": "replace", "path": "/spec/containers/0/image", "value": "${PROXY_REGISTRY}/submariner/nettest:0.12.0"}]'

quay.io/submariner/nettest:devel
```

## K8ssandra Install

### Install Cert Manager

```bash
cat << EOF | oc apply -f -
apiVersion: v1                      
kind: Namespace                 
metadata:
  name: cert-manager-operator
---
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: openshift-cert-manager-operator
  namespace: cert-manager-operator
spec:
  targetNamespaces:
  - cert-manager-operator
---
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: openshift-cert-manager-operator
  namespace: cert-manager-operator
spec:
  channel: stable-v1
  name: openshift-cert-manager-operator
  source: redhat-operators
  sourceNamespace: openshift-marketplace
  installPlanApproval: Automatic
EOF
```

```bash
kustomize build "github.com/k8ssandra/k8ssandra-operator/config/deployments/control-plane?ref=vX.X.X" | kubectl apply --server-side -f -

kustomize build "github.com/k8ssandra/k8ssandra-operator/config/deployments/data-plane?ref=vX.X.X" | kubectl apply --server-side -f -

```