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
        'ffmpeg'
    ])

    file { '/usr/local/bin/get_iplayer':
        ensure  => file,
        mode    => '0755',
        source  => 'https://raw.github.com/get-iplayer/get_iplayer/master/get_iplayer',
    }
}
