# == Class: pertino_client
#
# Install and configure Pertino Client
#
# === Parameters
#
# [*username*]
#   Pertino.com username
#
# [*password*]
#   Pertino.com password
#
# === Examples
#
#  class { pertino_client:
#    username => 'joe@example.com',
#    password => 'SuperSecretPassword',
#     network => 'network_name',  # OPTIONAL: specify network name
#                                 # if multiple networks are available.
#  }
#
class pertino_client (
  $username,
  $password,
  $network = 'UNSET',
) {

    $_network = $network ? {
      ''      => 'UNSET',
      undef   => 'UNSET',
      default => $network,
    }

    $_change_network = $_network ? {
      'UNSET' => '/bin/true',
      default => "/opt/pertino/pgateway/pertino --select-network=${_network}",
    }

    require pertino_client::dependencies
    Exec {
      path => '/usr/bin:/usr/sbin:/bin:/sbin',
    }

    # install package
    package { 'pertino-client':
      ensure => latest,
      notify => Exec['auth-pertino'],
    }

    # authorize
    exec { 'auth-pertino':
      command     => "/opt/pertino/pgateway/.pauth \
        -u '${username}' -p '${password}'",
      cwd         => '/opt/pertino/pgateway',
      refreshonly => true,
      require     => Package['pertino-client'],
      notify      => Exec['start-pertino'],
    }

    exec { 'start-pertino':
      command     => '/etc/init.d/pgateway start',
      refreshonly => true,
      notify      => Exec['status-pertino'],
    }

    exec { 'status-pertino':
      command     => $_change_network,
      refreshonly => true,
    }

    case $::operatingsystem {
      'debian', 'ubuntu': {
        file { '/etc/init.d/pgateway':
          source  => 'puppet:///modules/pertino_client/pgateway',
          mode    => '0755',
          owner   => root,
          group   => root,
          before  => Service['pgateway'],
          require => Package['pertino-client'],
        }
      }
      default: {
        fail('Platform unsupported by pertino_client, patches are welcome!')
      }
    }

    service { 'pgateway':
      ensure  => running,
      enable  => true,
      require => Package['pertino-client'],
    }
}
