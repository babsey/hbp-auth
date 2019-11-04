#
# NEST Desktop
#

oc project nest-desktop
oc delete is,dc,svc,route,configMap hbp-auth
oc new-app babsey/nest-desktop-hbp-auth
oc new-app ./openshift/hbp-auth.yaml
oc set env --from=configmap/hbp-auth dc/hbp-auth
oc expose svc/hbp-auth --port=8080 --hostname='nest-desktop.apps.hbp.eu'
