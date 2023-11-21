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

case "$log_level" in
    "error") default_logging="-v" ;;
    "warn") default_logging="-vv" ;;
    "debug") default_logging="-vvv" ;;
    "trace") default_logging="-vvvv" ;;
    *) default_logging="-vv" ;; # Default to "warn" level
esac

# Check the output options specified in the configuration
output_options=$(bashio::config "output_options")

case "$output_options" in
    "websocket")
        host="0.0.0.0"
        port=9443
        config_cli=$(bashio::config "additional_commands")
        rtl_433_conf_local=$(bashio::config "rtl_433_conf_file")
        echo "Starting rtl_433 with http option using $rtl_433_conf_local"
        rtl_433 -c $rtl_433_conf_local $default_logging $config_cli -F "http://$host:$port" &
        ;;

    "mqtt")
        host="core-mosquitto"
        password=""
        port=1883
        username="addons"
        config_cli=$(bashio::config "additional_commands")
        rtl_433_conf_local=$(bashio::config "rtl_433_conf_file")
        echo "Starting rtl_433 with MQTT option using $rtl_433_conf_local"
        rtl_433 -c $rtl_433_conf_local $default_logging $config_cli -F "mqtt://$host:$port,retain=1,devices=rtl_433[/id]" &
        ;;

    "custom")
        config_cli=$(bashio::config "additional_commands")
        rtl_433_conf_local=$(bashio::config "rtl_433_conf_file")
        echo "Starting rtl_433 with custom option using $rtl_433_conf_local....Any errors are almost certainly yours"
        rtl_433 $config_cli &
        ;;

    *)
        handle_error 3 "Invalid or missing output options in the configuration"
        ;;
esac


wait "${rtl_433_pids[@]}"
