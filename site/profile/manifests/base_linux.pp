#
# profile::base_linux
#

class profile::base_linux {

  $root_ssh_key = lookup('base_linux::root_ssh_key')

# careful when configuring ntp to avoid misuse (opening for DDOS)
  class { 'ntp':
    servers  => [ 'ntp.ntnu.no' ],
    restrict => [
      'default kod nomodify notrap nopeer noquery',
      '-6 default kod nomodify notrap nopeer noquery',
    ],
  }
  class { 'timezone':
    timezone => 'Europe/Oslo',
  }

  package { ['htop', 'sysstat', 'vim']:
    ensure => 'latest',
  }

  file { '/root/.vimrc':
    ensure => 'present',
    source => 'puppet:///modules/profile/files/vimrc',
  }

# root@manager should be able to ssh without password to all

  file { '/root/.ssh':
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
    ensure => 'directory',
  }
  ssh_authorized_key { 'root@manager':
    user    => 'root',
    type    => 'ssh-rsa',
    key     => $root_ssh_key,
    require => File['/root/.ssh'],
  }

# on all Ubuntu's with two network interfaces, fix routing

  unless $::fqdn == 'manager.borg.trek' or $::fqdn == 'monitor.borg.trek' {
    package { 'ifupdown':
      ensure => present,
    }
    network::routing_table { 'table-ens4':
      table_id => 100,
      require  => Package['ifupdown'],
    }
    network::rule { 'ens4':
      iprule  => ['from 192.168.190.0/24 lookup table-ens4', ],
      require => Network::Routing_table['table-ens4'],
    }
    network::route { 'ens4':
      ipaddress => [ '0.0.0.0', '192.168.190.0', ],
      netmask   => [ '0.0.0.0', '255.255.255.0', ],
      gateway   => [ '192.168.190.1', false, ],
      table     => [ 'table-ens4', 'table-ens4',],
      require   => Network::Routing_table['table-ens4'],
    }
  }

  package { 'binclock':
    ensure => present,
  }

}
