credentials:
  system:
    domainCredentials:
      - credentials:
          - string:
              scope: GLOBAL
              id: "github"
              secret: "${secret}" #Load from Environment Variable
              description: "${description}"

jobs:
  - script: >
      multibranchPipelineJob('image-jenkins') {
        branchSources {
          github {
            // The id option in the Git and GitHub branch source contexts is now mandatory (JENKINS-43693).
            id('12312313') // IMPORTANT: use a constant and unique identifier
            scanCredentialsId('github')
            repoOwner('${owner}')
            repository('${repository}')
          }
        }
        orphanedItemStrategy {
          discardOldItems {
            numToKeep(1)
          }
        }
        triggers {
          periodic(5)
        }
      }