# Common profile for all servers
# From Puppet’s perspective, a profile is just a normal class stored in the profile module
class profile::common (
    Array[String] $misc_packages = [],
    Boolean $firewall_enabled = true,
) {
  class { 'timezone':
    timezone => 'Europe/Amsterdam',
  }

  file { '/etc/apt/apt.conf.d/00InstallRecommends':
      ensure => file,
      mode => '0644',
      source => 'puppet:///modules/profile/etc/apt/apt.conf.d/00InstallRecommends',
  }

  ensure_packages($misc_packages)

  host { 'localhost.localdomain':
    ip              => '127.0.0.1',
    host_aliases    => 'localhost',
  }

  host { "${::fqdn}":
    ip              => '127.0.1.1',
    host_aliases    => "${::hostname}",
  }

  sysctl { 'net.ipv4.conf.all.accept_source_route': value    => '0' }
  sysctl { 'net.ipv6.conf.all.accept_source_route': value    => '0' }
  sysctl { 'fs.file-max': value                              => '2097152' }
  sysctl { 'net.core.somaxconn': value                       => '1024' }
  sysctl { 'net.ipv4.ip_local_port_range': value             => '10000 65535' }
  sysctl { 'net.ipv4.tcp_tw_reuse': value                    => '1' }
  sysctl { 'vm.swappiness': value                            => '60' }

  if $firewall_enabled {
    sysctl { 'net.netfilter.nf_conntrack_max': value                        => '131072' } # double of 65536 default value
    sysctl { 'net.netfilter.nf_conntrack_generic_timeout': value            => '600' } # this needs tweaking
    sysctl { 'net.netfilter.nf_conntrack_tcp_timeout_established': value    => '432000' } # this needs tweaking
    sysctl { 'net.netfilter.nf_conntrack_tcp_timeout_time_wait': value      => '120' } # this needs tweaking

    file { '/etc/modprobe.d/netfilter.conf':
        ensure => file,
        mode => '0644',
        source => 'puppet:///modules/profile/etc/modprobe.d/netfilter.conf',
    }
  }

  lookup('firewall_allow_list', Array[String], 'unique').each |String $source_ip| {
    firewall { "200 allow all access from ${source_ip}":
      proto  => 'all',
      source => $source_ip,
      action => 'accept',
    }
  }

  lookup('firewall_deny_list', Array[String], 'unique').each |String $source_ip| {
    firewall { "200 deny all access from ${source_ip}":
      proto  => 'all',
      source => $source_ip,
      action => 'drop',
    }
  }
}
