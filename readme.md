# This is the Add On Repository for the rtl_433_haos_autodiscovery Community Edition!



[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fcatduckgnaf%2Frtl_433_haos_addon)

To see the "main" page the project work, go here: https://github.com/catduckgnaf/rtl_433_ha




# Why?

I believe the community needs to own this script, to make modifications, and add things we want without the baggage of the existing rtl_433 codebase. For example the current add-on links directly to the 433 project, so when they make a breaking change there is no control, and the project is so large, nobody has put effort to improve the script. Many HA users want contact and door sensors, and are manually doing mqtt instead. I don't want weather sensors, I want door sensors! (weather sensors are there too

## Done so far

You should know be able to list the specific IDs you want to include from the add-on configeration! You then also want to check the config template to match, https://github.com/catduckgnaf/rtl_433_ha/blob/main/config/rtl_433.conf.template
All IDs are listed there, but - by default. Next step is to make discovery work with the config.template so you don't need to edit both.

## Currently you can add only one ID at a time. This is not ideal and should be editable from a file (or ideally the existing template)

## Pre-requesites and instructions:

1. rtl_433 or otherwise from https://github.com/pbkhrv/rtl_433-hass-addons/tree/main/rtl_433-next
2. Make sure its installed and started
3. replace the rtl_433.conf.template (yes keep the template part) that is in /config/rtl_433 with this one. https://github.com/catduckgnaf/rtl_433_ha/blob/main/config/rtl_433.conf.template (read the instructions)
4. Install the add-on discovery script (This one). There is a new option to only list the Ids you want.
5. Profit





[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg
