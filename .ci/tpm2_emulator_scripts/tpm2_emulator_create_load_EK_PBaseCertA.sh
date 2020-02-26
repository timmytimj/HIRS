#!/bin/bash
# EK and PC Certificate
ek_cert="/home/busaboy1340/workspace/PACCOR_Stuff/ek_cert.der"
ca_cert="/home/busaboy1340/workspace/PACCOR_Stuff/ca.crt"
ca_key="/home/busaboy1340/workspace/PACCOR_Stuff/ca.key"
platform_base_cert="PBaseCertA.der"

echo "Creating PBaseCertA Platform Cert..."
#PC_DIR=/home/busaboy1340/workspace/PACCOR_Stuff/tpm2-emulator-json
PC_DIR=/var/hirs/pc_generation
rm -rf $PC_DIR/*
#mkdir -p $PC_DIR
#rm -f $PC_DIR/PBaseCertA.componentlist.json
#rm -f $PC_DIR/PBaseCertA-ver2.componentlist.json
#rm -f $PC_DIR/optionsFile
#rm -f $PC_DIR/extenstionsFile
#rm -f $PC_DIR/observerFile
#rm -f $PC_DIR/PBaseCertA.der

/opt/paccor/scripts/allcomponents.sh > $PC_DIR/PBaseCertA.componentlist.json
/opt/paccor/scripts/referenceoptions.sh > $PC_DIR/optionsFile
/opt/paccor/scripts/otherextensions.sh > $PC_DIR/extensionsFile
/opt/paccor/bin/observer -c $PC_DIR/PBaseCertA.componentlist.json -p $PC_DIR/optionsFile -e $ek_cert -f $PC_DIR/observerFile
#/opt/paccor/bin/signer -c $PC_DIR/PBaseCertA.componentlist.json -o $PC_DIR/observerFile -x $PC_DIR/extensionsFile -b 20180101 -a 20280101 -N $RANDOM -k /home/busaboy1340/workspace/PACCOR_Stuff/ca.key -P /home/busaboy1340/workspace/PACCOR_Stuff/ca.crt -e $ek_cert -f $PC_DIR/$platform_base_cert
/opt/paccor/bin/signer -c $PC_DIR/PBaseCertA.componentlist.json -o $PC_DIR/observerFile -x $PC_DIR/extensionsFile -b 20180101 -a 20280101 -N $RANDOM -k $ca_key -P $ca_cert -e $ek_cert -f $PC_DIR/$platform_base_cert

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
