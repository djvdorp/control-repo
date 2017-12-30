class profile::mashpodder {
    file { '/home/daniel/mashpodder/':
        ensure  => directory,
        owner   => 'daniel',
        group   => 'daniel',
    }

    vcsrepo { '/home/daniel/mashpodder/':
        ensure   => present,
        provider => 'git',
        source   => 'https://github.com/chessgriffin/mashpodder.git',
        user     => 'daniel',
        group    => 'daniel',
        revision => 'master',
        require  => [ Package['git'], File['/home/daniel/mashpodder/'] ],
    }

    cron { 'mashpodder':
        user    => 'daniel',
        ensure  => present,
        command => '/home/daniel/mashpodder/mashpodder.sh 2>&1>>/home/daniel/logs/mashpodder.log',
        minute  => '0',
        hour    => '*',
        require => File['/home/daniel/mashpodder/'],
    }
}
