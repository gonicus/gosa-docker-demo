#!/bin/bash

# Check for base ldif container
echo -n "[MOSQUITTO] checking for configuration: "
if [ -d /provision/mosquitto ]; then
    cp -a /provision/mosquitto/* /etc/mosquitto/conf.d

    if [ "$HTTP_AUTH_HOST" != "" ]; then
        echo -n "configured HTTP_AUTH_HOST: "

        # Hostname or IP?
        IP=$HTTP_AUTH_HOST
        if [ "$HTTP_AUTH_PORT" == "" ]; then
            HTTP_AUTH_PORT=8050
        fi
        echo -n "$HTTP_AUTH_HOST:$HTTP_AUTH_PORT, "
        if [[ ! $IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            IP=$(getent hosts $HTTP_AUTH_HOST | cut -d\  -f1 | head -n1)

            # Wait until the name resolves
            while [ -z "$IP" ]; do
                sleep .5
                echo -n "."
                IP=$(getent hosts $HTTP_AUTH_HOST | cut -d\  -f1 | head -n1)
            done
        fi

        for cfg in /etc/mosquitto/conf.d/*.conf; do
            sed -i "s/%HOST_IP%/$IP/" $cfg
            sed -i "s/%HOST_PORT%/$HTTP_AUTH_PORT/" $cfg
        done
    fi

    echo "provisioned"
else
    echo "not found"
fi

if [ "$MQTT_PORT" == "" ]; then
    MQTT_PORT=1883
fi

for cfg in /etc/mosquitto/conf.d/*.conf; do
    sed -i "s/%MQTT_PORT%/$MQTT_PORT/" $cfg
done

echo "-----"
echo "Host: $HTTP_AUTH_HOST"
getent hosts $HTTP_AUTH_HOST
echo "-----"

exec /usr/sbin/mosquitto -v -c /etc/mosquitto/mosquitto.conf
