#!/bin/bash
# EK and PC Certificate
ek_cert="/home/busaboy1340/workspace/PACCOR_Stuff/ek_cert.der"
ca_cert="/home/busaboy1340/workspace/PACCOR_Stuff/ca.crt"
ca_key="/home/busaboy1340/workspace/PACCOR_Stuff/ca.key"
platform_base_cert="PBaseCertB.der"
delta_cert="VARDeltaCertB1.der"

echo "Creating $delta_cert using $platform_base_cert..."
PC_DIR=/var/hirs/pc_generation
#rm -f $PC_DIR/componentsFile
#rm -f $PC_DIR/optionsFile
#rm -f $PC_DIR/extenstionsFile
rm -f $PC_DIR/observerFile
rm -f $PC_DIR/$delta_cert

#/opt/paccor/scripts/allcomponents.sh > $PC_DIR/componentsFile
#/opt/paccor/scripts/referenceoptions.sh > $PC_DIR/optionsFile
#/opt/paccor/scripts/otherextensions.sh > $PC_DIR/extensionsFile
#/opt/paccor/bin/observer -c $PC_DIR/SIDeltaCertB1.componentlist.json -p $PC_DIR/optionsFile -e $ek_cert_der -f $PC_DIR/observerFile
/opt/paccor/bin/observer -c $PC_DIR/VARDeltaCertB1.componentlist.json -p $PC_DIR/optionsFile -e $PC_DIR/$platform_base_cert -f $PC_DIR/observerFile
/opt/paccor/bin/signer -c $PC_DIR/VARDeltaCertB1.componentlist.json -o $PC_DIR/observerFile -x $PC_DIR/extensionsFile -b 20180301 -a 20280101 -N $RANDOM -k $ca_key -P $ca_cert -e $PC_DIR/$platform_base_cert -f $PC_DIR/$delta_cert

echo "=========== Done! ==========="
