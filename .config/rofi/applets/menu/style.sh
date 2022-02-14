#!/usr/bin/env bash

# Available Styles
# >> Created and tested on : rofi 1.6.0-1
#
# square     circle     rounded

style="circle"

# uncomment these lines to enable random style
#styles=('circle' 'rounded')
#style="${styles[$(( $RANDOM % 2 ))]}"

# print style name
echo "$style"
