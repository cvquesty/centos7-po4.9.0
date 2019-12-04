# == Class powerbroker::config
#
# This class is called from powerbroker for service config.
#
# ===Parameters
#
# [*staging*] - The directories needed to stage files for Powerbroker
#
class powerbroker::config (

  $staging = $::powerbroker::params::staging

) inherits powerbroker::params {

  # Set up Directories to hold PB Artifacts
  # /x, /x/pb, /x/pb/logs, /x/pb/staging
  file { $staging:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  # Place test script to ensure connectivity is in place
  file { '/x/pb/pbrun_pbtest.sh':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => 'puppet:///modules/powerbroker/scripts/pbrun_pbtest.sh',
    require => File[ '/x/pb/logs' ],
  }

  # Place Powerbroker config from settings
  file { '/etc/pb.settings':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('powerbroker/pb.settings.erb'),
  }

  # Check for existence of pb_sudo and if it exists, just exit
  # Place Script and then execute it
  file { '/x/pb/staging/sudo_swapper':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    source  => 'puppet:///modules/powerbroker/scripts/sudo_swapper',
    require => File['/x/pb/staging'],
  }

  # All platforms get the pb.key
  file { '/etc/pb.key':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    source  => "puppet:///modules/powerbroker/keys/pb.key${::datacenter}",
  }

  # Solaris Config Staging
  case $::operatingsystem {
    'Solaris': {
      file { '/x/pb/BTPBadmin':
        ensure => 'present',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        source => "puppet:///modules/powerbroker/${::kernel}/BTPBadmin",
      }

      file { '/x/pb/BTPBsbmh.ds':
        ensure => 'present',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        source => "puppet:///modules/powerbroker/${::kernel}/${::kernelrelease}/BTPBsbmh.ds",
      }

      file { '/x/pb/BTPBlibs.ds':
        ensure => 'present',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        source => "puppet:///modules/powerbroker/${::kernel}/${::kernelrelease}/BTPBlibs.ds",
      }

      file { '/x/pb/BTPBrunh.ds':
        ensure => 'present',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        source => "puppet:///modules/powerbroker/${::kernel}/${::kernelrelease}/BTPBrunh.ds",
      }

      file { '/etc/pb.cfg':
        ensure => 'present',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        source => "puppet:///modules/powerbroker/${::kernel}/${::kernelrelease}/pb.cfg",
      }

      file { '/etc/.sypbcfg_svcsinetdsmf':
        ensure  => 'present',
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        content => 'install',
      }

      file { '/etc/init.d/sypbcfg_svcsinetdsmf':
        ensure => 'present',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        source => "puppet:///modules/powerbroker/${::kernel}/stpbcfg_svcsinetdsmf",
      }
    }
    'RedHat', 'CentOS', 'OracleLinux': {
      file { '/x/pb/pp-powerbroker-bin-9.4.1-1.x86_64.rpm':
        ensure => 'present',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        source => 'puppet:///modules/powerbroker/Linux/pp-powerbroker-bin-9.4.1-1.x86_64.rpm',
      }
    }
    'Ubuntu': {
      file { '/x/pb/pp-powerbroker-bin_9.4.1-1_amd64.deb':
        ensure => 'present',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        source => 'puppet:///modules/powerbroker/Linux/pp-powerbroker-bin_9.4.1-1_amd64.deb',
      }
    }
    default: {
      notice( 'Platform not able to be determined. Exiting...' )
    }
  }
}
