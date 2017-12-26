# Logwatch profile for all servers
# From Puppet’s perspective, a profile is just a normal class stored in the profile module
class profile::logwatch (
    Array[String] $email_addresses = ['root'],
    String $detail = 'med',
) {
  ensure_packages(['logwatch'])

  file { '/etc/cron.daily/00logwatch':
    ensure  => present,
    mode    => '0755',
    content => epp('profile/logwatch/00logwatch.epp', {
      'email_addresses' => $email_addresses,
      'detail'          => $detail,
    }),
    require => Package['logwatch'],
  }
}
