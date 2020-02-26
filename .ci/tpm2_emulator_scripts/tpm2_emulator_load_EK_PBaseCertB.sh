#!/bin/bash
# EK and PC Certificate
ek_cert="/home/busaboy1340/workspace/PACCOR_Stuff/ek_cert.der"
platform_base_cert="PBaseCertB.der"

echo "Loading EK and PBaseCertB Platform Cert..."
#PC_DIR=/home/busaboy1340/workspace/PACCOR_Stuff/tpm2-emulator-json
#PC_DIR=/home/busaboy1340/workspace/git/base-delta-good-dev
#PC_DIR=/home/busaboy1340/workspace/git/base-delta-good-dev-2/B2_cert_gen
PC_DIR=/var/hirs/pc_generation

# Define nvram space to enable loading of EK cert (-x NV Index, -a handle to authorize
# [0x40000001 = ownerAuth handle], -s size [defaults to 2048], -t specifies attribute
# value in publicInfo struct [0x2000A = ownerread|ownerwrite|policywrite])

# if already in use, release tpm nvram index 0x1c00002 for endorsement cert
if tpm2_nvlist | grep -q 0x1c00002; then
  echo "Released NVRAM for EK."
  tpm2_nvrelease -x 0x1c00002 -a 0x40000001
fi

# store key in tpm nvram index 0x1c00002
size=$(cat $ek_cert | wc -c)
echo "Define NVRAM location for EK cert of size $size."
tpm2_nvdefine -x 0x1c00002 -a 0x40000001 -t 0x2000A -s $size

echo "Loading EK cert into NVRAM."
tpm2_nvwrite -x 0x1c00002 -a 0x40000001 $ek_cert

# if already in use, release tpm nvram index 0x1c90000 for platform cert
if tpm2_nvlist | grep -q 0x1c90000; then
  echo "Released NVRAM for PC."
  tpm2_nvrelease -x 0x1c90000 -a 0x40000001
fi

# store platform certificate in tpm nvram index 0x1c90000
size=$(cat $PC_DIR/$platform_base_cert | wc -c)
echo "Define NVRAM location for PC cert of size $size."
tpm2_nvdefine -x 0x1c90000 -a 0x40000001 -t 0x2000A -s $size

echo "Loading PC cert into NVRAM."
tpm2_nvwrite -x 0x1c90000 -a 0x40000001 $PC_DIR/$platform_base_cert

echo "===========TPM2 Emulator Initialization Complete!==========="
