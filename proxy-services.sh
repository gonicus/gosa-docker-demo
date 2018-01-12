#!/usr/bin/env bash

# start all services needed by the GOsa backend and a Gosa proxy
# these are:
# - the backend MQTT broker (localhost:1883), which needs a backend running in localhost:8050 to authenticate
# - the proxy MQTT broker (localhost:1884), which needs a proxy running in localhost:8051 to authenticate
# - the postgres service (localhost:5432)

# you can start a proxy with these settings:
# gosa-proxy --http.port=8051 --jsonrpc=http://localhost:8051/rpc --mqtt.port=1884 --backend.mqtt-host=localhost --backend.mqtt-port=1883

HTTP_AUTH_HOST=$(hostname -s) docker-compose -f docker-compose.devel.yml $@