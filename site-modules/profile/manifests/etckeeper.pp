# Etckeeper profile for all servers
# From Puppet’s perspective, a profile is just a normal class stored in the profile module
class profile::etckeeper {
  class { '::etckeeper':
    vcs => 'git',
#    push_remotes => ['origin'],
  }
}
