#!/bin/bash
#
# chkconfig: 345 99 28
# description: Starts/Stops Apache Tomcat
#
# Tomcat 7 start/stop/status script
# Forked from: https://gist.github.com/valotas/1000094
# @author: Miglen Evlogiev <bash@miglen.com>
#
# Release updates:
# Updated method for gathering pid of the current proccess
# Added usage of CATALINA_BASE
# Added coloring and additional status
# Added check for existence of the tomcat user
#
 
#Location of JAVA_HOME (bin files)
export JAVA_HOME=/usr/lib/jvm/jre
export ENV_CODE={{env_code}} 
#Add Java binary files to PATH
export PATH=$JAVA_HOME/bin:$PATH
 
#CATALINA_HOME is the location of the bin files of Tomcat  
export CATALINA_HOME=/opt/{{ project_name }}/apache-tomcat-8.0.37
 
#CATALINA_BASE is the location of the configuration files of this instance of Tomcat
export CATALINA_BASE=/opt/{{ project_name }}/apache-tomcat-8.0.37
 
#TOMCAT_USER is the default user of tomcat
export TOMCAT_USER=tomcat
 
#TOMCAT_USAGE is the message if this script is called without any options
TOMCAT_USAGE="Usage: $0 {\e[00;32mstart\e[00m|\e[00;31mstop\e[00m|\e[00;32mstatus\e[00m|\e[00;31mrestart\e[00m}"
 
#SHUTDOWN_WAIT is wait time in seconds for java proccess to stop
SHUTDOWN_WAIT=8
 
tomcat_pid() {
        echo `ps -fe | grep $CATALINA_BASE | grep -v grep | tr -s " "|cut -d" " -f2`
}
 
start() {
  cd $CATALINA_HOME
  pid=$(tomcat_pid)
  user=`whoami`
  if [ -n "$pid" ]
  then
    echo -e "Tomcat is already running (pid: $pid)"
  else
    # Start tomcat
    echo -e "Starting tomcat"
    #ulimit -n 100000
    #umask 007
    #/bin/su -p -s /bin/sh tomcat
        if [ $user = $TOMCAT_USER ]; then
            sh $CATALINA_HOME/bin/startup.sh
        else
            su $TOMCAT_USER -c $CATALINA_HOME/bin/startup.sh
        fi
        #if [ `user_exists $TOMCAT_USER` = "1" ]
        #then
                #su $TOMCAT_USER -c $CATALINA_HOME/bin/startup.sh
        #        sh $CATALINA_HOME/bin/startup.sh
        #else
        #        sh $CATALINA_HOME/bin/startup.sh
        #fi
        status
  fi
  return 0
}
 
status(){
          pid=$(tomcat_pid)
          if [ -n "$pid" ]; then echo -e "{{ project_name }} Tomcat is running with pid: $pid"
          else echo -e "{{ project_name }} Tomcat is not running"
          fi
}
 
stop() {
  pid=$(tomcat_pid)
  if [ -n "$pid" ]
  then
    echo -e "Stoping Tomcat"
    #/bin/su -p -s /bin/sh tomcat
        sh $CATALINA_HOME/bin/shutdown.sh
 
    let kwait=$SHUTDOWN_WAIT
    count=0;
    until [ `ps -p $pid | grep -c $pid` = '0' ] || [ $count -gt $kwait ]
    do
      echo -n -e "\nwaiting for processes to exit";
      sleep 1
      let count=$count+1;
    done
 
    if [ $count -gt $kwait ]; then
      echo -n -e "\nkilling processes which didn't stop after $SHUTDOWN_WAIT seconds"
      kill -9 $pid
    fi
  else
    echo -e "Tomcat is not running"
  fi
 
  return 0
}
 
user_exists(){
        if id -u $1 >/dev/null 2>&1; then
        echo "1"
        else
                echo "0"
        fi
}
 
case $1 in
 
        start)
          start
        ;;
       
        stop)  
          stop
        ;;
       
        restart)
          stop
          start
        ;;
       
        status)
                status
               
        ;;
       
        *)
                echo -e $TOMCAT_USAGE
        ;;
esac    
exit 0
