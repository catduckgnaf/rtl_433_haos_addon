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
rtl_device_id_1=$(bashio::config 'rtl_device_id_1')
rtl_device_id_2=$(bashio::config 'rtl_device_id_2')
rtl_device_id_3=$(bashio::config 'rtl_device_id_3')
rtl_device_id_4=$(bashio::config 'rtl_device_id_4')
rtl_device_id_5=$(bashio::config 'rtl_device_id_5')
rtl_device_id_6=$(bashio::config 'rtl_device_id_6')
rtl_device_id_7=$(bashio::config 'rtl_device_id_7')
rtl_device_id_8=$(bashio::config 'rtl_device_id_8')
1=$(bashio::config '1_silvercrest_remote_control')
2=$(bashio::config '2_rubicson_tfa_30_3197_infactory_pt_310_temperature_sensor')
3=$(bashio::config '3_prologue_freetec_nc_7104_nc_7159_675_temperature_sensor')
4=$(bashio::config '4_waveman_switch_transmitter')
8=$(bashio::config '8_lacrosse_tx_temperature_humidity_sensor')
9=$(bashio::config '9_acurite_896_rain_gauge')
10=$(bashio::config '10_acurite_609txc_temperature_and_humidity_sensor')
11=$(bashio::config '11_oregon_scientific_weather_sensor')
12=$(bashio::config '12_klikaanklikuit_wireless_switch')
13=$(bashio::config '13_alectov1_weather_sensor_alecto_ws3500_ws4500_ventus_w155_w044_oregon')
14=$(bashio::config '14_cardin_s466_tx2')
15=$(bashio::config '15_fine_offset_electronics_wh2_wh5_telldus_temperature_humidity_rain_sensor')
16=$(bashio::config '16_nexus_freetec_nc_7345_nx_3980_solight_te82s_tfa_30_3209_temperature_humidity_sensor')
17=$(bashio::config '17_ambient_weather_f007th_tfa_30_3208_02_switchdoclabs_f016th_temperature_sensor')
18=$(bashio::config '18_calibeur_rf_104_sensor')
19=$(bashio::config '19_x10_rf')
20=$(bashio::config '20_dsc_security_contact')
21=$(bashio::config '21_globaltronics_gt_wt_02_sensor')
22=$(bashio::config '22_danfoss_cfr_thermostat')
23=$(bashio::config '23_chuango_security_technology')
24=$(bashio::config '24_generic_remote_sc226x_ev1527')
25=$(bashio::config '25_tfa_twin_plus_30_3049_conrad_kw9010_ea2_bl999')
26=$(bashio::config '26_fine_offset_electronics_wh1080_wh3080_weather_station')
27=$(bashio::config '27_wt450_wt260h_wt405h')
28=$(bashio::config '28_lacrosse_ws_2310_ws_3600_weather_station')
29=$(bashio::config '29_esperanza_ews')
30=$(bashio::config '30_efergy_e2_classic')
31=$(bashio::config '31_inovalley_kw9015b_tfa_dostmann_30_3161_rain_and_temperature_sensor')
32=$(bashio::config '32_generic_temperature_sensor_1')
33=$(bashio::config '33_wg_pb12v1_temperature_sensor')
34=$(bashio::config '34_acurite_592txr_temp_humidity_592tx_temp_5n1_weather_station_6045_lightning_899_rain_3n1_atlas')
35=$(bashio::config '35_acurite_986_refrigerator_freezer_thermometer')
36=$(bashio::config '36_hideki_ts04_temperature_humidity_wind_and_rain_sensor')
37=$(bashio::config '37_watchman_sonic_apollo_ultrasonic_beckett_rocket_oil_tank_monitor')
38=$(bashio::config '38_currentcost_current_sensor')
39=$(bashio::config '39_emontx_openenergymonitor')
40=$(bashio::config '40_ht680_remote_control')
41=$(bashio::config '41_conrad_s3318p_freetec_nc_5849_913_temperature_humidity_sensor')
42=$(bashio::config '42_akhan_100f14_remote_keyless_entry')
43=$(bashio::config '43_quhwa')
44=$(bashio::config '44_osv1_temperature_sensor')
45=$(bashio::config '45_proove_nexa_klikaanklikuit_wireless_switch')
46=$(bashio::config '46_bresser_thermo_hygro_sensor_3ch')
47=$(bashio::config '47_springfield_temperature_and_soil_moisture')
48=$(bashio::config '48_oregon_scientific_sl109h_remote_thermal_hygro_sensor')
49=$(bashio::config '49_acurite_606tx_temperature_sensor')
50=$(bashio::config '50_tfa_pool_temperature_sensor')
51=$(bashio::config '51_kedsum_temperature_humidity_sensor_pearl_nc_7415')
52=$(bashio::config '52_blyss_dc5_uk_wh')
53=$(bashio::config '53_lightwaverf')
54=$(bashio::config '54_elro_db286a_doorbell')
55=$(bashio::config '55_efergy_optical')
56=$(bashio::config '56_honda_car_key')
57=$(bashio::config '57_radiohead_ask')
58=$(bashio::config '58_kerui_pir_contact_sensor')
59=$(bashio::config '59_fine_offset_wh1050_weather_station')
60=$(bashio::config '60_honeywell_door_window_sensor_2gig_dw10_dw11_re208_repeater')
61=$(bashio::config '61_maverick_et_732_733_bbq_sensor')
62=$(bashio::config '62_rf_tech')
63=$(bashio::config '63_lacrosse_tx141_bv2_tx141th_bv2_tx141_bv3_tx141w_tx145wsdth_tfa_oria_sensor')
64=$(bashio::config '64_acurite_00275rm_00276rm_temp_humidity_with_optional_probe')
65=$(bashio::config '65_lacrosse_tx35dth_it_tfa_dostmann_30_3155_temperature_humidity_sensor')
66=$(bashio::config '66_lacrosse_tx29it_tfa_dostmann_30_3159_it_temperature_sensor')
67=$(bashio::config '67_vaillant_calormatic_vrt340f_central_heating_control')
68=$(bashio::config '68_fine_offset_electronics_wh25_wh32b_wh24_wh65b_hp1000_misol_ws2320_temperature_humidity_pressure_sensor')
69=$(bashio::config '69_fine_offset_electronics_wh0530_temperature_rain_sensor')
70=$(bashio::config '70_ibis_beacon')
71=$(bashio::config '71_oil_ultrasonic_standard_fsk')
72=$(bashio::config '72_oil_ultrasonic_standard_ask')
73=$(bashio::config '73_thermopro_tp11_thermometer')
74=$(bashio::config '74_solight_te44_te66_emos_e0107t_nx_6876_917')
75=$(bashio::config '75_wireless_smoke_and_heat_detector_gs_558')
76=$(bashio::config '76_generic_wireless_motion_sensor')
77=$(bashio::config '77_infactory_nor_tec_freetec_nc_3982_913_temperature_humidity_sensor')
78=$(bashio::config '78_ft_004_b_temperature_sensor')
79=$(bashio::config '79_ford_car_key')
80=$(bashio::config '80_philips_outdoor_temperature_sensor_type_aj3650')
81=$(bashio::config '81_nexa')
82=$(bashio::config '82_thermopro_tp08_tp12_tp20_thermometer')
83=$(bashio::config '83_ge_color_effects')
84=$(bashio::config '84_x10_security')
85=$(bashio::config '85_interlogix_ge_utc_security_devices')
86=$(bashio::config '86_dish_remote_6_3')
87=$(bashio::config '87_simplisafe_home_security_system_may_require_disabling_automatic_gain_for_keypad_decodes')
88=$(bashio::config '88_sensible_living_mini_plant_moisture_sensor')
89=$(bashio::config '89_wireless_m_bus_mode_c_t_100kbps_f_868_95m_s_1200k')
90=$(bashio::config '90_wireless_m_bus_mode_s_32_768kbps_f_868_3m_s_1000k')
91=$(bashio::config '91_wireless_m_bus_mode_r_4_8kbps_f_868_33m')
92=$(bashio::config '92_wireless_m_bus_mode_f_2_4kbps')
93=$(bashio::config '93_hyundai_ws_senzor_remote_temperature_sensor')
94=$(bashio::config '94_wt0124_pool_thermometer')
95=$(bashio::config '95_emos_ttx201_temperature_sensor')
96=$(bashio::config '96_ambient_weather_tx_8300_temperature_humidity_sensor')
97=$(bashio::config '97_ambient_weather_wh31e_thermo_hygrometer_sensor_ecowitt_wh40_rain_gauge')
98=$(bashio::config '98_maverick_et73')
99=$(bashio::config '99_honeywell_activlink_wireless_doorbell')
100=$(bashio::config '100_honeywell_activlink_wireless_doorbell_fsk')
101=$(bashio::config '101_esa1000_esa2000_energy_monitor')
102=$(bashio::config '102_biltema_rain_gauge')
103=$(bashio::config '103_bresser_weather_center_5_in_1')
104=$(bashio::config '104_digitech_xc_0324_ambientweather_ft005th_temp_hum_sensor')
105=$(bashio::config '105_opus_imagintronix_xt300_soil_moisture')
106=$(bashio::config '106_fs20')
107=$(bashio::config '107_lacrosse_elv_conrad_ws7000_ws2500_weather_sensors')
108=$(bashio::config '108_ts_ft002_wireless_ultrasonic_tank_liquid_level_meter_with_temperature_sensor')
109=$(bashio::config '109_companion_wtr001_temperature_sensor')
110=$(bashio::config '110_ecowitt_wireless_outdoor_thermometer_wh53_wh0280_wh0281a')
111=$(bashio::config '111_directv_rc66rx_remote_control')
112=$(bashio::config '112_eurochron_temperature_and_humidity_sensor')
113=$(bashio::config '113_ikea_sparsnas_energy_meter_monitor')
114=$(bashio::config '114_microchip_hcs200_hcs300_keeloq_hopping_encoder_based_remotes')
115=$(bashio::config '115_tfa_dostmann_30_3196_t_h_outdoor_sensor')
116=$(bashio::config '116_rubicson_48659_thermometer')
117=$(bashio::config '117_aok_weather_station_rebrand_holman_industries_iweather_ws5029_conrad_aok_5056_optex_990018')
118=$(bashio::config '118_philips_outdoor_temperature_sensor_type_aj7010')
119=$(bashio::config '119_esic_emt7110_power_meter')
120=$(bashio::config '120_globaltronics_quigg_gt_tmbbq_05')
121=$(bashio::config '121_globaltronics_gt_wt_03_sensor')
122=$(bashio::config '122_norgo_nge101')
123=$(bashio::config '123_auriol_hg02832_hg05124a_dcf_rubicson_48957_temperature_humidity_sensor')
124=$(bashio::config '124_fine_offset_electronics_ecowitt_wh51_switchdoc_labs_sm23_soil_moisture_sensor')
125=$(bashio::config '125_holman_industries_iweather_ws5029_weather_station_older_pwm')
126=$(bashio::config '126_tbh_weather_sensor')
127=$(bashio::config '127_ws2032_weather_station')
128=$(bashio::config '128_auriol_afw2a1_temperature_humidity_sensor')
129=$(bashio::config '129_tfa_drop_rain_gauge_30_3233_01')
130=$(bashio::config '130_dsc_security_contact_ws4945')
131=$(bashio::config '131_ert_standard_consumption_message_scm')
132=$(bashio::config '132_klimalogg')
133=$(bashio::config '133_visonic_powercode')
134=$(bashio::config '134_eurochron_efth_800_temperature_and_humidity_sensor')
135=$(bashio::config '135_cotech_36_7959_switchdoclabs_ft020t_wireless_weather_station_with_usb')
136=$(bashio::config '136_standard_consumption_message_plus_scmplus')
137=$(bashio::config '137_fine_offset_electronics_wh1080_wh3080_weather_station_fsk')
138=$(bashio::config '138_missil_ml0757_weather_station')
139=$(bashio::config '139_sharp_spc775_weather_station')
140=$(bashio::config '140_insteon')
141=$(bashio::config '141_ert_interval_data_message_idm')
142=$(bashio::config '142_ert_interval_data_message_idm_for_net_meters')
143=$(bashio::config '143_thermopro_tx2_temperature_sensor')
144=$(bashio::config '144_acurite_590tx_temperature_with_optional_humidity')
145=$(bashio::config '145_security_2_0_keyfob')
146=$(bashio::config '146_tfa_dostmann_30_3221_02_t_h_outdoor_sensor')
147=$(bashio::config '147_lacrosse_technology_view_ltv_wsdth01_breeze_pro_wind_sensor')
148=$(bashio::config '148_somfy_rts')
149=$(bashio::config '149_nice_flor_s_remote_control_for_gates')
150=$(bashio::config '150_lacrosse_technology_view_ltv_wr1_multi_sensor')
151=$(bashio::config '151_lacrosse_technology_view_ltv_th_thermo_hygro_sensor')
152=$(bashio::config '152_bresser_weather_center_6_in_1_7_in_1_indoor_soil_new_5_in_1_3_in_1_wind_gauge_froggit_wh6000_ventus_c8488a)
153=$(bashio::config '153_bresser_weather_center_7_in_1')
154=$(bashio::config '154_ecodhome_smart_socket_and_mcee_solar_monitor')
155=$(bashio::config '155_lacrosse_technology_view_ltv_r1_ltv_r3_rainfall_gauge_ltv_w1_w2_wind_sensor')
156=$(bashio::config '156_blueline_innovations_power_cost_monitor')
157=$(bashio::config '157_burnhard_bbq_thermometer')
158=$(bashio::config '158_security_keyfob')
159=$(bashio::config '159_cavius_smoke_heat_and_water_detector')
160=$(bashio::config '160_amazon_basics_meat_thermometer')
161=$(bashio::config '161_tfa_marbella_pool_thermometer')
162=$(bashio::config '162_auriol_ahfl_temperature_humidity_sensor')
163=$(bashio::config '163_auriol_aft_77_b2_temperature_sensor')
164=$(bashio::config '164_honeywell_cm921_wireless_programmable_room_thermostat')
165=$(bashio::config '165_rojaflex_shutter_and_remote_devices')
166=$(bashio::config '166_marlec_solar_iboot_sensors')
167=$(bashio::config '167_somfy_io_homecontrol')
168=$(bashio::config '168_ambient_weather_wh31l_fineoffset_wh57_lightning_strike_sensor')
169=$(bashio::config '169_markisol_e_motion_bofu_rollerhouse_bf_30x_bf_415_curtain_remote')
170=$(bashio::config '170_govee_water_leak_detector_h5054_door_contact_sensor_b5023')
171=$(bashio::config '171_clipsal_cmr113_cent_a_meter_power_meter')
172=$(bashio::config '172_fine_offset_electronics_ws80_weather_station')
173=$(bashio::config '173_unknown')
174=$(bashio::config '174_emos_e6016_weather')
175=$(bashio::config '175_emos_e6016_weatherstation_with_dcf77')
176=$(bashio::config '176_ant_and_ant_devices')
177=$(bashio::config '177_emos_e6016_rain_gauge')
178=$(bashio::config '178_microchip_hcs200_hcs300_keeloq_hopping_encoder_based_remotes_fsk')
179=$(bashio::config '179_fine_offset_electronics_wh45_air_quality_sensor')
180=$(bashio::config '180_maverick_xr_30_bbq_sensor')
181=$(bashio::config '181_fine_offset_electronics_wn34_temperature_sensor')
182=$(bashio::config '182_rubicson_pool_thermometer_48942')
183=$(bashio::config '183_badger_orion_water_meter_100kbps_f_916_45m_s_1200k')
184=$(bashio::config '184_geo_minim_energy_monitor')
185=$(bashio::config '185_unknown')
186=$(bashio::config '186_unknown')
187=$(bashio::config '187_srsmith_pool_light_remote_control_srs_2c_tx_f_915m')
188=$(bashio::config '188_neptune_r900_flow_meters')
189=$(bashio::config '189_wec_2103_temperature_humidity_sensor')
190=$(bashio::config '190_vauno_en8822c')
191=$(bashio::config '191_govee_water_leak_detector_h5054')
192=$(bashio::config '192_tfa_dostmann_14_1504_v2_radio_controlled_grill_and_meat_thermometer')
193=$(bashio::config '193_ced7000_shot_timer')
194=$(bashio::config '194_watchman_sonic_advanced_plus')
195=$(bashio::config '195_oil_ultrasonic_smart_fsk')
196=$(bashio::config '196_gasmate_ba1008_meat_thermometer')
197=$(bashio::config '197_flowis_flow_meters')
198=$(bashio::config '198_wireless_m_bus_mode_t_32_768kbps_f_868_3m_s_1000k')
199=$(bashio::config '199_revolt_nc_5642_energy_meter')
200=$(bashio::config '200_auriol_4_ld5661_4_ld5972_4_ld6313_temperature_rain_sensors')
202=$(bashio::config '202_funkbus_instafunk_berker_gira_jung')
204=$(bashio::config '204_jasco_ge_choice_alert_security_devices')
205=$(bashio::config '205_telldus_weather_station_ft0385r_sensors')
206=$(bashio::config '206_lacrosse_tx34_it_rain_gauge')
207=$(bashio::config '207_smartfire_proflame_2_remote_control')
208=$(bashio::config '208_unknown')
209=$(bashio::config '209_simplisafe_gen_3_home_security_system')
210=$(bashio::config '210_yale_hsa_home_security_alarm_yes_alarmkit')
211=$(bashio::config '211_regency_ceiling_fan_remote_f_303_75m_to_303_96m')
213=$(bashio::config '213_fine_offset_electronics_ws80_weather_station')
212=$(bashio::config '212_unknown')
214=$(bashio::config '214_emos_e6016_rain_gauge')
215=$(bashio::config '215_emax_w6_rebrand')
216=$(bashio::config '216_ant_and_ant_devices')
217=$(bashio::config '217_emos_e6016_rain_gauge')
218=$(bashio::config '218_microchip_hcs200_hcs300_keeloq_hopping_encoder_based_remotes_fsk')
219=$(bashio::config '219_fine_offset_electronics_wh45_air_quality_sensor')
220=$(bashio::config '220_maverick_xr_30_bbq_sensor')
221=$(bashio::config '221_fine_offset_electronics_wn34_temperature_sensor')
222=$(bashio::config '222_rubicson_pool_thermometer_48942')
223=$(bashio::config '223_badger_orion_water_meter_100kbps_f_916_45m_s_1200k')
224=$(bashio::config '224_geo_minim_energy_monitor')
225=$(bashio::config '225_unknown')
226=$(bashio::config '226_unknown')
227=$(bashio::config '227_srsmith_pool_light_remote_control_srs_2c_tx_f_915m')
228=$(bashio::config '228_neptune_r900_flow_meters')
229=$(bashio::config '229_wec_2103_temperature_humidity_sensor')
230=$(bashio::config '230_vauno_en8822c')
231=$(bashio::config '231_govee_water_leak_detector_h5054')
232=$(bashio::config '232_tfa_dostmann_14_1504_v2_radio_controlled_grill_and_meat_thermometer')
233=$(bashio::config '233_ced7000_shot_timer')
234=$(bashio::config '234_watchman_sonic_advanced_plus')
235=$(bashio::config '235_oil_ultrasonic_smart_fsk')
236=$(bashio::config '236_gasmate_ba1008_meat_thermometer')
237=$(bashio::config '237_flowis_flow_meters')
238=$(bashio::config '238_wireless_m_bus_mode_t_32_768kbps_f_868_3m_s_1000k')
239=$(bashio::config '239_revolt_nc_5642_energy_meter')
240=$(bashio::config '240_lacrosse_tx31u_it_the_weather_channel_ws_1910twc_it')
226=$(bashio::config '226_unknown')
241=$(bashio::config '241_unknown')
242=$(bashio::config '242_baldr_rainpoint_rain_gauge')
243=$(bashio::config '243_celsia_czc1_thermostat')
244=$(bashio::config '244_fine_offset_electronics_ws90_weather_station')
245=$(bashio::config '245_thermopro_tx_2c_thermometer')
246=$(bashio::config '246_unknown')


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

rtl_433 -c "$conf_directory/$conf_file" -R $rtl_device_id_1 $rtl_device_id_2 130
echo "Starting rtl_433 with $conf_file located in $conf_directory with devices $rtl_device_id_1 $rtl_device_id_2

if bashio::config.true 'discovery'; then
    echo "Starting discovery script"
    python3 -u "$script_directory/rtl_433_mqtt_hass.py" -H "$discovery_host" -p "$discovery_port" -R "$discovery_topic" -D "$discovery_prefix" -i "$discovery_interval" --ids "$discovery_ids"
    rtl_433_pids+=($!)
fi

# Instead of waiting for any process to finish, loop indefinitely
while true; do
    sleep infinity
done
