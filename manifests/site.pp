# Manage puppetlabs-firewall global setup

# Below is a metatype to purge unmanaged firewall resources.
# This will clear any existing rules and make sure that only rules defined in Puppet exist on the machine.
#
# Purging unmanaged firewall resources means that eg. the fail2ban target will be purged.
resources { 'firewall':
  purge =>  true,
}

# Below is a metatype to purge unmanaged firewall chains.
#
# Purging unmanaged firewall chains means that eg. the fail2ban chain will be purged.
resources { 'firewallchain':
  purge => false,
}

Firewall {
  before  => Class['profile::firewall_post'],
  require => Class['profile::firewall_pre'],
}

class { ['profile::firewall_pre', 'profile::firewall_post']: }
class { 'profile::firewall': }

# Include all classes from (hiera)data and put them in a merged, flattened array with all duplicate values removed.
include(lookup('classes', { 'merge' => 'unique' }))
