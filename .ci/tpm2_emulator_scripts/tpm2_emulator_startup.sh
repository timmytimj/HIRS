#!/bin/bash
##############################################################################
# tpm2_emulator_startup.sh
#
# This script starts up the TPM2 Emulator.
##############################################################################

echo "===========TPM2 Emulator Starting....==========="
cd /opt/tpm/tpm2.0

echo "Starting tpm_server..."
nohup ./src/tpm_server > tpm_server.log &

# Give tpm_server time to start and register on the DBus
sleep 5

echo "Starting abrmd...."
nohup /sbin/tpm2-abrmd -t "socket" > emulator.log &

# Give ABRMD time to start and register on the DBus
sleep 5

tpm2_nvlist
tpm2_pcrlist
echo "===========TPM2 Emulator Started!    ==========="
