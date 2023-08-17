#!/bin/bash

# This script retrieves the public IP address of the machine it is run on using the ifconfig.me service.
# The IP address is returned in a JSON object with the key "my_ip".
echo "{\"my_ip\": \"$(curl -s ifconfig.me)\"}"
