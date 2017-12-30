class profile::get_iplayer {
    ensure_packages([
        'wget',
        'curl',
        'libwww-perl',
        'liblwp-protocol-https-perl',
        'libmojolicious-perl',
        'libxml-libxml-perl',
        'libcgi-pm-perl',
        'atomicparsley',
        'ffmpeg',
    ])

    file { '/usr/local/bin/get_iplayer':
        ensure  => file,
        mode    => '0755',
        source  => 'https://raw.github.com/get-iplayer/get_iplayer/master/get_iplayer',
    }

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
        command => '/usr/local/bin/get_iplayer --type=radio --modes=flashaudio,iphone,flashaac,realaudio --output="/home/daniel/bbcrips/" --pvr 2>&1>>/home/daniel/logs/get-iplayer.log',
        minute  => '40',
        hour    => '*',
        require => [ File['/usr/local/bin/get_iplayer'], File['/home/daniel/bbcrips/'], File['/home/daniel/logs/'] ],
    }

    cron { 'cleanup_bbcrips':
        user    => 'daniel',
        ensure  => present,
        command => 'cd /home/daniel/bbcrips/; rm Bobby_Friction_-*',
        minute  => '58',
        hour    => '*',
        require => File['/home/daniel/bbcrips/'],
    }
}
