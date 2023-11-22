#!/usr/bin/with-contenv bashio

conf_directory="/config/rtl_433"
script_directory="/config/rtl_433/scripts"
log_directory="/config/rtl_433/logs"
conf_file="rtl_433.conf"
http_script="rtl_433_http_ws.py"
mqtt_script="rtl_433_mqtt_hass.py"

rtl_433_pids=()

# Function to handle errors and exit the script
handle_error() {
    local exit_code=$1
    local error_message=$2
    echo "Error: $error_message" >&2
    exit "$exit_code"
}

# Function to download a file from a URL and handle errors
download_file() {
    local url=$1
    local destination=$2
    wget -q "$url" -O "$destination" || handle_error 2 "Failed to download $destination from $url"
}

# Function to create a directory if it doesn't exist
create_directory_if_not_exists() {
    local directory=$1
    if [ ! -d "$directory" ]; then
        mkdir -p "$directory" || handle_error 1 "Failed to create $directory"
    fi
}

# Function to download a file if it doesn't exist
download_file_if_not_exists() {
    local url=$1
    local destination=$2
    if [ ! -f "$destination" ]; then
        download_file "$url" "$destination"
    fi
}

# Function to start rtl_433 with appropriate options and capture the process ID
start_rtl_433() {
    local output_options=$1
    local log_level=$2

    local config_cli
    local rtl_433_args

    case "$output_options" in
        "websocket")
            local host="0.0.0.0"
            local port=9443
            config_cli=$(bashio::config "additional_commands")
            rtl_433_args="-F http://$host:$port"
            ;;

        "mqtt")
            local host="core-mosquitto"
            local port=1883
            local username="addons"
            config_cli=$(bashio::config "additional_commands")
            rtl_433_args="-F mqtt://$host:$port,retain=1,devices=rtl_433[/id]"
            echo "Starting rtl_433 with MQTT Option using $conf_file"
            ;;

        "custom")
            config_cli=$(bashio::config "additional_commands")
            rtl_433_args=""
            echo "Starting rtl_433 with custom option using $conf_file...so any errors are likely your fault"
            ;;

        *)
            handle_error 3 "Invalid or missing output options in the configuration"
            ;;
    }

# Check if the configuration directory exists and create it if not
create_directory_if_not_exists "$conf_directory"

# Check if the log directory exists and create it if not
create_directory_if_not_exists "$log_directory"

# Download the configuration file if it doesn't exist
download_file_if_not_exists "https://raw.githubusercontent.com/catduckgnaf/rtl_433_ha/main/config/rtl_433_catduck_template.conf" "$conf_directory/$conf_file"

# Check if the script directory exists and create it if not
create_directory_if_not_exists "$script_directory"

# Download the HTTP script if it doesn't exist
download_file_if_not_exists "https://raw.githubusercontent.com/catduckgnaf/rtl_433_ha/main/scripts/rtl_433_http_ws.py" "$script_directory/$http_script"

# Download the MQTT script if it doesn't exist
download_file_if_not_exists "https://raw.githubusercontent.com/catduckgnaf/rtl_433_ha/main/scripts/rtl_433_mqtt_hass.py" "$script_directory/$mqtt_script"

# Set log level
log_level=$(bashio::config "log_level")

# Check the output options specified in the configuration
output_options=$(bashio::config "output_options")

# Start rtl_433 processes based on the output options
start_rtl_433 "$output_options" "$log_level"

# Wait for rtl_433 processes to finish
if [ ${#rtl_433_pids[@]} -eq 0 ]; then
    handle_error 3 "No valid output options specified in the configuration"
fi

wait "${rtl_433_pids[@]}"
