#!/usr/bin/env groovy
node('ruby2.3') {

  // Define environment variables
  env.SITE                       = 'https://secure.affinipay.com'
  env.OAUTH2_CLIENT_ID           = '075e9fa745b46c4bd17f73cebca166db97bd0fd6a009cc330af29921caf001e4'
  env.OAUTH2_CLIENT_SECRET       = '9d8f9c46e6596c0d19be750065c3db8fb386e842d1707e6f80251465baf7a359'
  env.OAUTH2_CLIENT_REDIRECT_URI = 'http://127.0.0.1:9292/callback'
  env.GATEWAY_URI                = 'https://api.chargeio.com'
  env.GATEWAY_PUBLIC_KEY         = 'm_j3XzSirYTEyAuOznTGoX_w'
  env.GATEWAY_SECRET_KEY         = 'GzfVY2OwQ1a-_vvvYbN_hQKr2hGYJdJSgXMLUBZinTkQ1JkNcOw18AIRYRLeNLz6'
  env.API_APPLICATION_ID         = '000'
  env.API_CLIENT_KEY             = '000'
  env.ACCESS_TOKEN               = '000'
  env.MERCHANT_INFO              = '{"access_token":"ed1bb95781ff3b0938136e1a2c26c2c33504b2af4b6a96dace1b445c91e0b959","test_accounts":[{"id":"G0Y5h6W-TYG026YcQAyVTg","name":"TEST","type":"MerchantAccount","currency":"USD","recurring_charges_enabled":true,"public_key":"m_j3XzSirYTEyAuOznTGoX_w","secret_key":"sC4aCAQfSh-A7x4zhUOBEg7sI3HZxyvoAyZnc4m5AJTxHRaQekoc6g80xhNMcZM0","trust_account":false}]}'
  env.TEST_RESULTS               = 'Example/build/reports/junit.xml'

  // Product variables
  env.BASE_PRODUCT_NAME          = 'app-integration-example-ruby'

  // Build version variables
  env.BUILD_VERSION              = '1.0.0'
  env.BUILD_VERSION_AND_BUILDNUM = 'UNKNOWN'
  env.BUILD_ARCHIVE_NAME         = 'UNKNOWN'

  def internalRepo = "git@bitbucket.org:affinipay/app-integration-example-ruby.git"
  def publicRepo = "git@github.com:affinipay/app-integration-example-ruby.git"

  // Build parameterts
  properties([[$class: 'ParametersDefinitionProperty', parameterDefinitions: [[$class: 'StringParameterDefinition', name: 'UserEmail', defaultValue: 'usharma@affinipay.com'], [$class: 'StringParameterDefinition', name: 'TestName', defaultValue: '*']]]])

  // Try build stages
  try {
    if (env.BRANCH_NAME =~ /^v\d+\.\d+\.\d+-b\d+$/) {
      // If env.BRANCH_NAME is a string with format 'vA.B.C-bT' where
      //    A, B, C, and T and integers (eg: v1.0.2-b101),
      // 1) Download S3 artifact using the version in env.BRANCH_NAME, on an AWS node
      // 2) Stash artifact
      // 3) Unstash the artifact on the build node
      // 4) Push artifact to NuGet.
      // 5) Create and push a tag with format 'Released-vA.B.C-bT' where
      //    A.B.C is the version and T is the build number (eg: v1.0.2-b101)
      echo "I need to publish ${BRANCH_NAME}!"
      stages_Publish_Prepare(env.BRANCH_NAME)
      stages_Publish_DownloadFromS3(env.BRANCH_NAME)
      stages_Publish_Finalize(env.BRANCH_NAME)

    } else {
      // 1) Prepare environment, Build, Test, and generate artifact
      // 2) If this is a 'master' build:
      //    a) Archive the artifact in jenkins
      //    b) Upload the artifact to S3
      // 3) Create and push a tag with format 'vA.B.C-bT' where
      //    A.B.C is the version and T is the build number (eg: v1.0.2-b101)
      stages_Prepare()
      stages_Build()
      stages_Test()
      stages_Publish()

      if (env.BRANCH_NAME == "master") {
        stages_Archive()
      }
    }

    currentBuild.result = 'SUCCESS'
    notifyBuildResult(currentBuild.result)
    bitbucketStatusNotify(buildState: 'SUCCESSFUL', credentialsId: '6e598f39-dc2c-45c3-8e2e-20eb59439759')
  }
  // Catch an handle errors in build pipeline
  catch(e) {
    currentBuild.result = 'FAILED'
    notifyBuildResult(currentBuild.result)
    emailFailed("${params.UserEmail}", e)
    bitbucketStatusNotify(buildState: 'FAILED', credentialsId: '6e598f39-dc2c-45c3-8e2e-20eb59439759')
    throw(e)
  }
}

/*
 * Build stages
 *
 * Each stage is expected to run in the top level node sepcified at the top of
 * this file. If a stage needs to run on another node, it should perform its
 * operations within a "node('<node_name>') {}" block where <nide_name> is the
 * desired node tag.
 */
 def stages_Prepare() {
   stage('Prepare') {
       // Check out source
       checkoutSources()

       // Get version from lib/ChargeIO/ChargeIO.php
       env.BUILD_VERSION_AND_BUILDNUM = env.BUILD_VERSION + '-b' + env.BUILD_NUMBER
       echo 'Version: ' + env.BUILD_VERSION_AND_BUILDNUM

       // Update build status
       bitbucketStatusNotify(buildState: 'INPROGRESS', credentialsId: '6e598f39-dc2c-45c3-8e2e-20eb59439759')
   }
}

def stages_Build() {
  stage('Install Gems') {
        sh 'bundle install'
  }
}

def stages_Test() {
  stage('Test') {
    sh ' echo "${MERCHANT_INFO}" > merchant_info.json '

    echo 'Running the test(s)'
    sh """
      #!/bin/bash
      SITE=${SITE} \
      OAUTH2_CLIENT_ID=${OAUTH2_CLIENT_ID} \
      OAUTH2_CLIENT_SECRET=${OAUTH2_CLIENT_SECRET} \
      OAUTH2_CLIENT_REDIRECT_URI=${OAUTH2_CLIENT_REDIRECT_URI} \
      GATEWAY_URI=${GATEWAY_URI} \
      GATEWAY_PUBLIC_KEY=${GATEWAY_PUBLIC_KEY} \
      GATEWAY_SECRET_KEY=${GATEWAY_SECRET_KEY} \
      API_APPLICATION_ID=${API_APPLICATION_ID} \
      API_CLIENT_KEY=${API_CLIENT_KEY} \
      ACCESS_TOKEN=${ACCESS_TOKEN} \
      bundle exec rspec spec/${params.TestName} \
      --format doc \
      --format RspecJunitFormatter --out ${TEST_RESULTS}
    """
  }
}


def stages_Publish() {
  stage('Publish Results') {
    publishResults()

    // Clean up files
    sh "ls -al"
    sh "rm test_account.out || true"
    sh "rm test_merchant_info.json || true"
    sh "rm test_sanitized_merchant_info.json || true"
    sh "rm test_stored_merchant_info.json || true"
    sh "rm -rf Example || true"
    sh "ls -al"
  }
}

def stages_Archive() {
  stage('Tag') {
    // Version name
    versionName =  "v${env.BUILD_VERSION_AND_BUILDNUM}"
    env.BUILD_ARCHIVE_NAME = "${BASE_PRODUCT_NAME}-" + versionName

    // Push version tag
    gitTag versionName
  }
}

// Build stage to prepare for publishing
def stages_Publish_Prepare(nameString) {
    stage('Prepare') {
      input "WARNING: This job will attempt to publish $nameString to the world. Are you sure this is what you want?"

      // Remove all existing files
      sh "rm -rf *"

      // Checkout sources
      checkoutSources()

      // Update build status
      bitbucketStatusNotify(buildState: 'INPROGRESS', credentialsId: '6e598f39-dc2c-45c3-8e2e-20eb59439759')
    }
}

// Build stage to download a specific version of an artifact from S3, and stash it
def stages_Publish_DownloadFromS3(nameString) {
    // stage ('Get archive') {
    //   fileName = "${BASE_PRODUCT_NAME}-" + nameString + ".tar.gz"
    //   sh 'rm -rf *'
    //   s3.download(fileName, "${env.BASE_PRODUCT_NAME}", "${env.S3_ENVIRONMENT}")
    //   sh 'ls -al'
    // }
}

// Build stage to unstash an artifact and push it to the world.
def stages_Publish_Finalize(nameString) {
    stage('Publish') {
      sh 'ls -al'
      echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
      echo "=- This is supposed to be the final publish step!  -="
      echo "=-                                                 -="
      echo "=- 1) Publish source to GitHub master              -="
      echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="

      // Publish source to GitHub
      stages_Publish_Source(nameString)

      // Push release tag
      releasedTagName = "Released-" + nameString
      gitTag releasedTagName
    }
}

def stages_Publish_Source(nameString){
  stage("Publish Source"){
    echo "Publishing: Release " + nameString
    gitMasterToPublicBranch(internalRepo, publicRepo, "Release " + nameString)
  }
}

/*
 * Helpers
 */
// Helper for notifying Slack
def notifyBuildResult(String result) {
    def colorCode = (result == 'SUCCESS') ? '#36A64F' : '#D00000'
    def msg = "${env.JOB_NAME} [${env.BUILD_NUMBER}] ${result} (<${env.BUILD_URL}|Open>)"
    slackSend (channel: "#devtools", color: colorCode, message: msg)
}

def checkoutSources() {
  // Check out source
  // https://stackoverflow.com/a/38255364/123336
  def scmUrl = scm.getUserRemoteConfigs()[0].getUrl()
  def scmCredentialsId = scm.getUserRemoteConfigs()[0].getCredentialsId()

  checkout([$class: 'GitSCM',
      branches: [[name: "${env.BRANCH_NAME}"]],
      doGenerateSubmoduleConfigurations: false,
      extensions: [[$class: 'SubmoduleOption',
          disableSubmodules: false,
          parentCredentials: false,
          recursiveSubmodules: true,
          reference: '',
          trackingSubmodules: false]],
      submoduleCfg: [],
      userRemoteConfigs: [[credentialsId: scmCredentialsId, url: scmUrl]]])

  // Check out common functions
  library identifier: 'jenkins-pipeline-library@master', retriever: modernSCM(
    [$class: 'GitSCMSource',
     remote: 'git@bitbucket.org:affinipay/jenkins-pipeline-library.git',
     credentialsId: scm.getUserRemoteConfigs()[0].getCredentialsId()])
}

def publishResults() {
    junit allowEmptyResults: false, keepLongStdio: true, testResults: "${TEST_RESULTS}"
}

def emailFailed(email_to, error) {
    def msg = null
    if (!error) {
        msg = 'Error during build. You should fix it.\n${env.BUILD_URL}'
    }
    else {
        msg = "Error during ${env.STAGE_NAME} stage. You should fix it.\n${env.BUILD_URL} \n\n Error:\n ${error.getMessage()}"
    }
    mail subject: "Something is wrong with ${env.JOB_NAME} ${env.BUILD_ID}",
    to: email_to,
    body: msg
}
