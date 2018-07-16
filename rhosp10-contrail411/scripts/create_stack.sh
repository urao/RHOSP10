#!/bin/bash

STACK_NAME=overcloud
NTP_SERVER_IP="192.168.122.1"
export LOGFILE=/var/log/$STACK_NAME.log
exec > >(tee -a $LOGFILE)
exec 2>&1

echo "=======Start time and date===================="
echo "=======$(date)================================"

set -xv
TEMPLATE_DIR=/home/tripleo-heat-templates/
TEMPLATE_ENV_DIR=/home/tripleo-heat-templates/environments/

source /home/stack/stackrc

time openstack overcloud deploy --stack $STACK_NAME \
	--templates $TEMPLATE_DIR \
	-r $TEMPATE_ENV_DIR/contrail/roles_data.yaml \
	-e $TEMPLATE_ENV_DIR/puppet-pacemaker.yaml \
	-e $TEMPLATE_ENV_DIR/network-management.yaml \
	-e $TEMPLATE_ENV_DIR/contrail/contrail-services.yaml \
	-e $TEMPLATE_ENV_DIR/contrail/hostname-map.yaml \
	-e $TEMPLATE_ENV_DIR/contrail/scheduler-hints.yaml \
	-e $TEMPLATE_ENV_DIR/contrail/network-isolation.yaml \
	-e $TEMPLATE_ENV_DIR/contrail/contrail-net.yaml \
	-e $TEMPLATE_ENV_DIR/contrail/ips-from-pool-all.yaml \
	-e $TEMPLATE_DIR/extraconfig/pre_deploy/rhel-registration/environment-rhel-registration.yaml \
	-e $TEMPLATE_DIR/extraconfig/pre_deploy/rhel-registration/rhel-registration-resource-registry.yaml \
	--ntp-server $NTP_SERVER_IP

echo "=======End time and date===================="
echo "=======$(date)================================"
