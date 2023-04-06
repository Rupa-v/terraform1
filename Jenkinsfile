pipeline{
    agent{
        label "Terraform"
    }
    stages{
        stage("vcs"){
            steps{
                git url: 'https://github.com/Rupa-v/terraform1.git',
                branch: 'main'
            }
        }    
        stage("terraform"){
            steps{
                sh 'terraform init'
                sh 'terraform apply -auto-approve'
            }
        }
    }
}   