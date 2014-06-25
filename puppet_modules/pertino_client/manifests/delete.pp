# == Class: pertino_client::delete
#
# Uninstall pertino client
#
# === Parameters
#
# === Examples
#
#  class { pertino_client::delete: }
#

class pertino_client::delete {

  #TODO: remove device from network
  service { 'pgateway':
    ensure => stopped,
    enable => false,
  }

  package { 'pertino-client':
    ensure => absent,
    notify => [ Service['pgateway'] ],
  }
}
