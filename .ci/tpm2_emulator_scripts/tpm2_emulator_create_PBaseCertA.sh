#!/bin/bash
# EK and PC Certificate
ek_cert="/home/busaboy1340/workspace/PACCOR_Stuff/ek_cert.der"
ca_cert="/home/busaboy1340/workspace/PACCOR_Stuff/ca.crt"
ca_key="/home/busaboy1340/workspace/PACCOR_Stuff/ca.key"
platform_base_cert="PBaseCertA.der"

echo "Creating PBaseCertA Platform Cert..."
PC_DIR=/var/hirs/pc_generation

rm -f $PC_DIR/observerFile
rm -f $PC_DIR/PBaseCertA.der

/opt/paccor/scripts/referenceoptions.sh > $PC_DIR/optionsFile
/opt/paccor/scripts/otherextensions.sh > $PC_DIR/extensionsFile
/opt/paccor/bin/observer -c $PC_DIR/PBaseCertA.componentlist.json -p $PC_DIR/optionsFile -e $ek_cert -f $PC_DIR/observerFile
/opt/paccor/bin/signer -c $PC_DIR/PBaseCertA.componentlist.json -o $PC_DIR/observerFile -x $PC_DIR/extensionsFile -b 20180101 -a 20280101 -N $RANDOM -k $ca_key -P $ca_cert -e $ek_cert -f $PC_DIR/$platform_base_cert

echo "=========== Done! ==========="
