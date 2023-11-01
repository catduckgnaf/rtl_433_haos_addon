#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

conf_directory="/config/rtl_433"
conf_file="rtl_433.conf"



# Check if the configuration directory exists
if [ ! -d "$conf_directory" ]; then
    mkdir -p "$conf_directory" || handle_error 1 "Failed to create config directory"
fi

# Check if the configuration file exists
if [ ! -f "$conf_directory/$conf_file" ]; then
    wget https://raw.githubusercontent.com/catduckgnaf/rtl_433_ha/main/config/rtl_433_catduck_template.conf -O "$conf_directory/$conf_file" || handle_error 2 "Failed to download configuration file"
fi

# Check the output options specified in the configuration
if output_options=$(bashio::config "websocket"); then
    host="0.0.0.0"
    port="8433"
    echo "Starting rtl_433 with websocket option on $host:$port with $conf_file..."
    rtl_433 -c "$conf_directory/$conf_file" -F "http://$host:$port"

elif output_options=$(bashio::config "mqtt"); then
    if $(bashio::config "mqtt_host") || $(bashio::config "mqtt_port") || $(bashio::config "mqtt_username") || $(bashio::config "mqtt_password") ||; then
        host=$(bashio::config "mqtt_host")
        port=$(bashio::config "mqtt_port")
        username=$(bashio::config "mqtt_username")
        password=$(bashio::config "mqtt_password")
    else
        host=$(bashio::services mqtt "host")
        port=$(bashio::services mqtt "port")
        username=$(bashio::services mqtt "username")
        password=$(bashio::services mqtt "password")
    fi
    
    retain=$(bashio::config "retain")
    echo "Starting rtl_433 with MQTT Option $conf_file..."
    rtl_433 -c "$conf_directory/$conf_file" -F "mqtt://$host:$port,retain=1,devices=rtl_433[/id]" &
else
    handle_error 3 "No valid output options specified in the configuration"
fi
