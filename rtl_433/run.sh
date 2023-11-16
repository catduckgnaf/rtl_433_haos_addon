#!/usr/bin/with-contenv bashio

conf_directory="/config/rtl_433"
script_directory="/config/rtl_433/scripts"
log_directory="/config/rtl_433/logs"
conf_file="rtl_433.conf"
http_script="rtl_433_http_ws.py"
mqtt_script="rtl_433_mqtt_hass.py"

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

# Download the HTTP script if it doesn't exist
if [ ! -f "$script_directory/$http_script" ]; then
    download_file "https://raw.githubusercontent.com/catduckgnaf/rtl_433_ha/main/scripts/rtl_433_http_ws.py" "$script_directory/$http_script"
fi

# Download the MQTT script if it doesn't exist
if [ ! -f "$script_directory/$mqtt_script" ]; then
    download_file "https://raw.githubusercontent.com/catduckgnaf/rtl_433_ha/main/scripts/rtl_433_mqtt_hass.py" "$script_directory/$mqtt_script"
fi

# Set log level
log_level=$(bashio::config "log_level")

case "$log_level" in
    "error")
        log_level="-v"
        ;;
    "warn")
        log_level="-vv"
        ;;
    "debug")
        log_level="-vvv"
        ;;
    "trace")
        $log_level="-vvvv"
        ;;
    *)
        log_level="-vv" # Default to "warn" level
        ;;
esac

# Check the output options specified in the configuration
output_options=$(bashio::config "output_options")

case "$output_options" in
    "websocket")
        host="0.0.0.0"
        port=9443
        config_cli=$(bashio::config "additional_commands")
        rtl_433 -c "$conf_directory/$conf_file" "$log_level"= "$config_cli" -F "http://$host:$port" &
        ;;

    "mqtt")
        host="core-mosquitto"
        password=""
        port=1883
        username="addons"
        config_cli=$(bashio::config "additional_commands")
        rtl_433 -c "$conf_directory/$conf_file" "$logging" "$config_cli" -F "mqtt://$host:$port,retain=1,devices=rtl_433[/id]" &
        echo "Starting rtl_433 with MQTT Option using $conf_file"
        ;;

    "custom")
        config_cli=$(bashio::config "additional_commands")
        rtl_433 -c "$conf_directory/$conf_file" "$config_cli" &
        echo "Starting rtl_433 with custom option using $conf_file....Any errors are almost certainly yours"
        ;;

    *)
        handle_error 3 "Invalid or missing output options in the configuration"
        ;;
esac

# Instead of waiting for any process to finish, loop indefinitely
while true; do
    sleep infinity
done
