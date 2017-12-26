# Unattended Upgrades profile for all servers
# From Puppet’s perspective, a profile is just a normal class stored in the profile module
class profile::unattended {
    file { '/etc/apt/apt.conf.d/10periodic':
        ensure => file,
        mode => '0644',
        source => 'puppet:///modules/profile/etc/apt/apt.conf.d/10periodic',
    }

    ensure_packages(['unattended-upgrades'])

    file { '/etc/apt/apt.conf.d/50unattended-upgrades':
        ensure => file,
        mode => '0644',
        source => 'puppet:///modules/profile/etc/apt/apt.conf.d/50unattended-upgrades',
        require => Package['unattended-upgrades'],
    }
}
