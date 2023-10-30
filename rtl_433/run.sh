#!/usr/bin/with-contenv bashio

conf_directory="/config/rtl_433"
conf_file="rtl_433.conf"

if [ ! -d "$conf_directory" ]; then
    mkdir -p "$conf_directory"
fi

if [ ! -f "$conf_directory/$conf_file" ]; then
    wget https://raw.githubusercontent.com/catduckgnaf/rtl_433_ha/main/config/rtl_433.conf -O "$conf_directory/$conf_file"
fi

if output_options=$(bashio::config "websocket"); then
    host=$(bashio::config "ws_http_host")
    port=$(bashio::config "ws_http_port")
    echo "Starting rtl_433 with Websocket Option $conf_file..."
    rtl_433 -c "/config/rtl_433/$conf_file" -F "http://$host:$port"
else
    if output_options=$(bashio::config "mqtt"); then
        host=$(bashio::services "mqtt" "host")
        password=$(bashio::services "mqtt" "password")
        port=$(bashio::services "mqtt" "port")
        username=$(bashio::services "mqtt" "username")
        retain=$(bashio::config "retain")
        echo "Starting rtl_433 with MQTT Option $conf_file..."
        rtl_433 -c "/config/rtl_433/$conf_file" -F "mqtt://$host:$port,retain=1,devices=rtl_433[/id]"
    fi
fi

wait -n "${rtl_433_pids[*]}"
