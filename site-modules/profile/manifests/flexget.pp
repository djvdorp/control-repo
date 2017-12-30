class profile::flexget {
    ensure_packages([
    #    'virtualenv',
    #    'python-virtualenv',
        'python3-virtualenv',
    ])

    class { 'python' :
        version    => 'system',
        pip        => 'present',
        dev        => 'absent',
        virtualenv => 'present',
        gunicorn   => 'absent',
    }

    python::virtualenv { '/home/daniel/flexget' :
        ensure       => present,
        version      => 'system',
        systempkgs   => true,
        distribute   => true,
        owner        => 'daniel',
        group        => 'daniel',
    }

    python::pip { 'flexget' :
        pkgname       => 'flexget',
        ensure        => 'present',
        virtualenv    => '/home/daniel/flexget',
        owner         => 'daniel',
    }

    python::pip { 'transmissionrpc' :
        pkgname       => 'transmissionrpc',
        ensure        => 'present',
        virtualenv    => '/home/daniel/flexget',
        owner         => 'daniel',
    }

    cron { 'flexget':
        user    => 'daniel',
        ensure  => present,
        command => 'source /home/daniel/flexget/bin/activate; /home/daniel/flexget/bin/flexget --cron --loglevel debug --logfile /home/daniel/logs/flexget.log execute 2>&1>>/home/daniel/logs/flexget.log',
        minute  => '20',
        hour    => '*',
        require => Class['python'],
    }
}
