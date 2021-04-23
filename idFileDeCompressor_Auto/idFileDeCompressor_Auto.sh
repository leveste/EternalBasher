#!/usr/bin/env bash

# This file is part of EternalBasher (https://github.com/leveste/EternalBasher).
# Copyright (C) 2021 leveste and PowerBall253
#
# EternalBasher is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# EternalBasher is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of  
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the  
# GNU General Public License for more details.  
#
# You should have received a copy of the GNU General Public License  
# along with EternalBasher. If not, see <https://www.gnu.org/licenses/>.

while [[ $# -gt 0 ]]
do
	first_line=$(head -n 1 "$1")
	if [[ $first_line == "Version 7" ]]
	then 
		wine "idFileDeCompressor.exe" "-c" "$1" "$1"
	else
		wine "idFileDeCompressor.exe" "-d" "$1" "$1"
	fi
	shift
done