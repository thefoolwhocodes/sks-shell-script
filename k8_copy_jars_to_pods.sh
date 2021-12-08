#!/bin/bash -x

if [ "$#" -ne 2 ]
then
    echo "Usage: $0 <pod name:zmc-mailbox-0/zmc-mailbox-1/all> <jar:common/store/all>"
    exit
fi

mailbox=$1
echo "$mailbox"

jar=$2
echo "$jar"

common_jar="zm-common-8.8.0.1637265606.jar"
store_jar="zm-store-8.8.0.1637265606.jar"

if [ "$jar" == "common" ];
then
    if [ "$mailbox" == "all" ];
    then
        for pod in $(kubectl get pods | grep mailbox | awk '{print $1}'); do
			kubectl exec "$pod" -- touch /tmp/PASS-LIVENESS
			m_pid=$(kubectl exec "$pod" -- ps -ef | grep mailboxd/etc/jetty.xml | grep -v grep  | awk '{print $1}')
			kubectl exec -it "$pod" -- kill -9 "$m_pid"
			kubectl cp "$common_jar" "$pod":/opt/zimbra/lib/jars/zimbracommon.jar
			kubectl exec -it "$pod" -- chmod 444 /opt/zimbra/lib/jars/zimbracommon.jar
			kubectl exec -it "$pod" -- chown root:root /opt/zimbra/lib/jars/zimbracommon.jar
			kubectl exec "$pod" -- ./startup.sh
        done
    else
		kubectl exec "$mailbox" -- touch /tmp/PASS-LIVENESS
		m_pid=$(kubectl exec "$mailbox" -- ps -ef | grep mailboxd/etc/jetty.xml | grep -v grep  | awk '{print $1}')
		kubectl exec -it "$mailbox" -- kill -9 "$m_pid"
		kubectl cp "$common_jar" "$mailbox":/opt/zimbra/lib/jars/zimbracommon.jar
		kubectl exec -it "$mailbox" -- chmod 444 /opt/zimbra/lib/jars/zimbracommon.jar
		kubectl exec -it "$mailbox" -- chown root:root /opt/zimbra/lib/jars/zimbracommon.jar
		kubectl exec "$mailbox" -- ./startup.sh
    fi

elif [ "$jar" == "store" ];
then
    if [ "$mailbox" == "all" ];
    then
        for pod in $(kubectl get pods | grep mailbox | awk '{print $1}'); do
            kubectl exec "$pod" -- touch /tmp/PASS-LIVENESS
            m_pid=$(kubectl exec "$pod" -- ps -ef | grep mailboxd/etc/jetty.xml | grep -v grep  | awk '{print $1}')
            kubectl exec -it "$pod" -- kill -9 "$m_pid"
            kubectl cp "$store_jar" "$pod":/opt/zimbra/lib/jars/zimbrastore.jar
            kubectl exec -it "$pod" -- chmod 444 /opt/zimbra/lib/jars/zimbrastore.jar
            kubectl exec -it "$pod" -- chown root:root /opt/zimbra/lib/jars/zimbrastore.jar
            kubectl exec "$pod" -- ./startup.sh
        done
    else
	    kubectl exec "$mailbox" -- touch /tmp/PASS-LIVENESS
	    m_pid=$(kubectl exec "$mailbox" -- ps -ef | grep mailboxd/etc/jetty.xml | grep -v grep  | awk '{print $1}')
	    kubectl exec -it "$mailbox" -- kill -9 "$m_pid"
        kubectl cp "$store_jar" "$mailbox":/opt/zimbra/lib/jars/zimbrastore.jar
        kubectl exec -it "$mailbox" -- chmod 444 /opt/zimbra/lib/jars/zimbrastore.jar
        kubectl exec -it "$mailbox" -- chown root:root /opt/zimbra/lib/jars/zimbrastore.jar
	    kubectl exec "$mailbox" -- ./startup.sh
    fi

elif [ "$jar" == "all" ];
then
	if [ "$mailbox" == "all" ];
	then
		for pod in $(kubectl get pods | grep mailbox | awk '{print $1}'); do
			kubectl exec "$pod" -- touch /tmp/PASS-LIVENESS
			m_pid=$(kubectl exec "$pod" -- ps -ef | grep mailboxd/etc/jetty.xml | grep -v grep  | awk '{print $1}')
			kubectl exec -it "$pod" -- kill -9 "$m_pid"
			kubectl cp "$common_jar" "$pod":/opt/zimbra/lib/jars/zimbracommon.jar
			kubectl exec -it "$pod" -- chmod 444 /opt/zimbra/lib/jars/zimbracommon.jar
			kubectl exec -it "$pod" -- chown root:root /opt/zimbra/lib/jars/zimbracommon.jar
			kubectl cp "$store_jar" "$pod":/opt/zimbra/lib/jars/zimbrastore.jar
			kubectl exec -it "$pod" -- chmod 444 /opt/zimbra/lib/jars/zimbrastore.jar
			kubectl exec -it "$pod" -- chown root:root /opt/zimbra/lib/jars/zimbrastore.jar	
			kubectl exec "$pod" -- ./startup.sh
		done
	else
		kubectl exec "$mailbox" -- touch /tmp/PASS-LIVENESS
		kubectl exec "$mailbox" -- touch /tmp/PASS-LIVENESS
		m_pid=$(kubectl exec "$mailbox" -- ps -ef | grep mailboxd/etc/jetty.xml | grep -v grep  | awk '{print $1}')
		kubectl exec -it "$mailbox" -- kill -9 "$m_pid"
		kubectl cp "$common_jar" "$mailbox":/opt/zimbra/lib/jars/zimbracommon.jar
		kubectl exec -it "$mailbox" -- chmod 444 /opt/zimbra/lib/jars/zimbracommon.jar
		kubectl exec -it "$mailbox" -- chown root:root /opt/zimbra/lib/jars/zimbracommon.jar
		kubectl cp "$store_jar" "$mailbox":/opt/zimbra/lib/jars/zimbrastore.jar
		kubectl exec -it "$mailbox" -- chmod 444 /opt/zimbra/lib/jars/zimbrastore.jar
		kubectl exec -it "$mailbox" -- chown root:root /opt/zimbra/lib/jars/zimbrastore.jar
		kubectl exec "$mailbox" -- ./startup.sh	
	fi
fi

