class profile::librenms (
    String $root_password,
    String $librenms_user_password_hash,
    String $time_zone,
    String $server_name,
    String $snmp_community,
    Array[String] $librenms_packages,
) {
    include ::apt

    ensure_packages($librenms_packages,
      {
        require         => Class['::apt::update'],
      }
    )

    class { 'timezone':
      timezone => $time_zone,
    }

    service { 'php7.0-fpm':
        ensure  => 'running',
        enable  => true,
        require => Package['php7.0-fpm'],
    }

    service { 'nginx':
        ensure  => 'running',
        enable  => true,
        require => Package['nginx-full'],
    }

    service { 'snmpd':
        ensure  => 'running',
        enable  => true,
        require => Package['snmpd'],
    }

    user { 'librenms':
        home        => '/opt/librenms',
        managehome  => false,
        system      => true,
        groups      => ['www-data'], # The primary group should not be listed
    }

    file { '/opt/librenms':
        ensure  => directory,
        owner   => 'librenms',
        group   => 'librenms',
    }

    vcsrepo { '/opt/librenms':
        ensure   => present,
        provider => 'git',
        source   => 'https://github.com/librenms/librenms.git',
        user     => 'librenms',
        group    => 'librenms',
        revision => 'master',
        require  => [ Package['git'], File['/opt/librenms'] ],
    }

    class { '::mysql::server':
        service_name            => 'mysql',
        config_file             => '/etc/mysql/my.cnf',
        includedir              => '/etc/mysql/conf.d/',
        root_password           => $root_password,
        restart                 => true,
        remove_default_accounts => true,
        override_options => {
            mysqld => {
                'log-error'                 => '/var/log/mysql/error.log',
                'pid-file'                  => '/var/run/mysqld/mysqld.pid',
                'innodb_file_per_table'     => 1,
                'sql-mode'                  => 'NO_ENGINE_SUBSTITUTION', # '' is not accepted here
                'lower_case_table_names'    => 0,
            },
            mysqld_safe => {
                'log-error' => '/var/log/mysql/error.log',
            },
        }
    }

    mysql_database { 'librenms':
        ensure  => 'present',
        charset => 'utf8',
        collate => 'utf8_unicode_ci',
    }

    mysql_user { 'librenms@localhost':
        ensure          => 'present',
        password_hash   => $librenms_user_password_hash,
    }

    mysql_grant { 'librenms@localhost/librenms.*':
        ensure     => 'present',
        privileges => 'ALL', # maybe restrict privileges
        table      => 'librenms.*',
        user       => 'librenms@localhost',
    }

    file { '/etc/php/7.0/fpm/php.ini':
      ensure  => present,
      mode    => '0644',
      content => epp('profile/etc/php/7.0/fpm/php.ini.epp', {
        'timezone'        => $time_zone,
      }),
      require => Package['php7.0-fpm'],
      notify  => Service['php7.0-fpm'],
    }

    file { '/etc/php/7.0/cli/php.ini':
      ensure  => present,
      mode    => '0644',
      content => epp('profile/etc/php/7.0/cli/php.ini.epp', {
        'timezone'        => $time_zone,
      }),
      require => Package['php7.0-cli'],
    }

    file { '/etc/nginx/sites-enabled/default':
      ensure  => absent,
      require => Package['nginx-full'],
      notify  => Service['nginx'],
    }

    file { '/etc/nginx/conf.d/librenms.conf':
      ensure  => present,
      mode    => '0644',
      content => epp('profile/etc/nginx/conf.d/librenms.conf.epp', {
        'server_name'   => $server_name,
      }),
      require => Package['nginx-full'],
      notify  => Service['nginx'],
    }

    file { '/etc/snmp/snmpd.conf':
      ensure  => present,
      mode    => '0600',
      content => epp('profile/etc/snmp/snmpd.conf.epp', {
        'snmp_community'    => $snmp_community,
      }),
      require => Package['snmpd'],
      notify  => Service['snmpd'],
    }

    file { '/usr/bin/distro':
      ensure  => present,
      mode    => '0755',
      source  => 'puppet:///modules/profile/usr/bin/distro',
      require => Package['snmpd'],
      notify  => Service['snmpd'],
    }

    file { '/etc/cron.d/librenms':
      ensure  => present,
      mode    => '0644',
      source  => 'puppet:///modules/profile/etc/cron.d/librenms',
      require => Package['cron'],
    }

    file { '/etc/logrotate.d/librenms':
      ensure  => present,
      mode    => '0644',
      source  => 'puppet:///modules/profile/etc/logrotate.d/librenms',
      require => Package['logrotate'],
    }

    file { '/opt/librenms/rrd':
      ensure  => directory,
      owner   => 'librenms',
      group   => 'librenms',
      mode    => '0775',
      require => Vcsrepo['/opt/librenms'],
    }

    file { '/opt/librenms/logs':
      ensure  => directory,
      owner   => 'librenms',
      group   => 'librenms',
      mode    => '0775',
      require => Vcsrepo['/opt/librenms'],
    }
}
