#!/usr/bin/with-contenv bashio

conf_directory="/config/rtl_433"
conf_file="rtl_433.conf"
rtl_433_pids=() # Initialize an array to store process IDs

# Function to handle errors and exit the script
handle_error() {
    local exit_code=$1
    local error_message=$2
    echo "Error: $error_message" >&2
    exit $exit_code
}

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
    config_cli=$(bashio::config "additional_commands")
    echo "Starting rtl_433 with websocket option on homeassistant.local:9433 with $conf_directory/$conf_file"
    rtl_433 -c "$conf_directory/$conf_file" -F http &
    rtl_433_pids+=($!)

elif output_options=$(bashio::config "mqtt"); then
    config_cli=$(bashio::config "additional_commands")
    echo "Starting rtl_433 with MQTT option $conf_directory/$conf_file"
    rtl_433 -c "$conf_directory/$conf_file" -F "mqtt://core-mosquitto:1883,retain=1,devices=rtl_433[/id]" &
    rtl_433_pids+=($!)

elif output_options=$(bashio::config "custom"); then
    config_cli=$(bashio::config "additional_commands")
    echo "Starting rtl_433 with custom option using $conf_directory/$conf_file...so any errors are likely your fault"
    rtl_433 -c "$conf_directory/$conf_file" $conflig_cli &
    rtl_433_pids+=($!)
else
    handle_error 3 "No valid output options specified in the configuration"
fi

# Wait for all background rtl_433 processes to complete
for pid in "${rtl_433_pids[@]}"; do
    wait "$pid" || handle_error 4 "One of the rtl_433 processes failed to complete"
done
