# NTP profile for all servers
# From Puppet’s perspective, a profile is just a normal class stored in the profile module
class profile::ntp {
    class { '::ntp':
        service_enable  => true,
        service_ensure  => 'running',
        service_manage  => true,
    }
}
