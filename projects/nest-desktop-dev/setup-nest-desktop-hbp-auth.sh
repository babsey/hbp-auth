#
# NEST Desktop Dev
#

oc project nest-desktop-dev
oc delete is,dc,svc,route,configMap nest-desktop-hbp-auth
oc new-app babsey/nest-desktop-hbp-auth
oc new-app ./openshift-dev/nest-desktop-hbp-auth.yaml
oc set env --from='configmap/nest-desktop-hbp-auth' dc/nest-desktop-hbp-auth
oc create route edge --hostname='nest-desktop.apps-dev.hbp.eu' --port='8080' --insecure-policy='Redirect' --service='nest-desktop-hbp-auth'
