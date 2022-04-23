include apt

class profile::get_iplayer {
    apt::ppa { 'ppa:m-grant-prg/utils': }

    ensure_packages(
        [
            'wget',
            'curl',
            'libwww-perl',
            'liblwp-protocol-https-perl',
            'libmojolicious-perl',
            'libxml-libxml-perl',
            'libcgi-pm-perl',
            'atomicparsley',
            'ffmpeg',
            'get-iplayer',
        ],
        {
            require         => Class['apt::update'],
        }
    )

    file { '/home/daniel/bbcrips/':
        ensure  => directory,
        owner   => 'daniel',
        group   => 'daniel',
    }

    file { '/home/daniel/logs/':
        ensure  => directory,
        owner   => 'daniel',
        group   => 'daniel',
    }

    cron { 'get_iplayer':
        user    => 'daniel',
        ensure  => present,
        command => '/usr/bin/get_iplayer --pvr --quiet >> /home/daniel/logs/get_iplayer.log 2>&1',
        minute  => '0',
        hour    => '7',
        require => [ Package['get-iplayer'], File['/home/daniel/bbcrips/'], File['/home/daniel/logs/'] ],
    }

    cron { 'cleanup_bbcrips':
        user    => 'daniel',
        ensure  => present,
        command => 'cd /home/daniel/bbcrips/; rm Asian_Networks_Mixtape_Series_with_Bobby_Friction_-_*',
        minute  => '0',
        hour    => '8',
        require => File['/home/daniel/bbcrips/'],
    }
}
