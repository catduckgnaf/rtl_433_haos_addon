#!/usr/bin/with-contenv bashio

conf_directory="/config/rtl_433"
script_directory="/config/rtl_433/scripts"
log_directory="/config/rtl_433/logs"
conf_file="rtl_433.conf"
http_script="rtl_433_http_ws.py"
mqtt_script="rtl_433_mqtt_hass.py"
output_logfile="output.json"

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
    if ! wget -q "$url" -O "$destination"; then
        handle_error 2 "Failed to download from $url to $destination"
    fi
}

# Ensure the configuration, log, and script directories exist
mkdir -p "$conf_directory" || handle_error 1 "Failed to create config directory"
mkdir -p "$log_directory" || handle_error 1 "Failed to create log directory"
mkdir -p "$script_directory" || handle_error 1 "Failed to create script directory"

# Manage the output log file size
if [ -f "${log_directory}/${output_logfile}" ]; then
    file_size=$(du -b "${log_directory}/${output_logfile}" | cut -f1)
    if [ "$file_size" -gt 5242880 ]; then  # 5MB
        mv -f "${log_directory}/${output_logfile}" "${log_directory}/${output_logfile}.bak" || handle_error 1 "Failed to rename $output_logfile"
        rm -f "${log_directory}/${output_logfile}" || handle_error 2 "Failed to remove the original $output_logfile"
    fi
fi


# Download the configuration file if it doesn't exist
if [ ! -f "$conf_directory/$conf_file" ]; then
    download_file "https://raw.githubusercontent.com/catduckgnaf/rtl_433_ha/main/config/rtl_433_catduck_template.conf" "$conf_directory/$conf_file"
fi

# Download scripts if they don't exist or replace if they do
download_file "https://raw.githubusercontent.com/catduckgnaf/rtl_433_ha/main/scripts/rtl_433_mqtt_hass.py" "${script_directory}/${mqtt_script}" && chmod +x "${script_directory}/${mqtt_script}"
download_file "https://raw.githubusercontent.com/catduckgnaf/rtl_433_ha/main/scripts/rtl_433_http_ws.py" "${script_directory}/${http_script}" && chmod +x "${script_directory}/${http_script}"

# Determine the output options and start rtl_433 with the appropriate settings
output_options=$(bashio::config "output_options")
config_cli=$(bashio::config "additional_commands")

case "$output_options" in
    "websocket")
        rtl_433 -c "${conf_directory}/${conf_file}" $config_cli -F "http://0.0.0.0:9443" &
        echo "Starting rtl_433 with WebSocket option using ${conf_file}"
        ;;
    "mqtt")
        rtl_433 -c "${conf_directory}/${conf_file}" $config_cli -F &
        echo "Starting rtl_433 with MQTT option using ${conf_file}"
        ;;
    "custom")
        rtl_433 -c "${conf_directory}/${conf_file}" $config_cli &
        echo "Starting rtl_433 with custom option using ${conf_file}"
        ;;
    *)
        handle_error 3 "Invalid or missing output options in the configuration"
        ;;
esac

# Keep the script running indefinitely
sleep infinity
