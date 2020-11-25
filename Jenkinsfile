pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                script {
                    openshift.withCluster() {
                        openshift.withProject("${DEV_PROJECT}") {
                            if (!openshift.selector("dc", "myapp").exists()) {
                                openshift.newApp('--as-deployment-config', '--image-stream=nodejs:12', '--code=https://github.com/cellosofia/openshift-nodejs.git', '--name=myapp', '--strategy=source')
                                openshift.set("triggers", "dc/myapp", "--remove-all")
                                def bc=openshift.selector("bc", "myapp").object()
                                bc.spec.strategy.sourceStrategy.incremental=true
                                openshift.apply(bc)
                                def dc=openshift.selector("dc", "myapp").object()
                                openshift.selector("dc/myapp").delete()
                                openshift.newApp('--as-deployment-config', '--image-stream=myapp', '--name=myapp', '--allow-missing-imagestream-tags')
                                openshift.set("triggers", "dc/myapp", "--remove-all")
                                openshift.expose("svc", "myapp")
                                openshift.selector("bc", "myapp").cancelBuild()
                                openshift.startBuild("myapp", "--wait")
                            } else {
                                openshift.startBuild("myapp", "--wait")
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
                            if (openshift.selector("dc", "myapp").exists()) {
                                openshift.selector("dc", "myapp").rollout().latest()
                            }
                        }
                    }
                }
            }
        }
    }
}
