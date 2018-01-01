include apt

class profile::plexmediaserver {
    #curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -

    apt::source { 'plexmediaserver':
        location => 'https://downloads.plex.tv/repo/deb',
        release  => './public',
        repos    => 'main',
        include => {
            src   => false,
            deb   => true,
        },
    }

    ensure_packages(['plexmediaserver'],
      {
        require => Class['apt::update'],
      }
    )

    firewall { '400 allow plexmediaserver-web access':
        chain  => 'INPUT',
        dport  => 32400,
        proto  => 'tcp',
        action => 'accept',
    }

    firewall { '400 allow plexmediaserver-dlna access (TCP)':
        chain  => 'INPUT',
        dport  => 32469,
        proto  => 'tcp',
        action => 'accept',
    }

    firewall { '400 allow plexmediaserver-dlna access (UDP)':
        chain  => 'INPUT',
        dport  => 1900,
        proto  => 'udp',
        action => 'accept',
    }

    firewall { '400 allow plexmediaserver-theater access':
        chain  => 'INPUT',
        dport  => 3005,
        proto  => 'tcp',
        action => 'accept',
    }

    firewall { '400 allow plexmediaserver-bonjour access':
        chain  => 'INPUT',
        dport  => 5353,
        proto  => 'udp',
        action => 'accept',
    }

    firewall { '400 allow plexmediaserver-roku access':
        chain  => 'INPUT',
        dport  => 8324,
        proto  => 'tcp',
        action => 'accept',
    }

    firewall { '400 allow plexmediaserver-gdm access':
        chain  => 'INPUT',
        dport  => [32410, 32412, 32413, 32414],
        proto  => 'udp',
        action => 'accept',
    }
}
