#!/bin/bash

# Check for base ldif container
echo -n "[MOSQUITTO] checking for configuration: "
if [ -d /provision/mosquitto ]; then
    cp -a /provision/mosquitto/* /etc/mosquitto/conf.d

    if [ "$HTTP_AUTH_HOST" != "" ]; then
        echo -n "configured HTTP_AUTH_HOST, "

        # Hostname or IP?
        IP=$HTTP_AUTH_HOST
        if [[ ! $IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            IP=$(host $HTTP_AUTH_HOST | awk '/has address/ { print $4 }' | head -n1)
        fi

        for cfg in /etc/mosquitto/conf.d/*.conf; do
            sed -i "s/%HOST_IP%/$IP/" $cfg
        done
    fi

    echo "provisioned"
else
    echo "not found"
fi

/etc/init.d/mosquitto start
#exec tail -f /var/log/mosquitto/mosquitto.log
exec /bin/bash
