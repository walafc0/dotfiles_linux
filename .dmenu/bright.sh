#!/bin/bash

LCD=$(acpi -V | grep LCD |awk '{print $4}')
LCD_T=$(acpi -V | grep LCD |awk '{print $6}')

BRIGHT=LCD*100/
