#!/usr/bin/with-contenv bashio

conf_directory="/config/rtl_433"
conf_file="rtl_433.conf"

if bashio::services.available "mqtt"; then
    host=$(bashio::services "mqtt" "host")
    password=$(bashio::services "mqtt" "password")
    port=$(bashio::services "mqtt" "port")
    username=$(bashio::services "mqtt" "username")
    retain=$(bashio::config "retain")
else
    bashio::log.info "The mqtt addon is not available."
    bashio::log.info "Manually update the output line in the configuration file with mqtt connection settings, and restart the addon."
fi

if [ ! -d $conf_directory ]
then
    mkdir -p $conf_directory
fi

    echo "Starting rtl_433 with $conf_file..."
    rtl_433 -c "/config/rtl_433/$conf_file" -F "mqtt://$host:$port,retain=0,devices=rtl_433[/id]"

wait -n ${rtl_433_pids[*]}
