#!/usr/bin/env sh

# Authors:
#   Unai Martinez-Corral
#
# Copyright 2020-2021 Unai Martinez-Corral <unai.martinezcorral@ehu.eus>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

# IMPORTANT: This script needs to be executed on an environment with an screen, since GTKWave is executed at the end.

# Update the MSYS2 installation (sync repos and install newer packages)
pacman -Syu --noconfirm

# Install the dependencies for simulation and synthesis of VHDL is FLOSS tools
pacman -S --noconfirm p7zip git \
    mingw-w64-x86_64-yosys \
    mingw-w64-x86_64-gtkwave \
    mingw-w64-x86_64-python-pip

# FIXME: temporal workaround for using the GTK2 build of GTKWave by default
pacman -S --noconfirm mingw-w64-x86_64-gtk2
mv /mingw64/bin/gtkwave /mingw64/bin/gtkwave-gtk3
mv /mingw64/bin/gtkwave-gtk2 /mingw64/bin/gtkwave

# Install VUnit from sources (master branch)
git clone --recurse-submodules https://github.com/VUnit/vunit
cd vunit
python setup.py install

# Test that the installation of the tools was succesful
cd examples/vhdl/array_axis_vcs
python run.py -v -g