#!/usr/bin/with-contenv bashio

conf_directory="/config/rtl_433"
script_directory="/config/rtl_433/scripts"

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

if [ ! -d $script_directory ]
then
    mkdir -p $script_directory
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


# READ THIS!!!!!!!
## Everything is disabled by default. Simply remove the  "-" before the protocol number to enable.
## Yes Leave the naming rtl_433.conf.template. Replace the existing one after install. Do not place before install. 
## Yes I plan to make this more automated and for this version to be installed automatically.
## This will prevent the discovery script for finding all the things we don't want.
## Please consider contrubiting to the discovery script with other types of sensors that HA users want.

# This is an empty template for configuring rtl_433. mqtt information will be
# automatically added. Create multiple files ending in '.conf.template' to
# manage multiple rtl_433 radios, being sure to set the 'device' setting. The
# device must be set before mqtt output lines.
# https://github.com/merbanan/rtl_433/blob/master/conf/rtl_433.example.conf

# output mqtt://${host}:${port},user=${username},pass=${password},retain=${retain}
# report_meta time:iso:usec:tz

# To keep the same topics when switching between the normal and edge versions,
# use this output line instead.
output mqtt://${host}:${port},user=${username},pass=${password},retain=${retain},devices=rtl_433/9b13b3f4-rtl433/devices[/type][/model][/subtype][/channel][/id],events=rtl_433/9b13b3f4-rtl433/events,states=rtl_433/9b13b3f4-rtl433/states

# Uncomment the following line to also enable the default "table" output to the
# addon logs.
output kv


# Everything is disabled by default. Simply remove the  "-" before the protocol number to enable.

  protocol -1   # Silvercrest Remote Control
  protocol -2   # Rubicson, TFA 30.3197 or InFactory PT-310 Temperature Sensor
  protocol -3   # Prologue, FreeTec NC-7104, NC-7159-675 temperature sensor
  protocol -4   # Waveman Switch Transmitter
# protocol -6   # ELV EM 1000
# protocol -7   # ELV WS 2000
  protocol -8   # LaCrosse TX Temperature / Humidity Sensor
  protocol -10  # Acurite 896 Rain Gauge
  protocol -11  # Acurite 609TXC Temperature and Humidity Sensor
  protocol -12  # Oregon Scientific Weather Sensor
# protocol -13  # Mebus 433
# protocol -14  # Intertechno 433
  protocol -15  # KlikAanKlikUit Wireless Switch
  protocol -16  # AlectoV1 Weather Sensor (Alecto WS3500 WS4500 Ventus W155/W044 Oregon)
  protocol -17  # Cardin S466-TX2
  protocol -18  # Fine Offset Electronics, WH2, WH5, Telldus Temperature/Humidity/Rain Sensor
  protocol -19  # Nexus, FreeTec NC-7345, NX-3980, Solight TE82S, TFA 30.3209 temperature/humidity sensor
  protocol -20  # Ambient Weather F007TH, TFA 30.3208.02, SwitchDocLabs F016TH temperature sensor
  protocol -21  # Calibeur RF-104 Sensor
  protocol -22  # X10 RF
  protocol -23  # DSC Security Contact
# protocol -24  # Brennenstuhl RCS 2044
  protocol -25  # Globaltronics GT-WT-02 Sensor
  protocol -26  # Danfoss CFR Thermostat
  protocol -29  # Chuango Security Technology
  protocol -30  # Generic Remote SC226x EV1527
  protocol -31  # TFA-Twin-Plus-30.3049, Conrad KW9010, Ea2 BL999
  protocol -32  # Fine Offset Electronics WH1080/WH3080 Weather Station
  protocol -33  # WT450, WT260H, WT405H
  protocol -34  # LaCrosse WS-2310 / WS-3600 Weather Station
  protocol -35  # Esperanza EWS
  protocol -36  # Efergy e2 classic
# protocol -37  # Inovalley kw9015b, TFA Dostmann 30.3161 (Rain and temperature sensor)
  protocol -38  # Generic temperature sensor 1
  protocol -39  # WG-PB12V1 Temperature Sensor
  protocol -40  # Acurite 592TXR Temp/Humidity, 592TX Temp, 5n1 Weather Station, 6045 Lightning, 899 Rain, 3N1, Atlas
  protocol -41  # Acurite 986 Refrigerator / Freezer Thermometer
  protocol -42  # HIDEKI TS04 Temperature, Humidity, Wind and Rain Sensor
  protocol -43  # Watchman Sonic / Apollo Ultrasonic / Beckett Rocket oil tank monitor
  protocol -44  # CurrentCost Current Sensor
  protocol -45  # emonTx OpenEnergyMonitor
  protocol -46  # HT680 Remote control
  protocol -47  # Conrad S3318P, FreeTec NC-5849-913 temperature humidity sensor
  protocol -48  # Akhan 100F14 remote keyless entry
  protocol -49  # Quhwa
  protocol -50  # OSv1 Temperature Sensor
  protocol -51  # Proove / Nexa / KlikAanKlikUit Wireless Switch
  protocol -52  # Bresser Thermo-/Hygro-Sensor 3CH
  protocol -53  # Springfield Temperature and Soil Moisture
  protocol -54  # Oregon Scientific SL109H Remote Thermal Hygro Sensor
  protocol -55  # Acurite 606TX Temperature Sensor
  protocol -56  # TFA pool temperature sensor
  protocol -57  # Kedsum Temperature & Humidity Sensor, Pearl NC-7415
  protocol -58  # Blyss DC5-UK-WH
# protocol -61  # LightwaveRF
# protocol -62  # Elro DB286A Doorbell
  protocol -63  # Efergy Optical
# protocol -64  # Honda Car Key
  protocol -67  # Radiohead ASK
  protocol -68  # Kerui PIR / Contact Sensor
  protocol -69  # Fine Offset WH1050 Weather Station
  protocol -70  # Honeywell Door/Window Sensor, 2Gig DW10/DW11, RE208 repeater
  protocol -71  # Maverick ET-732/733 BBQ Sensor
# protocol -72  # RF-tech
  protocol -73  # LaCrosse TX141-Bv2, TX141TH-Bv2, TX141-Bv3, TX141W, TX145wsdth, (TFA, ORIA) sensor
  protocol -74  # Acurite 00275rm,00276rm Temp/Humidity with optional probe
  protocol -75  # LaCrosse TX35DTH-IT, TFA Dostmann 30.3155 Temperature/Humidity sensor
  protocol -76  # LaCrosse TX29IT, TFA Dostmann 30.3159.IT Temperature sensor
  protocol -77  # Vaillant calorMatic VRT340f Central Heating Control
  protocol -78  # Fine Offset Electronics, WH25, WH32B, WH24, WH65B, HP1000, Misol WS2320 Temperature/Humidity/Pressure Sensor
  protocol -79  # Fine Offset Electronics, WH0530 Temperature/Rain Sensor
  protocol -80  # IBIS beacon
  protocol -81  # Oil Ultrasonic STANDARD FSK
  protocol -83  # Oil Ultrasonic STANDARD ASK
  protocol -84  # Thermopro TP11 Thermometer
  protocol -85  # Solight TE44/TE66, EMOS E0107T, NX-6876-917
  protocol -86  # Wireless Smoke and Heat Detector GS 558
  protocol -87  # Generic wireless motion sensor
  protocol -91  # inFactory, nor-tec, FreeTec NC-3982-913 temperature humidity sensor
  protocol -92  # FT-004-B Temperature Sensor
  protocol -93  # Ford Car Key
  protocol -94  # Philips outdoor temperature sensor (type AJ3650)
  protocol -96  # Nexa
  protocol -97  # ThermoPro TP08/TP12/TP20 thermometer
  protocol -98  # GE Color Effects
  protocol -99  # X10 Security
  protocol -100 # Interlogix GE UTC Security Devices
# protocol -101 # Dish remote 6.3
  protocol -102 # SimpliSafe Home Security System (May require disabling automatic gain for KeyPad decodes)
  protocol -103 # Sensible Living Mini-Plant Moisture Sensor
  protocol -104 # Wireless M-Bus, Mode C&T, 100kbps (-f 868.95M -s 1200k)
  protocol -105 # Wireless M-Bus, Mode S, 32.768kbps (-f 868.3M -s 1000k)
# protocol -106 # Wireless M-Bus, Mode R, 4.8kbps (-f 868.33M)
# protocol -107 # Wireless M-Bus, Mode F, 2.4kbps
  protocol -108 # Hyundai WS SENZOR Remote Temperature Sensor
  protocol -109 # WT0124 Pool Thermometer
  protocol -111 # Emos TTX201 Temperature Sensor
  protocol -112 # Ambient Weather TX-8300 Temperature/Humidity Sensor
  protocol -113 # Ambient Weather WH31E Thermo-Hygrometer Sensor, EcoWitt WH40 rain gauge
  protocol -114 # Maverick et73
  protocol -115 # Honeywell ActivLink, Wireless Doorbell
  protocol -116 # Honeywell ActivLink, Wireless Doorbell (FSK)
# protocol -117 # ESA1000 / ESA2000 Energy Monitor
# protocol -118 # Biltema rain gauge
  protocol -119 # Bresser Weather Center 5-in-1
  protocol -120 # Digitech XC-0324 / AmbientWeather FT005TH temp/hum sensor
  protocol -121 # Opus/Imagintronix XT300 Soil Moisture
# protocol -122 # FS20
  protocol -124 # LaCrosse/ELV/Conrad WS7000/WS2500 weather sensors
  protocol -125 # TS-FT002 Wireless Ultrasonic Tank Liquid Level Meter With Temperature Sensor
  protocol -126 # Companion WTR001 Temperature Sensor
  protocol -127 # Ecowitt Wireless Outdoor Thermometer WH53/WH0280/WH0281A
  protocol -128 # DirecTV RC66RX Remote Control
# protocol -129 # Eurochron temperature and humidity sensor
  protocol -130 # IKEA Sparsnas Energy Meter Monitor
  protocol -131 # Microchip HCS200/HCS300 KeeLoq Hopping Encoder based remotes
  protocol -132 # TFA Dostmann 30.3196 T/H outdoor sensor
  protocol -133 # Rubicson 48659 Thermometer
  protocol -134 # AOK Weather Station rebrand Holman Industries iWeather WS5029, Conrad AOK-5056, Optex 990018
  protocol -135 # Philips outdoor temperature sensor (type AJ7010)
  protocol -136 # ESIC EMT7110 power meter
  protocol -137 # Globaltronics QUIGG GT-TMBBQ-05
  protocol -138 # Globaltronics GT-WT-03 Sensor
  protocol -139 # Norgo NGE101
  protocol -141 # Auriol HG02832, HG05124A-DCF, Rubicson 48957 temperature/humidity sensor
  protocol -142 # Fine Offset Electronics/ECOWITT WH51, SwitchDoc Labs SM23 Soil Moisture Sensor
  protocol -143 # Holman Industries iWeather WS5029 weather station (older PWM)
  protocol -144 # TBH weather sensor
  protocol -145 # WS2032 weather station
  protocol -146 # Auriol AFW2A1 temperature/humidity sensor
  protocol -147 # TFA Drop Rain Gauge 30.3233.01
  protocol -148 # DSC Security Contact (WS4945)
  protocol -149 # ERT Standard Consumption Message (SCM)
# protocol 150 # Klimalogg
  protocol -151 # Visonic powercode
  protocol -152 # Eurochron EFTH-800 temperature and humidity sensor
  protocol -153 # Cotech 36-7959, SwitchDocLabs FT020T wireless weather station with USB
  protocol -154 # Standard Consumption Message Plus (SCMplus)
  protocol -155 # Fine Offset Electronics WH1080/WH3080 Weather Station (FSK)
  protocol -157 # Missil ML0757 weather station
  protocol -158 # Sharp SPC775 weather station
  protocol -159 # Insteon
  protocol -160 # ERT Interval Data Message (IDM)
  protocol -161 # ERT Interval Data Message (IDM) for Net Meters
# protocol -162 # ThermoPro-TX2 temperature sensor
  protocol -163 # Acurite 590TX Temperature with optional Humidity
  protocol -164 # Security+ 2.0 (Keyfob)
  protocol -165 # TFA Dostmann 30.3221.02 T/H Outdoor Sensor
  protocol -166 # LaCrosse Technology View LTV-WSDTH01 Breeze Pro Wind Sensor
  protocol -167 # Somfy RTS
# protocol -169 # Nice Flor-s remote control for gates
  protocol -170 # LaCrosse Technology View LTV-WR1 Multi Sensor
  protocol -171 # LaCrosse Technology View LTV-TH Thermo/Hygro Sensor
  protocol -172 # Bresser Weather Center 6-in-1, 7-in-1 indoor, soil, new 5-in-1, 3-in-1 wind gauge, Froggit WH6000, Ventus C8488A
  protocol -173 # Bresser Weather Center 7-in-1
  protocol -174 # EcoDHOME Smart Socket and MCEE Solar monitor
  protocol -175 # LaCrosse Technology View LTV-R1, LTV-R3 Rainfall Gauge, LTV-W1/W2 Wind Sensor
  protocol -176 # BlueLine Innovations Power Cost Monitor
  protocol -177 # Burnhard BBQ thermometer
  protocol -178 # Security+ (Keyfob)
  protocol -179 # Cavius smoke, heat and water detector
  protocol -181 # Amazon Basics Meat Thermometer
  protocol -182 # TFA Marbella Pool Thermometer
  protocol -183 # Auriol AHFL temperature/humidity sensor
  protocol -184 # Auriol AFT 77 B2 temperature sensor
  protocol -185 # Honeywell CM921 Wireless Programmable Room Thermostat
  protocol -187 # RojaFlex shutter and remote devices
  protocol -188 # Marlec Solar iBoost+ sensors
  protocol -189 # Somfy io-homecontrol
  protocol -190 # Ambient Weather WH31L (FineOffset WH57) Lightning-Strike sensor
  protocol -191 # Markisol, E-Motion, BOFU, Rollerhouse, BF-30x, BF-415 curtain remote
  protocol -192 # Govee Water Leak Detector H5054, Door Contact Sensor B5023
  protocol -193 # Clipsal CMR113 Cent-a-meter power meter
  protocol -194 # Inkbird ITH-20R temperature humidity sensor
  protocol -195 # RainPoint soil temperature and moisture sensor
  protocol -196 # Atech-WS308 temperature sensor
  protocol -197 # Acurite Grill/Meat Thermometer 01185M
# protocol -198 # EnOcean ERP1
  protocol -199 # Linear Megacode Garage/Gate Remotes
# protocol -200 # Auriol 4-LD5661/4-LD5972/4-LD6313 temperature/rain sensors
  protocol -202 # Funkbus / Instafunk (Berker, Gira, Jung)
  protocol -204 # Jasco/GE Choice Alert Security Devices
  protocol -205 # Telldus weather station FT0385R sensors
  protocol -206 # LaCrosse TX34-IT rain gauge
  protocol -207 # SmartFire Proflame 2 remote control
  protocol -208 # unknown
  protocol -209 # SimpliSafe Gen 3 Home Security System
  protocol -210 # Yale HSA (Home Security Alarm), YES-Alarmkit
  protocol -211 # Regency Ceiling Fan Remote (-f 303.75M to 303.96M)
  protocol -213 # Fine Offset Electronics WS80 weather station
  protocol -212 # unknown
  protocol -214 # EMOS E6016 weatherstation with DCF77
  protocol -215 # Emax W6, rebrand Altronics x7063/4, Optex 990040/50/51, Orium 13093/13123, Infactory FWS-1200, Newentor Q9, Otio 810025, Protmex PT3390A, Jula Marquant 014331/32, Weather Station or temperature/humidity sensor
# protocol -216 # ANT and ANT+ devices
  protocol -217 # EMOS E6016 rain gauge
  protocol -218 # Microchip HCS200/HCS300 KeeLoq Hopping Encoder based remotes (FSK)
  protocol -219 # Fine Offset Electronics WH45 air quality sensor
  protocol -220 # Maverick XR-30 BBQ Sensor
  protocol -221 # Fine Offset Electronics WN34 temperature sensor
  protocol -222 # Rubicson Pool Thermometer 48942
  protocol -223 # Badger ORION water meter, 100kbps (-f 916.45M -s 1200k)
  protocol -224 # GEO minim+ energy monitor
  protocol -225 # unknown
  protocol -226 # unknown
  protocol -227 # SRSmith Pool Light Remote Control SRS-2C-TX (-f 915M)
  protocol -228 # Neptune R900 flow meters
# protocol -229 # WEC-2103 temperature/humidity sensor
  protocol -230 # Vauno EN8822C
  protocol -231 # Govee Water Leak Detector H5054
  protocol -232 # TFA Dostmann 14.1504.V2 Radio-controlled grill and meat thermometer
# protocol -233 # CED7000 Shot Timer
  protocol -234 # Watchman Sonic Advanced / Plus
  protocol -235 # Oil Ultrasonic SMART FSK
  protocol -236 # Gasmate BA1008 meat thermometer
  protocol -237 # Flowis flow meters
  protocol -238 # Wireless M-Bus, Mode T, 32.768kbps (-f 868.3M -s 1000k)
  protocol -239 # Revolt NC-5642 Energy Meter
  protocol -240 # LaCrosse TX31U-IT, The Weather Channel WS-1910TWC-IT
  protocol -226 # unknown
  protocol -241 # unknown
# protocol -242 # Baldr / RainPoint rain gauge.
  protocol -243 # Celsia CZC1 Thermostat
  protocol -244 # Fine Offset Electronics WS90 weather station
# protocol -245 # ThermoPro TX-2C Thermometer
  protocol -246 # unknown




## TPMS Sensor Disabled by default, I don't think you want to enable this.
  protocol -59 # Steelmate TPMS
  protocol -60 # Schrader TPMS
  protocol -82 # Citroen TPMS
  protocol -88 # Toyota TPMS
  protocol -89 # Ford TPMS
  protocol -90 # Renault TPMS
  protocol -95 # Schrader TPMS EG53MA4, PA66GF35
  protocol -110 # PMV-107J (Toyota) TPMS
  protocol -123 # Jansite TPMS Model TY02S
  protocol -140 # Elantra2012 TPMS
  protocol -156 # Abarth 124 Spider TPMS
  protocol -168 # Schrader TPMS SMD3MA4 (Subaru)
  protocol -180 # Jansite TPMS Model Solar
  protocol -186 # Hyundai TPMS (VDO)
  protocol -201 # Unbranded SolarTPMS for trucks
  protocol -203 #Porsche Boxster/Cayman TPMS

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
