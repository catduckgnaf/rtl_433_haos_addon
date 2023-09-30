# rtl_433 Home Assistant Add-on Radio for the People Community Edition

## About

RTL_433 Add On that will let you filter the devices you want, not the ones you don't. Constantly updated by the community.

#why did I do this?

I believe the community needs to own this script, to make modifications, and add things we want without the baggage of the existing rtl_433 codebase. For example the current add-on links directly to the 433 project, so when they make a breaking change there is no control, and the project is so large, nobody has put effort to improve the script. Many HA users want contact and door sensors, and are manually doing mqtt instead. I don't want weather sensors, I want door sensors! (weather sensors are there too

Done so far
You should know be able to list the specific IDs you want to include from the add-on configeration! You then also want to check the config template to match, https://github.com/catduckgnaf/rtl_433_ha/blob/main/config/rtl_433.conf.template All IDs are listed there, but - by default. Next step is to make discovery work with the config.template so you don't need to edit both.

Currently you can add only one ID at a time. This is not ideal and should be editable from a file (or ideally the existing template)
Pre-requesites and instructions:
rtl_433 or otherwise from 
Make sure its installed and started
replace the rtl_433.conf.template (yes keep the template part) that is in /config/rtl_433 with this one. https://github.com/catduckgnaf/rtl_433_ha/blob/main/config/rtl_433.conf.template (read the instructions)
Install the add-on discovery script (This one). There is a new option to only list the Ids you want.
Profit
