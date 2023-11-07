#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

conf_directory="/config/rtl_433"
script_directory="/config/rtl_433/scripts"
log_directory="/config/rtl_433/logs"
conf_file="rtl_433.conf"
http_script="rtl_433_http_ws.py"
mqtt_script="rtl_433_mqtt_hass.py"

## additional commands will allow the user to specify any command line options directly from the add-on yaml config
additional_commands=""

rtl_433_pids=() # Initialize an array to store process IDs

# Function to handle errors and exit the script
handle_error() {
    local exit_code=$1
    local error_message=$2
    echo "Error: $error_message" >&2
    exit "$exit_code"
}

# Check if the configuration directory exists
if [ ! -d "$conf_directory" ]; then
    mkdir -p "$conf_directory" || handle_error 1 "Failed to create config directory"
fi

# Check if the log directory exists
if [ ! -d "$log_directory" ]; then
    mkdir -p "$log_directory" || handle_error 1 "Failed to create log directory"
fi

# Check if the configuration file exists
if [ ! -f "$conf_directory/$conf_file" ]; then
    wget "https://raw.githubusercontent.com/catduckgnaf/rtl_433_ha/main/config/rtl_433_catduck_template.conf" -O "$conf_directory/$conf_file" || handle_error 2 "Failed to download configuration file"
fi

# Check if the script directory exists
if [ ! -d "$script_directory" ]; then
    mkdir -p "$script_directory" || handle_error 1 "Failed to create script directory"
fi

# Check if the http ws file exists
if [ ! -f "$script_directory/$http_script" ]; then
    wget "https://raw.githubusercontent.com/catduckgnaf/rtl_433_ha/main/scripts/rtl_433_http_ws.py" -O "$script_directory/$http_script" || handle_error 2 "Failed to download http script"
fi

# Check if the mqtt discovery script exists
if [ ! -f "$script_directory/$mqtt_script" ]; then
    wget "https://raw.githubusercontent.com/catduckgnaf/rtl_433_ha/main/scripts/rtl_433_mqtt_hass.py" -O "$script_directory/$mqtt_script" || handle_error 2 "Failed to download mqtt script"
fi

# set log level
log_level=$(bashio::config "log_level")

if [ "$log_level" = "error" ]; then
   default_logging="-v"
elif [ "$log_level" = "warn" ]; then
   default_logging="-vv"
elif [ "$log_level" = "debug" ]; then
   default_logging="-vvv"
elif [ "$log_level" = "trace" ]; then
   default_logging="-vvvv"
fi

# Check the output options specified in the configuration
output_options=$(bashio::config "output_options")

if [ "$output_options" = "websocket" ]; then
    host=$(bashio::config "http_host")
    port=$(bashio::config "http_port")
    rtl_433 -c "$conf_directory/$conf_file" "$default_logging" "$additional_commands" -F "http://$host:$port" &
    rtl_433_pids+=($!)
    echo "Starting rtl_433 with websocket option on "$host:$port with $conf_file... "$additional_commands" for rtl_433_pids+=($!)" 

elif [ "$output_options" = "mqtt" ]; then
    host=$(bashio::config "mqtt_host")
    port=$(bashio::config "mqtt_port")
    username=$(bashio::config "mqtt_username")
    password=$(bashio::config "mqtt_password")
    retain=$(bashio::config "mqtt_retain")
    rtl_433 -c "$conf_directory/$conf_file" "$default_logging" "$additional_commands" -F "mqtt://$host:$port,retain=1,devices=rtl_433[/id]" &
    rtl_433_pids+=($!)
    echo "Starting rtl_433 with MQTT Option $conf_file... "$additional_commands"
fi

if [ ${#rtl_433_pids[@]} -eq 0 ]; then
    handle_error 3 "No valid output options specified in the configuration"
fi

wait "${rtl_433_pids[@]}"
