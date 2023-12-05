#!/usr/bin/with-contenv bashio

conf_directory="/config/rtl_433"
script_directory="/config/rtl_433/scripts"
log_directory="/config/rtl_433/logs"
conf_file="rtl_433.conf"
http_script="rtl_433_http_ws.py"
mqtt_script="rtl_433_mqtt_hass.py"
discovery_topic="rtl_433/discovery"
discovery_device_name="rtl_433"


OUTPUTL_OPTIONS=$(bashio::config 'OUTPUT_OPTIONS')
ADDITIONAL_COMMANDS=$(bashio::config 'ADDITIONAL_COMMANDS')
LOG_LEVEL=$(bashio::config 'LOG_LEVEL')
MQTT_USERNAME=$(bashio::config 'MQTT_USERNAME')
MQTT_PASSWORD=$(bashio::config 'MQTT_PASSWORD')
MQTT_PUB_TOPIC=$(bashio::config 'MQTT_PUB_TOPIC')
MQTT_SUB_TOPIC=$(bashio::config 'MQTT_SUB_TOPIC')
PUBLISH_ALL=$(bashio::config 'PUBLISH_ALL')
PUBLISH_ADVDATA=$(bashio::config 'PUBLISH_ADVDATA')
DISCOVERY=$(bashio::config 'DISCOVERY')
DISCOVERY_FILTER=$(bashio::config 'DISCOVERY_FILTER')
ADAPTER=$(bashio::config 'ADAPTER')



# Convert the booleans to integers (1 for true, 0 for false) in single lines
RETIAN=$( [ "$RETAIN" = "true" ] && echo 1 || echo 0 )
PUBLISH_ALL=$( [ "$PUBLISH_ALL" = "true" ] && echo 1 || echo 0 )
PUBLISH_ADVDATA=$( [ "$PUBLISH_ADVDATA" = "true" ] && echo 1 || echo 0 )
DISCOVERY=$( [ "$DISCOVERY" = "true" ] && echo 1 || echo 0 )


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
        log_level="-vvvv"
        ;;
    *)
        log_level="-vvv" # Default to "debug" level
        ;;
esac

# Check the output options specified in the configuration
output_options=$(bashio::config "output_options")

case "$output_options" in
    "websocket")
        host="0.0.0.0"
        port=9443
        output=-F "http://$host:$port" && echo "Starting rtl_433 with $output_options using $conf_file"
        ;;

    "mqtt")
        host=$(bashio::config "host")
        port=$(bashio::config "port")
        output=-F "mqtt://$host:$port,retain=$retain,devices=rtl_433[/id],devices=rtl_433/9b13b3f4-rtl433/devices[/type][/model][/subtype][/channel][/id],events=rtl_433/9b13b3f4-rtl433/events,states=rtl_433/9b13b3f4-rtl433/st>" && echo "Starting rtl_433 with $output_options using $conf_file"
        ;;

    "custom")
        output=echo "Starting rtl_433 with custom option using $conf_file....Any errors are almost certainly yours"
        ;;

    *)
        handle_error 3 "Invalid or missing output options in the configuration"
        ;;
esac

rtl_433 -c "$conf_directory/$conf_file" $output $log_level $ADDITIONAL_COMMANDS


# Instead of waiting for any process to finish, loop indefinitely
while true; do
    sleep infinity
done
