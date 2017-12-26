# Be the base server
# The only thing roles should do is declare profile classes with include
class role::base {
  include profile::puppet
  include profile::etckeeper
  include profile::common
  include profile::users
  include profile::sudoers
  include profile::ssh
  include profile::ntp
  include profile::unattended
  include profile::apticron
  include profile::logwatch
}
