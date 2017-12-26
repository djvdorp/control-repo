# Manage sshd config
class profile::ssh (
    Integer $port = 22,
    Array[String] $listen = ['0.0.0.0', '::'],
) {
  ensure_packages(['openssh-server'])

  service { 'ssh':
    ensure  => 'running',
    enable  => true,
    require => Package['openssh-server'],
  }

  file { '/etc/ssh/sshd_config':
    ensure  => present,
    mode    => '0600',
    content => epp('profile/ssh/sshd_config.epp', {
      'port'        => $port,
      'listen'      => $listen,
      'allow_users' => lookup('allow_users', Array[String], 'unique'),
    }),
    require => Package['openssh-server'],
    notify  => Service['ssh'],
  }

  firewall { '400 allow SSH in':
    chain   => 'INPUT',
    state   => ['NEW'],
    dport   => $port,
    proto   => 'tcp',
    action  => 'accept',
  }
}
