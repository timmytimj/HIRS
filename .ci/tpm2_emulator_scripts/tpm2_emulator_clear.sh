#!/bin/bash
##############################################################################
# tpm2_emulator_clear.sh
# This script clears the TPM2 NVRAM. 
##############################################################################

# if already in use, release tpm nvram index 0x1c00002 for endorsement cert
if tpm2_nvlist | grep -q 0x1c00002; then
  echo "Released NVRAM for EK."
  tpm2_nvrelease -x 0x1c00002 -a 0x40000001
fi

# if already in use, release tpm nvram index 0x1c90000 for platform cert
if tpm2_nvlist | grep -q 0x1c0000c; then
  echo "Released NVRAM for UKN."
  tpm2_nvrelease -x 0x1c0000c -a 0x40000001
fi

# if already in use, release tpm nvram index 0x1c90000 for platform cert
if tpm2_nvlist | grep -q 0x1c90000; then
  echo "Released NVRAM for PC(Base)."
  tpm2_nvrelease -x 0x1c90000 -a 0x40000001
fi

# if already in use, release tpm nvram index 0x1c90800 for platform cert
if tpm2_nvlist | grep -q 0x1c90800; then
  echo "Released NVRAM for PC(Delta)."
  tpm2_nvrelease -x 0x1c90800 -a 0x40000001
fi


echo "===========TPM2 Emulator Clear Complete!==========="

