kubectl exec zmc-mailbox-2 -- ps -ef | grep /opt/zimbra/mailboxd/etc/jetty.xml | grep -v grep  | awk '{print $1}' | xargs kill -9
