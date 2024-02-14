#!/usr/bin/with-contenv bashio

conf_directory="/config/rtl_433"
script_directory="/config/rtl_433/scripts"
log_directory="/config/rtl_433/logs"
conf_file="rtl_433.conf"
http_script="rtl_433_http_ws.py"
mqtt_script="rtl_433_mqtt_hass.py"
discovery=$(bashio::config 'discovery')
discovery_host=$(bashio::config 'discovery_host')
discovery_port=$(bashio::config 'discovery_port')
discovery_user=$(bashio::config 'discovery_user')
discovery_password=$(bashio::config 'discovery_password')
discovery_topic=$(bashio::config 'discovery_topic')
discovery_prefix=$(bashio::config 'discovery_prefix')
discovery_interval=$(bashio::config 'discovery_interval')
discovery_ids=$(bashio::config 'discovery_ids')
other_args=$(bashio::config 'other_args')

# Initialize an array to store process IDs
rtl_433_pids=()

# Function to handle errors and log them
handle_error() {
    local exit_code=$1
    local error_message=$2
    echo "Error: $error_message" >&2
}

# Function to download a file from a URL and log errors
download_file() {
    local url=$1
    local destination=$2
    wget -q "$url" -O "$destination"
    if [ $? -ne 0 ]; then
        handle_error 2 "Failed to download $destination"
    fi
}

# Check if the configuration directory exists and create it if not
if [ ! -d "$conf_directory" ]; then
    mkdir -p "$conf_directory" || handle_error 1 "Failed to create config directory"
fi

# Check if the log directory exists and create it if not
if [ ! -d "$log_directory" ]; then
    mkdir -p "$log_directory" || handle_error 1 "Failed to create log directory"
fi

# Download the configuration file if it doesn't exist
if [ ! -f "$conf_directory/$conf_file" ]; then
    download_file "https://raw.githubusercontent.com/catduckgnaf/rtl_433_ha/main/config/rtl_433_catduck_template.conf" "$conf_directory/$conf_file"
fi

# Check if the script directory exists and create it if not
if [ ! -d "$script_directory" ]; then
    mkdir -p "$script_directory" || handle_error 1 "Failed to create script directory"
fi


# Download the MQTT script if it doesn't exist and replace if it does
if [ -f "$script_directory/$mqtt_script" ]; then
    rm "$script_directory/$mqtt_script"
fi

download_file "https://raw.githubusercontent.com/catduckgnaf/rtl_433_ha/main/scripts/rtl_433_mqtt_hass.py" "$script_directory/$mqtt_script" && chmod +x "$script_directory/$mqtt_script"


rtl_433 -c "$conf_directory/$conf_file" -F log
echo "Starting rtl_433 with $conf_file located in $conf_directory"

# discovery
if [ "$discovery" = true ]; then
    echo "Starting discovery script"
    python3 -u "$script_directory/$mqtt_script" -H $discovery_host -p $discovery_port -u "$discovery_user" -P "$discovery_password" -D "$discovery_prefix" -R $discovery_topic -i $discovery_interval --ids "$discovery_ids"
    rtl_433_pids+=($!)
fi

# Instead of waiting for any process to finish, loop indefinitely
while true; do
    sleep infinity
done
