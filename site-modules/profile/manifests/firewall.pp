# Common firewall rules
class profile::firewall {
  ensure_packages(['iptables','iptables-persistent'])

  firewall { '300 allow all TCP/UDP traffic out':
    chain  => 'OUTPUT',
    proto  => 'all',
    action => 'accept',
  }
}
