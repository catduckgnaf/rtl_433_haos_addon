#!/usr/bin/with-contenv bashio

conf_directory="/config/rtl_433"

if bashio::services.available "mqtt"; then
    host=$(bashio::services "mqtt" "host")
    password=$(bashio::services "mqtt" "password")
    port=$(bashio::services "mqtt" "port")
    username=$(bashio::services "mqtt" "username")
    retain=$(bashio::config "retain")
else
    bashio::log.info "The mqtt addon is not available."
    bashio::log.info "Manually update the output line in the configuration file with mqtt connection settings, and restart the addon."
fi

if [ ! -d $conf_directory ]
then
    mkdir -p $conf_directory
fi

# Check if the legacy configuration file is set and alert that it's deprecated.
conf_file=$(bashio::config "rtl_433_conf_file")

if [[ $conf_file != "" ]]
then
    bashio::log.warning "rtl_433 now supports automatic configuration and multiple radios. The rtl_433_conf_file option is deprecated. See the documentation for migration instructions."
    conf_file="/config/$conf_file"

    echo "Starting rtl_433 -c $conf_file"
    rtl_433 -c "$conf_file"
    exit $?
fi

# Create a reasonable default configuration in /config/rtl_433.
if [ ! "$(ls -A $conf_directory)" ]
then
    cat > $conf_directory/rtl_433.conf.template <<EOD
# This is an empty template for configuring rtl_433. mqtt information will be
# automatically added. Create multiple files ending in '.conf.template' to
# manage multiple rtl_433 radios, being sure to set the 'device' setting. The
# device must be set before mqtt output lines.
# https://github.com/merbanan/rtl_433/blob/master/conf/rtl_433.example.conf

output mqtt://\${host}:\${port},user=\${username},pass=\${password},retain=\${retain}
report_meta time:iso:usec:tz

# To keep the same topics when switching between the normal and edge versions,
# use this output line instead.
# output mqtt://\${host}:\${port},user=\${username},pass=\${password},retain=\${retain},devices=rtl_433/9b13b3f4-rtl433/devices[/type][/model][/subtype][/channel][/id],events=rtl_433/9b13b3f4-rtl433/events,states=rtl_433/9b13b3f4-rtl433/states

# Uncomment the following line to also enable the default "table" output to the
# addon logs.
# output kv

# Disable TPMS sensors by default. These can cause an overwhelming number of
# devices and entities to show up in Home Assistant.
# This list is generated by running:
# rtl_433 -R help 2>&1 | grep -i tpms | sd '.*\[(\d+)\].*' 'protocol -$1'
#    [59]  Steelmate TPMS
#    [60]  Schrader TPMS
#    [82]  Citroen TPMS
#    [88]  Toyota TPMS
#    [89]  Ford TPMS
#    [90]  Renault TPMS
#    [95]  Schrader TPMS EG53MA4, PA66GF35
#    [110]  PMV-107J (Toyota) TPMS
#    [123]* Jansite TPMS Model TY02S
#    [140]  Elantra2012 TPMS
#    [156]  Abarth 124 Spider TPMS
#    [168]  Schrader TPMS SMD3MA4 (Subaru)
#    [180]  Jansite TPMS Model Solar
#    [186]  Hyundai TPMS (VDO)
#    [201]  Unbranded SolarTPMS for trucks
#    [203]  Porsche Boxster/Cayman TPMS
protocol -59
protocol -60
protocol -82
protocol -88
protocol -89
protocol -90
protocol -95
protocol -110
protocol -123
protocol -140
protocol -156
protocol -168
protocol -180
protocol -186
protocol -201
protocol -203
EOD
fi

# Remove all rendered configuration files.
rm -f $conf_directory/*.conf

rtl_433_pids=()
for template in $conf_directory/*.conf.template
do
    # Remove '.template' from the file name.
    live=$(basename $template .template)

    # By sourcing the template, we can substitute any environment variable in
    # the template. In fact, enterprising users could write _any_ valid bash
    # to create the final configuration file. To simplify template creation,
    # we wrap the needed redirections into a temparary file.
    echo "cat <<EOD > $live" > /tmp/rtl_433_heredoc
    cat $template >> /tmp/rtl_433_heredoc

    # Ensure a newline exists in case the template doesn't have one at the end
    # of its file.
    echo >> /tmp/rtl_433_heredoc

    echo EOD >> /tmp/rtl_433_heredoc

    source /tmp/rtl_433_heredoc

    echo "Starting rtl_433 with $live..."
    tag=$(basename $live .conf)
    rtl_433 -c "$live" > >(sed -u "s/^/[$tag] /") 2> >(>&2 sed -u "s/^/[$tag] /")&
    rtl_433_pids+=($!)
done

wait -n ${rtl_433_pids[*]}