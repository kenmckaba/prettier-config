properties([
	buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '180', numToKeepStr: '')), [$class: 'CopyArtifactPermissionProperty', projectNames: '*'],
	[$class: 'RebuildSettings', autoRebuild: false, rebuildDisabled: false],
	[$class: 'ThrottleJobProperty', categories: [], limitOneJobWithMatchingParams: false, maxConcurrentPerNode: 1, maxConcurrentTotal: 1, paramsToUseForLimit: '', throttleEnabled: true, throttleOption: 'project'],
	parameters([
	]),
	pipelineTriggers([])
])

@Library('bluejeans')
def SLACK = new com.bluejeans.jenkins.slack()
def EMAIL = new com.bluejeans.jenkins.email()

def checkOutFromGit() {
	deleteDir()
	checkout([
		$class: 'GitSCM',
		branches: [
			[name: "*/${JOB_BASE_NAME}"]
		],
		doGenerateSubmoduleConfigurations: false,
		extensions: [
			[$class: 'SubmoduleOption', disableSubmodules: false, parentCredentials: false, recursiveSubmodules: true, reference: '', trackingSubmodules: false]
		],
		submoduleCfg: [],
		userRemoteConfigs: [
			[credentialsId: '59114b06-e16b-4654-abb3-c7691c10ad57', url: 'ssh://git@git.corp.bluejeans.com:7999/asi/bluejeans-webrtc-sdk.git']
		]
	])
}

stage('SCM') {
	node('mv1-u6b-001') {
		checkOutFromGit()
	}
}

def build(slackName, slackNotifier, emailNotifier) {
	try {
        
		withCredentials([usernamePassword(credentialsId: 'bjn-private-npm-publish-token', passwordVariable: 'NPM_PUBLISH_TOKEN', usernameVariable: 'NOT_USED`')]) {
			// Try to produce build
			// sh(script: "bash build.sh ${BUILD_NUMBER} ${JOB_BASE_NAME} ${NPM_PUBLISH_TOKEN}");
			if (params["RELEASE_BUILD"] == "Yes") {
				sh(script: "bash build/setupExamplesRepo.sh ${JOB_BASE_NAME}")
				sh(script: "bash build/prepareFinalBuild.sh ${JOB_BASE_NAME} ${BUILD_NUMBER}")
			} else {
				sh(script: "bash build.sh ${BUILD_NUMBER} ${JOB_BASE_NAME} ${NPM_PUBLISH_TOKEN}");
			}
		}
	} catch (e) {
		emailNotifier.emailNotify(attachlog: true, status: 'FAILED')
		currentBuild.result = 'FAILURE'
		error("Build Failed. ${e}")
	} finally {
		emailNotifier.emailNotifyWhenBuildBackToNormal(attachlog: true, status: 'SUCCEED')
	}
}

stage('Build') {
	node('mv1-u6b-001') {
		build("${JOB_NAME}", SLACK, EMAIL)
	}		
}

stage('Archive') {
	node('mv1-u6b-001') {
		archiveArtifacts 'artifacts/**/*.*'
	}
}