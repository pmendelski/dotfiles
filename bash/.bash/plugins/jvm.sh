#!/bin/bash

# JVM Environment
if hash update-alternatives 2>/dev/null; then
  export JAVA_HOME="$(update-alternatives --get-selections | grep -e "^java " | tr -s " " | cut -d " " -f 3 | sed -s "s|/jre/bin/java||" | sed -s "s|/bin/java||")"
  export ANT_HOME="$(update-alternatives --get-selections | grep -e "^ant " | tr -s " " | cut -d " " -f 3 | sed -s "s|/bin/ant||")"
  export MAVEN_HOME="$(update-alternatives --get-selections | grep -e "^mvn " | tr -s " " | cut -d " " -f 3 | sed -s "s|/bin/mvn||")"
  export M2_HOME="$MAVEN_HOME"
  export MVN_HOME="$MAVEN_HOME"
  export GROOVY_HOME="$(update-alternatives --get-selections | grep -e "^groovy " | tr -s " " | cut -d " " -f 3 | sed -s "s|/bin/groovy||")"
  export GRADLE_HOME="$(update-alternatives --get-selections | grep -e "^gradle " | tr -s " " | cut -d " " -f 3 | sed -s "s|/bin/gradle||")"
  export SCALA_HOME="$(update-alternatives --get-selections | grep -e "^scala " | tr -s " " | cut -d " " -f 3 | sed -s "s|/bin/scala||")"
  export SBT_HOME="$(update-alternatives --get-selections | grep -e "^sbt " | tr -s " " | cut -d " " -f 3 | sed -s "s|/sbt||")"
fi
