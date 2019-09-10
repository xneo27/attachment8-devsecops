import jenkins.model.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.plugins.credentials.impl.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
import hudson.plugins.sshslaves.*;

println "--> creating SSH credentials"

domain = Domain.global()
store = Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

ec2_private_key = new BasicSSHUserPrivateKey.DirectEntryPrivateKeySource(
        new String(IOUtils.toByteArray(getClass().getResourceAsStream("slave_id_rsa")))
)

slavesPrivateKey = new BasicSSHUserPrivateKey(
        CredentialsScope.GLOBAL,
        "jenkins-slaves",
        "ec2-user",
        ec2_private_key,
        "",
        ""
)

managersPrivateKey = new BasicSSHUserPrivateKey(
        CredentialsScope.GLOBAL,
        "swarm-managers",
        "ec2-user",
        new BasicSSHUserPrivateKey.UsersPrivateKeySource(),
        "",
        ""
)

githubCredentials = new UsernamePasswordCredentialsImpl(
        CredentialsScope.GLOBAL,
        "github", "Github credentials",
        "millgroupinc",
        "8doUMt6@zR1I"
)

//registryCredentials = new UsernamePasswordCredentialsImpl(
//        CredentialsScope.GLOBAL,
//        "registry", "Docker Registry credentials",
//        "USERNAME",
//        "PASSWORD"
//)

store.addCredentials(domain, slavesPrivateKey)
store.addCredentials(domain, managersPrivateKey)
store.addCredentials(domain, githubCredentials)
//store.addCredentials(domain, registryCredentials)