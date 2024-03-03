#!/usr/bin/with-contenv bashio

conf_directory="/config/rtl_433"
script_directory="/config/rtl_433/scripts"
log_directory="/config/rtl_433/logs"
conf_file="rtl_433.conf"
http_script="rtl_433_http_ws.py"
mqtt_script="rtl_433_mqtt_hass.py"
output_logfile="output.json"
discovery=$(bashio::config 'discovery')
discovery_host=$(bashio::config 'discovery_host')
discovery_port=$(bashio::config 'discovery_port')
discovery_user=$(bashio::config 'discovery_user')
discovery_password=$(bashio::config 'discovery_password')
discovery_topic=$(bashio::config 'discovery_topic')
discovery_prefix=$(bashio::config 'discovery_prefix')
discovery_interval=$(bashio::config 'discovery_interval')
discovery_ids=$(bashio::config 'discovery_ids')
discovery_log_level=$(bashio::config 'discovery_log_level')
other_args=$(bashio::config 'other_args')

# other args
if bashio::config.true "discovery_retain"; then
    other_args+=" --retain"
fi
if bashio::config.true "discovery_force_update"; then
    other_args+=" --force_update"
fi
# This is an optional parameter and we don't want to overwrite the defaults
device_topic_suffix=$(bashio::config "device_topic_suffix")
if [[ -n $device_topic_suffix ]]; then
    other_args+=" -T '${device_topic_suffix}'"
fi


if [[ $discovery_log_level == "quiet" ]]; then
    other_args+=" --quiet"
fi
if [[ $discovery_log_level == "debug" ]]; then
    other_args+=" --debug"
fi

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

# Check if the output log file exists and rename it if it's greater than 1MB
if [ -f "$log_directory/$output_logfile" ]; then
    file_size=$(du -b "$log_directory/$output_logfile" | cut -f1)

    if [ "$file_size" -gt 5242880 ]; then  # 5242880 bytes = 5MB
        mv -f "$log_directory/$output_logfile" "$log_directory/$output_logfile.bak" || handle_error 1 "Failed to rename $output_logfile to $output_logfile.bak"

#Now we remove the original file after renaming
        rm -f "$log_directory/$output_logfile" || handle_error 2 "Failed to remove the original file $output_logfile"
        
    else
        echo "$log_directory/$output_logfile is not greater than 1MB. Skipping the renaming."
    fi
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
    python3 -u "$script_directory/$mqtt_script" -H $discovery_host -p $discovery_port -u "$discovery_user" -P "$discovery_password" -R "$discovery_topic" -D "$discovery_prefix" -i $discovery_interval --ids $discovery_ids
    rtl_433_pids+=($!)
fi

# Instead of waiting for any process to finish, loop indefinitely
while true; do
    sleep infinity
done
