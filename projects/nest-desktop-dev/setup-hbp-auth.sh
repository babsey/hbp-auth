#
# NEST Desktop Dev
#

oc project nest-desktop-dev
oc delete is,dc,svc,route,configMap hbp-auth
oc new-app babsey/nest-desktop-hbp-auth
oc new-app ./openshift-dev/hbp-auth-dev.yaml
oc set env --from="configmap/hbp-auth" dc/hbp-auth
oc create route edge --hostname="nest-desktop.apps-dev.hbp.eu" --port=8080 --insecure-policy="Redirect" --service="hbp-auth"
