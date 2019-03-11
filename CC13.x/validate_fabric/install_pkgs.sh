#!/bin/env bash
# Tested on CentOS7 and RedHat7

help()
{
        echo "How to run the script.."
        echo "$0 <username> <password> <poolId>"
        echo "   For example"
        echo "   $0 test@test.com password! 12342343243242424234"
}

check_args()
{
if [ "$#" -ne 3 ]; then
        echo "Correct number of arguments are not passed!!"
        help
        exit 1
fi
}

install_pkgs() {
        username=$1
        password=$2
        poolId=$3
        echo "Install required packages for ovs and os-net-config"
	if cat /etc/redhat-release | grep -q "CentOS" ; then 
                echo "Installing pkgs on CentOS"
		yum clean all 
		yum update -y 
		yum install openvswitch -y
		yum install bridge-utils -y
		curl https://bootstrap.pypa.io/get-pip.py | python
                pip install os-net-config
		sudo /usr/share/openvswitch/scripts/ovs-ctl start
	else 
                echo "Installing pkgs on RedHat"
		check_args
		subscription-manager register --username $username --password $password
                subscription-manager attach --pool=$poolId
                subscription-manager repos --disable="*"
                subscription-manager repos --enable rhel-7-server-rpms --enable rhel-7-server-extras-rpms --enable rhel-7-server-rh-common-rpms --enable rhel-ha-for-rhel-7-server-rpms
                subscription-manager repos --enable rhel-7-server-openstack-13-rpms --enable rhel-7-server-openstack-13-devtools-rpms --enable rhel-7-server-rhceph-3-tools-rpms
                subscription-manager refresh
                yum update -y
                yum install openvswitch -y
                yum install -y python-pip
                pip install os-net-config
		yum install bridge-utils -y
		sudo /usr/share/openvswitch/scripts/ovs-ctl start
	fi
}

install_pkgs "$@"
exit 0
