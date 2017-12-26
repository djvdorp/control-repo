# Apticron profile for all servers
# From Puppet’s perspective, a profile is just a normal class stored in the profile module
class profile::apticron {
    ensure_packages(['apticron','apt-listchanges'])

    file { '/etc/apticron/apticron.conf':
        ensure => file,
        mode => '0644',
        source => 'puppet:///modules/profile/etc/apticron/apticron.conf',
        require => Package['apticron'],
    }
}
