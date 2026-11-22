#!/bin/sh

PATH="/app/bin:/app/jre/bin:/usr/bin"
SOAPUI_HOME="/app"
SOAPUI_JAR=`ls /app/bin/soapui-*.jar`
JFXRTPATH="/app/jre/lib/jfxrt.jar"
SOAPUI_CLASSPATH=$JFXRTPATH:$SOAPUI_JAR:$SOAPUI_HOME/lib/*:$XDG_DATA_HOME/soapuios/lib/*
USER_JAVA_OPTS="$JAVA_OPTS"

# Using ~/.soapuios since it is already hardcoded in SoapUI for other files
SOAPUI_CONFIG_HOME="$HOME/.soapuios"

# Define paths in the user folder so it can add their own files
SOAPUI_EXT_LIBRARIES="${SOAPUI_CONFIG_HOME}/ext"
SOAPUI_EXT_LISTENERS="${SOAPUI_CONFIG_HOME}/listeners"
SOAPUI_EXT_ACTIONS="${SOAPUI_CONFIG_HOME}/actions"

# Initialize the configuration folders and files
mkdir -p "$SOAPUI_CONFIG_HOME" "$SOAPUI_EXT_LIBRARIES" "$SOAPUI_EXT_LISTENERS" "$SOAPUI_EXT_ACTIONS"
# [ -e "$SOAPUI_CONFIG_HOME/soapui.properties" ] || touch "$SOAPUI_CONFIG_HOME/soapui.properties"
# Hacks to allow persist configuration across executions since persist option don't work well with plain files
[ -e "$HOME/default-soapui-workspace.xml" ] || ln -s "$SOAPUI_CONFIG_HOME/default-soapui-workspace.xml" "$HOME/default-soapui-workspace.xml"
[ -e "$HOME/soapui-settings.xml" ] || ln -s "$SOAPUI_CONFIG_HOME/soapui-settings.xml" "$HOME/soapui-settings.xml"

#JAVA OPTS
JAVA_OPTS="-Xms128m -Xmx1024m -XX:MinHeapFreeRatio=20 -XX:MaxHeapFreeRatio=40 -XX:-UseBASE64Intrinsics"
JAVA_OPTS="$JAVA_OPTS -Dsoapui.properties=${SOAPUI_CONFIG_HOME}/soapui.properties"
JAVA_OPTS="$JAVA_OPTS -Dsoapui.home=${SOAPUI_HOME}/bin -splash:SoapUI-Spashscreen.png"
JAVA_OPTS="$JAVA_OPTS -Dsoapui.ext.libraries=${SOAPUI_EXT_LIBRARIES}"
JAVA_OPTS="$JAVA_OPTS -Dsoapui.ext.listeners=${SOAPUI_EXT_LISTENERS}"
JAVA_OPTS="$JAVA_OPTS -Dsoapui.ext.actions=${SOAPUI_EXT_ACTIONS}"
JAVA_OPTS="$JAVA_OPTS -Djava.library.path=${SOAPUI_HOME}/bin"
JAVA_OPTS="$JAVA_OPTS -Dwsi.dir=${SOAPUI_HOME}/wsi-test-tools"
#uncomment to disable browser component
#JAVA_OPTS="$JAVA_OPTS -Dsoapui.browser.disabled=true"
#CVE-2021-44228
JAVA_OPTS="$JAVA_OPTS -Dlog4j2.formatMsgNoLookups=true"
#JAVA 17
JAVA_OPTS="$JAVA_OPTS --add-opens java.base/java.lang=ALL-UNNAMED --add-opens java.base/java.lang.invoke=ALL-UNNAMED --add-opens java.desktop/java.beans=ALL-UNNAMED --add-opens java.base/java.util=ALL-UNNAMED --add-opens java.base/java.lang.reflect=ALL-UNNAMED --add-opens java.base/java.util.concurrent.atomic=ALL-UNNAMED --add-opens java.xml/com.sun.org.apache.xerces.internal.util=ALL-UNNAMED --add-opens java.base/java.net=ALL-UNNAMED --add-opens java.desktop/java.awt=ALL-UNNAMED --add-opens java.desktop/javax.swing=ALL-UNNAMED --add-opens java.base/sun.net.www=ALL-UNNAMED --add-opens java.base/sun.net.www.protocol.https=ALL-UNNAMED --add-opens java.base/sun.net.www.protocol.http=ALL-UNNAMED --add-opens java.desktop/javax.swing.plaf=ALL-UNNAMED --add-opens java.desktop/javax.swing.plaf.basic=ALL-UNNAMED --add-opens jdk.jdi/com.sun.jdi=ALL-UNNAMED --add-opens java.prefs/java.util.prefs=ALL-UNNAMED"

# Allow custom user JAVA_OPTS overrides
if [ -n "$USER_JAVA_OPTS" ]; then
  echo "WARNING: Adding additional user JAVA_OPTS: $USER_JAVA_OPTS" > /dev/stderr
  JAVA_OPTS="$JAVA_OPTS $USER_JAVA_OPTS"
fi

export PATH
export SOAPUI_HOME
export SOAPUI_CLASSPATH
export JAVA_OPTS

exec java $JAVA_OPTS -cp $SOAPUI_CLASSPATH com.eviware.soapui.SoapUI "$@"
