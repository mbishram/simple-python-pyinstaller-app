node {
    checkout scm

    docker.image('python:alpine3.21').inside {
        stage('Build') {
            sh 'python -m py_compile sources/add2vals.py sources/calc.py'
        }
    }
    docker.image('qnib/pytest').inside {
        try {
            stage('Test') {
                sh 'py.test --verbose --junit-xml test-reports/results.xml sources/test_calc.py'
            }
        } finally {
            junit 'test-reports/results.xml'
        }
    }
    stage('Approval') {
        input message: 'Lanjutkan ke tahap Deploy?'
    }
    docker.image('python:bullseye').inside('-u root') {
        stage('Deploy') {
            sh 'pip install pyinstaller'
            sh 'pyinstaller --onefile sources/add2vals.py'

            echo "Sleep start at: ${new Date()}"
            sleep time: 1, unit: "MINUTES"
            echo "Sleep ended at: ${new Date()}"

            archiveArtifacts 'dist/add2vals'
        }
    }
}
