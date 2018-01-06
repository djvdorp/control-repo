include apt

class profile::nginx {
    $distro = downcase($::operatingsystem)

    apt::source { 'nginx-mainline':
        location    => "https://nginx.org/packages/mainline/${distro}",
        key         => {
            id        => '573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62',
            server    => 'hkp://keyserver.ubuntu.com:80',
        },
        repos       => 'nginx',
        release     => "${::os['distro']['codename']}",
    }

    ensure_packages(['nginx'],
      {
        require => Class['apt::update'],
      }
    )

    service { 'nginx':
        ensure  => 'running',
        enable  => true,
        require => Package['nginx'],
    }

    firewall { '400 allow HTTP and HTTPS access':
        chain  => 'INPUT',
        proto  => 'tcp',
        dport  => [80, 443],
        action => 'accept',
    }

    file { '/etc/nginx/nginx.conf':
        ensure => file,
        mode => '0644',
        source => 'puppet:///modules/profile/etc/nginx/nginx.conf',
        require => Package['nginx'],
        notify  => Service['nginx'],
    }

    file { '/etc/nginx/sites-available':
        ensure => 'directory',
        require => Package['nginx'],
    }

    file { '/etc/nginx/sites-enabled':
        ensure => 'directory',
        require => Package['nginx'],
    }

    lookup('profile::nginx::sites-available', Array[String], 'unique').each |String $name| {
        file { "/etc/nginx/sites-available/${name}":
            ensure => file,
            mode => '0644',
            source => "puppet:///modules/profile/etc/nginx/sites-available/${name}",
            require => Package['nginx'],
        }
    }

    lookup('profile::nginx::sites-enabled', Array[String], 'unique').each |String $name| {
        file { "/etc/nginx/sites-enabled/${name}":
            ensure => 'link',
            target => "/etc/nginx/sites-available/${name}",
            require => File["/etc/nginx/sites-available/${name}"],
            notify  => Service['nginx'],
        }
    }
}
