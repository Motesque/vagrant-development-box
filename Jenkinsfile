/*

Jenkinsfile
ottobock

*/

pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                cleanWs()
                checkout scm
            }
        }
        stage('Build') {
            steps {
                sh '. ./jenkins.sh'

            }
        }

        stage('Package') {
            steps {
                archiveArtifacts 'motesque_dev*.box'
            }
        }

        stage('Publish') {
            steps {
                 sshPublisher(
                    publishers: [
                        sshPublisherDesc (
                            configName: 'nyc3-download-01.motesque.com/VagrantBoxes',
                            transfers: [
                                sshTransfer(
                                    cleanRemote: false,
                                    excludes: '',
                                    execCommand: '',
                                    execTimeout: 120000,
                                    flatten: false,
                                    makeEmptyDirs: false,
                                    noDefaultExcludes: false,
                                    patternSeparator: '[, ]+',
                                    remoteDirectory: '',
                                    remoteDirectorySDF: false,
                                    removePrefix: '',
                                    sourceFiles: 'motesque_dev*.box'
                                )
                            ],
                            usePromotionTimestamp: false,
                            useWorkspaceInPromotion: false,
                            verbose: false
                        )
                    ]
                 )
            }
        }
    }
    post {
        success {
            slackSend (channel: "devops",
                        color: "good",
                        message: "SUCCESSFUL: Job ${env.JOB_NAME} [${env.BUILD_NUMBER}] (${env.BUILD_URL})")
        }
        failure {
            slackSend (channel: "devops",
                        color: "warning",
                        message: "FAILURE: Job ${env.JOB_NAME} [${env.BUILD_NUMBER}] (${env.BUILD_URL})")

            emailext body: "${currentBuild.currentResult}: Job ${env.JOB_NAME} build ${env.BUILD_NUMBER}\n More info at: ${env.BUILD_URL}",
                     subject: "Jenkins Build ${currentBuild.currentResult}: Job ${env.JOB_NAME}",
                     to: "daniel.galvao@motesque.com tobias@motesque.com"
        }
    }
}