class role::mediaserver {
  include profile::get_iplayer
  include profile::bittorrent
  include profile::flexget
  include profile::mashpodder
  include profile::packtpub
  include profile::plexmediaserver
  include profile::nginx
}
