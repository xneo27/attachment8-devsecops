#!groovy

// @TODO uncomment file if CSRF protection is to be restored at initialization.
// CSRF was turned off due to a chicken and egg problem regarding slave registration
// An API token is required to generate a valid crumb, but a crumb is required to create a valid token
// The long term approach to fix this could be to start with crumbs disabled, then issue a token request, reenable
// crumbs using that token, then request a crumb. It appears that http via jenkins also utilizes a crumb, but I am
// not sure how that crumb is created without a token, as every request I've made has returned a invalid crumb
// error once the created crumb is used. This requires additional investigation, but we're out of time.

//import hudson.security.csrf.DefaultCrumbIssuer
//import jenkins.model.Jenkins
//
//println "--> enabling CSRF protection"
//
//def instance = Jenkins.instance
//instance.setCrumbIssuer(new DefaultCrumbIssuer(true))
//instance.save()