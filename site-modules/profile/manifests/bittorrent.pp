class profile::bittorrent {
    ensure_packages([
        'transmission-daemon',
        'transmission-cli',
    ])

    file { '/home/daniel/BitTorrent/':
        ensure  => directory,
        owner   => 'daniel',
        group   => 'daniel',
        mode    => '0777',
    }

    firewall { '400 allow transmission-web access':
        chain  => 'INPUT',
        dport  => 9091,
        proto  => 'tcp',
        action => 'accept',
    }

    firewall { '400 allow transmission-daemon access (TCP)':
        chain  => 'INPUT',
        dport  => 51413,
        proto  => 'tcp',
        action => 'accept',
    }

    firewall { '400 allow transmission-daemon access (UDP)':
        chain  => 'INPUT',
        dport  => 51413,
        proto  => 'udp',
        action => 'accept',
    }
}
