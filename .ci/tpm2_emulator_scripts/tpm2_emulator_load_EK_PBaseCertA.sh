#!/bin/bash
# EK and PC Certificate
ek_cert="/home/busaboy1340/workspace/PACCOR_Stuff/ek_cert.der"
platform_base_cert="PBaseCertA.der"

echo "Loading EK and PBaseCertA Platform Cert..."
#PC_DIR=/home/busaboy1340/workspace/git/system_tests_08192019_validation_base_correction
#PC_DIR=/home/busaboy1340/workspace/git/system_tests_08212019
#PC_DIR=/home/busaboy1340/workspace/git/system_tests_08222019
#PC_DIR=/home/busaboy1340/workspace/git/system_tests_08222019/certs_for_test_A7
#PC_DIR=/home/busaboy1340/workspace/git/system_tests_08222019/certs_08282019
#PC_DIR=/home/busaboy1340/workspace/git/system_tests_09032019/certs_09032019
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
