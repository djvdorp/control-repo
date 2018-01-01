class profile::packtpub {
    ensure_packages([
    #    'virtualenv',
    #    'python-virtualenv',
        'python3-virtualenv',
    ])

    #class { 'python' :
    #    version    => 'system',
    #    pip        => 'present',
    #    dev        => 'absent',
    #    virtualenv => 'present',
    #    gunicorn   => 'absent',
    #}

    file { '/home/daniel/myEbooksFromPackt/':
        ensure  => directory,
        owner   => 'daniel',
        group   => 'daniel',
    }

    file { '/home/daniel/Packt-Publishing-Free-Learning/':
        ensure  => directory,
        owner   => 'daniel',
        group   => 'daniel',
    }

    vcsrepo { '/home/daniel/Packt-Publishing-Free-Learning/':
        ensure   => present,
        provider => 'git',
        source   => 'https://github.com/igbt6/Packt-Publishing-Free-Learning.git',
        user     => 'daniel',
        group    => 'daniel',
        revision => 'master',
        require  => [ Package['git'], File['/home/daniel/Packt-Publishing-Free-Learning/'] ],
    }

    python::virtualenv { '/home/daniel/Packt-Publishing-Free-Learning/venv' :
        ensure       => present,
        version      => 'system',
        systempkgs   => true,
        distribute   => true,
        owner        => 'daniel',
        group        => 'daniel',
        require      => Vcsrepo['/home/daniel/Packt-Publishing-Free-Learning/'],
    }

    python::requirements { '/home/daniel/Packt-Publishing-Free-Learning/requirements.txt' :
        virtualenv => '/home/daniel/Packt-Publishing-Free-Learning/venv',
        owner      => 'daniel',
        group      => 'daniel',
        require    => Vcsrepo['/home/daniel/Packt-Publishing-Free-Learning/'],
    }

    cron { 'packtpub':
        user    => 'daniel',
        ensure  => present,
        command => 'source /home/daniel/Packt-Publishing-Free-Learning/venv/bin/activate; /home/daniel/Packt-Publishing-Free-Learning/venv/bin/python src/packtPublishingFreeEbook.py -gd 2>&1>>/home/daniel/logs/packtpub.log',
        minute  => '0',
        hour    => [9, 21],
        require => Class['python'],
    }
}
