pipeline {
    agent {
        label 'jenkins-agent'
    }
    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    stages {
        stage('Checkout Source') {
            steps {
                checkout scm
            }
        }
        stage('SonarQube Analysis') {
            steps {
                tool name: 'Sonar', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                }
        }
        stage('Terraform init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform plan') {
            steps {
                sh 'terraform plan'
            }
        }
        stage('Terraform apply with manual approval') {
            steps {
                script {
                    def blueOceanUrl = "${JENKINS_URL}/blue/organizations/jenkins/${JOB_NAME}/detail/${JOB_NAME}/${BUILD_NUMBER}/pipeline"

                    emailext attachLog: true,
                             body: """
                             <p>Hi,</p> 
                             <p>You can review the build log as attached file.</p>
                             <p>Click the following link to approve:<br>
                             <a href='${BUILD_URL}input'>Click to Approve</a></p>
                             <p>View the Blue Ocean console:<br>
                             <a href='${blueOceanUrl}'>Blue Ocean Pipeline</a></p>
                             """,
                             subject: "[JENKINS] Approval Required: IaC pipeline approval - ${currentBuild.fullDisplayName}",
                             to: 'kadaiekyiphyu@gmail.com'
                }
                input id: 'Approve', message: 'Approval Required: IaC pipeline approval', ok: 'Approve', submitter: 'Team-Lead'
                sh "terraform apply --auto-approve"
            }
        }
    }
}
