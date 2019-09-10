import hudson.model.*
import jenkins.model.*
import jenkins.security.*
import jenkins.security.apitoken.*

File file = new File("/tmp/token")
if (file.exists()) {
    return
}

// script parameters
def userName = 'millgroup'
def tokenName = 'kb-token'

def user = User.get(userName, false)
def apiTokenProperty = user.getProperty(ApiTokenProperty.class)
def result = apiTokenProperty.tokenStore.generateNewToken(tokenName)
user.save()

file.write(result.plainValue)

return