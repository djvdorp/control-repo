# Default firewall rules which come before all others
# The rules in pre should allow basic networking (such as ICMP and TCP) and ensure that existing connections are not closed.
class profile::firewall_pre {
  Firewall {
    require => undef,
  }

  firewall { '000 allow all local in':
    chain   => 'INPUT',
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }

  firewall { '000 allow all local out':
    chain    => 'OUTPUT',
    proto    => 'all',
    outiface => 'lo',
    action   => 'accept',
  }

  firewall { '000 allow RELATED,ESTABLISHED in':
    chain  => 'INPUT',
    proto  => 'all',
    state  => ['RELATED', 'ESTABLISHED'],
    action => 'accept',
  }

  firewall { '000 allow RELATED,ESTABLISHED out':
    chain  => 'OUTPUT',
    proto  => 'all',
    state  => ['RELATED', 'ESTABLISHED'],
    action => 'accept',
  }

  firewall { '100 allow DNS out (UDP)':
    chain  => 'OUTPUT',
    state  => ['NEW'],
    dport  => '53',
    proto  => 'udp',
    action => 'accept',
  }

  firewall { '100 allow DNS out (TCP)':
    chain  => 'OUTPUT',
    state  => ['NEW'],
    dport  => '53',
    proto  => 'tcp',
    action => 'accept',
  }

  firewall { '100 allow ICMP out':
    chain  => 'OUTPUT',
    proto  => 'icmp',
    action => 'accept',
  }

  firewall { '100 allow ICMP in':
    chain  => 'INPUT',
    proto  => 'icmp',
    action => 'accept',
  }
}
