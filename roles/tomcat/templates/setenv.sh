CATALINA_OPTS="${CATALINA_OPTS} -Dcom.sun.management.jmxremote.ssl=false"
CATALINA_OPTS="${CATALINA_OPTS} -Dcom.sun.management.jmxremote.authenticate=false"
CATALINA_OPTS="${CATALINA_OPTS} -Djava.rmi.server.hostname={{ansible_default_ipv4.address}}"
#CATALINA_OPTS="${CATALINA_OPTS} -Dcom.sun.management.jmxremote.access.file={{tomcat_path}}/apache-tomcat-8.0.37/conf/jmxaccess"
#CATALINA_OPTS="${CATALINA_OPTS} -Dcom.sun.management.jmxremote.password.file={{tomcat_path}}/apache-tomcat-8.0.37/conf/jmxpassword"
CATALINA_OPTS="${CATALINA_OPTS} -Xmx{{xmx}}m -Xms{{xmx}}m -Xloggc:{{tomcat_path}}/apache-tomcat-8.0.37/logs/gc.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:-PrintTenuringDistribution -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=3 -XX:GCLogFileSize=5m -Xss256k -Xverify:none -XX:+TieredCompilation -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath={{tomcat_path}}/apache-tomcat-8.0.37/logs -XX:ErrorFile={{tomcat_path}}/apache-tomcat-8.0.37/logs/hs_err_pid%p.log"
{% if debug %}
CATALINA_OPTS="${CATALINA_OPTS} -agentlib:jdwp=transport=dt_socket,server=y,address=4{{http_port}},suspend=n"
{% endif %}
{% if jvmoptions %}
CATALINA_OPTS="${CATALINA_OPTS} {{jvmoptions}}"
{% endif %}
