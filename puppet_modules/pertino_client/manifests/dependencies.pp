class pertino_client::dependencies {

  Exec {
    path => '/usr/bin:/usr/sbin:/bin:/sbin',
  }

  case $::operatingsystem {
    'RedHat', 'redhat', 'CentOS', 'centos', 'Amazon', 'Fedora': {

      $rpmkey = '/etc/pki/rpm-gpg/RPM-GPG-KEY-Pertino'

      file { $rpmkey:
        ensure => present,
        source => 'puppet:///modules/pertino_client/Pertino-GPG-Key.pub',
      }

      exec { 'import_key':
        command     => "/bin/rpm --import $rpmkey",
        subscribe   => File[$rpmkey],
        refreshonly => true,
      }

      yumrepo { 'pertino':
        descr    => "Pertino $::operatingsystemrelease $::architecture Repository ",
        enabled  => 1,
        baseurl  => $::operatingsystem ? {
          /(RedHat|redhat|CentOS|centos)/ =>  "http://reposerver.pertino.com/rpms",
          'Fedora'                        =>  "http://reposerver.pertino.com/rpms",
          'Amazon'                        =>  "http://reposerver.pertino.com/rpms",
        },
        gpgcheck => 1,
        gpgkey   => 'http://reposerver.pertino.com/Pertino-GPG-Key.pub',
      }
    }

    'debian', 'ubuntu': {

      package { 'apt-transport-https':
        ensure => latest,
      }

      file { '/etc/apt/sources.list.d/pertino.list':
        ensure  => present,
        content => template('pertino_client/apt_source.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package['apt-transport-https'],
        notify  => Exec['add-pertino-apt-key']
      }

      exec { 'add-pertino-apt-key':
        command     => 'wget -O - http://reposerver.pertino.com/Pertino-GPG-Key.pub | apt-key add -',
        refreshonly => true,
        notify  => Exec['apt-update']
      }

      exec { 'apt-update':
        command     => '/usr/bin/apt-get update',
        refreshonly => true,
      }
    }

    default: {
      fail('Platform not supported by Pertino module. Patches are welcome.')
    }
  }
}
