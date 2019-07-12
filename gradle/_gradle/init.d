// Enable build scans by default
// https://guides.gradle.org/creating-build-scans/#enable_build_scans_for_all_builds_optional
initscript {
  repositories {
    gradlePluginPortal()
  }

  dependencies {
    classpath 'com.gradle:build-scan-plugin:@scanPluginVersion@'
  }
}

rootProject {
  apply plugin: com.gradle.scan.plugin.BuildScanPlugin

  buildScan {
    termsOfServiceUrl = 'https://gradle.com/terms-of-service'
    termsOfServiceAgree = 'yes'
  }
}
