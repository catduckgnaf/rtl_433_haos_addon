#!/usr/bin/with-contenv bashio

conf_directory="/config/rtl_433"
script_directory="/config/rtl_433/scripts"
log_directory="/config/rtl_433/logs"
conf_file="rtl_433.conf"
http_script="rtl_433_http_ws.py"
mqtt_script="rtl_433_mqtt_hass.py"
discovery_host="core-mosquitto"
discovery_port=1883
discovery_topic="devices=rtl_433/9b13b3f4-rtl433/devices[/type][/model][/subtype][/channel][/id],events=rtl_433/9b13b3f4-rtl433/events,states=rtl_433/9b13b3f4-rtl43"
discovery_prefix="rtl_433_discovery"
discovery_interval=600
device_id_1=$(bashio::config 'rtl_device_id_1')
device_id_2=$(bashio::config 'rtl_device_id_2')
device_id_3=$(bashio::config 'rtl_device_id_3')
device_id_4=$(bashio::config 'rtl_device_id_4')
device_id_5=$(bashio::config 'rtl_device_id_5')
device_id_6=$(bashio::config 'rtl_device_id_6')
device_id_7=$(bashio::config 'rtl_device_id_7')
device_id_8=$(bashio::config 'rtl_device_id_8')

# set device ID to correct format
if [ "$device_id_1" = "20_dsc_security_contact" ]; then
    device_id_1=20
fi

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
    download_file "https://raw.githubusercontent.com/catduckgnaf/rtl_433_ha/main/scripts/rtl_433_http_ws.py" "$script_directory/$http_script" && chmod +x "$script_directory/$http_script"
fi

# Download the MQTT script if it doesn't exist
if [ ! -f "$script_directory/$mqtt_script" ]; then
    download_file "https://raw.githubusercontent.com/catduckgnaf/rtl_433_ha/main/scripts/rtl_433_mqtt_hass.py" "$script_directory/$mqtt_script" && chmod +x "$script_directory/$mqtt_script"
fi

rtl_433 -F log -c "$conf_directory/$conf_file"
echo "Starting rtl_433 with $conf_file located in $conf_directory

if bashio::config.true 'discovery'; then
    echo "Starting discovery script"
    python3 -u "$script_directory/$mqtt_script" -H "$discovery_host" -p "$discovery_port" -R "$discovery_topic" -D "$discovery_prefix" -i "$discovery_interval" --ids "$discovery_ids"
    rtl_433_pids+=($!)
fi

# Instead of waiting for any process to finish, loop indefinitely
while true; do
    sleep infinity
done
