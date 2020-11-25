pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                script {
                    openshift.withCluster() {
                        openshift.withProject("${DEV_PROJECT}") {
                            if (!openshift.selector("dc", "${APPLICATION_NAME}").exists()) {
                                openshift.newApp('--as-deployment-config', '--image-stream=nodejs:12', '--code=https://github.com/cellosofia/openshift-nodejs.git', '--name=${APPLICATION_NAME}', '--strategy=source')
                                openshift.set("triggers", "dc/${APPLICATION_NAME}", "--remove-all")
                                def bc=openshift.selector("bc", "${APPLICATION_NAME}").object()
                                bc.spec.strategy.sourceStrategy.incremental=true
                                openshift.apply(bc)
                                def dc=openshift.selector("dc", "${APPLICATION_NAME}").object()
                                openshift.selector("dc/${APPLICATION_NAME}").delete()
                                openshift.newApp('--as-deployment-config', '--image-stream=${APPLICATION_NAME}', '--name=${APPLICATION_NAME}', '--allow-missing-imagestream-tags')
                                openshift.set("triggers", "dc/${APPLICATION_NAME}", "--remove-all")
                                openshift.expose("svc", "${APPLICATION_NAME}")
                                openshift.selector("bc", "${APPLICATION_NAME}").cancelBuild()
                                openshift.startBuild("${APPLICATION_NAME}", "--wait")
                            } else {
                                openshift.startBuild("${APPLICATION_NAME}", "--wait")
                            }
                        }
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    openshift.withCluster() {
                        openshift.withProject() {
                            if (openshift.selector("dc", "${APPLICATION_NAME}").exists()) {
                                openshift.selector("dc", "${APPLICATION_NAME}").rollout().latest()
                            }
                        }
                    }
                }
            }
        }
    }
}
