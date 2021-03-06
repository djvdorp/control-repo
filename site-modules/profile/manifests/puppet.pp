# Set up Puppet config and cron run
class profile::puppet (
    Boolean $autorun_puppet = true,
) {
  if $autorun_puppet {
      service { ['puppet', 'mcollective', 'pxp-agent']:
        ensure => stopped, # Puppet runs from cron
        enable => false,
      }

      cron { 'run-puppet':
        ensure  => present,
        command => '/usr/local/bin/run-puppet',
        minute  => '*/10',
        hour    => '*',
      }

      file { '/usr/local/bin/run-puppet':
        source => 'puppet:///modules/profile/puppet/run-puppet.sh',
        mode   => '0755',
      }

      file { '/usr/local/bin/papply':
        source => 'puppet:///modules/profile/puppet/papply.sh',
        mode   => '0755',
      }

      file { '/tmp/puppet.lastrun':
        content => strftime('%F %T'),
        backup  => false,
      }
  }
}
