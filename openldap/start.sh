#!/bin/sh

# Check for base ldif container
echo -n "[SLAPD] checking for base configuration: "
if [ ! -f /var/lib/ldap/alock ]; then
    chown -R root:$LDAP_GROUP /etc/ldap

    if [ -f /provision/base.ldif ]; then
        slapadd -l /provision/base.ldif -b dc=example,dc=net &> /tmp/slapadd.log

        if [ $? -ne 0 ]; then
            echo "failed\n\n"
            cat /tmp/slapadd.log
        else
            chown -R $LDAP_USER:$LDAP_GROUP /var/lib/ldap
            echo "provisioned"
        fi
    else
        echo "missing"
    fi
else
    echo "found"
fi

exec /usr/sbin/slapd -u openldap
