#!/bin/bash
source /etc/lsb-release
apt-key adv --fetch-keys http://apt.puppetlabs.com/DEB-GPG-KEY-puppet
wget http://apt.puppetlabs.com/puppetlabs-release-pc1-${DISTRIB_CODENAME}.deb
dpkg -i puppetlabs-release-pc1-${DISTRIB_CODENAME}.deb
apt-get update
apt-get -y install puppet-agent
/opt/puppetlabs/puppet/bin/gem install r10k --no-rdoc --no-ri
cd /etc/puppetlabs/code/environments/production
/opt/puppetlabs/puppet/bin/r10k puppetfile install --verbose
/opt/puppetlabs/bin/puppet apply --environment=production /etc/puppetlabs/code/environments/production/manifests
