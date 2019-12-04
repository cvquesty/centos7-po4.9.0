# Manifest to install Powerbroker on the appropriate platforms
# [*yum_pb_version*]
# [*apt_pb_version*]
#
class powerbroker::install (

  $yum_pb_version = $::powerbroker::params::yum_pb_version,
  $apt_pb_version = $::powerbroker::params::apt_pb_version,

){

  case $::operatingsystem {
    'RedHat', 'CentOS', 'OracleLinux': {

      package { 'glibc':
        ensure => 'present',
      }

      package { 'pp-powerbroker-bin':
        ensure   => $yum_pb_version,
        provider => 'rpm',
        source   => '/x/pb/pp-powerbroker-bin-9.4.1-1.x86_64.rpm',
        require  => Package['glibc'],
      }
    }
    'Ubuntu': {
      package { 'pp-powerbroker-bin':
        ensure   => $apt_pb_version,
        provider => 'apt',
        source   => '/x/pb/pp-powerbroker-bin_9.4.1-1_amd64.deb',
      }
    }
    'Solaris': {
      package { 'BTPBsbmh':
        ensure    => 'installed',
        source    => '/x/pb/BTPBsbmh.ds',
        adminfile => '/x/pb/BTPBadmin',
        require   => [
          File[ '/x/pb/BTPBsbmh.ds' ],
          File[ '/x/pb/BTPBadmin' ],
        ],
      }

      package { 'BTPBlibs':
        ensure    => 'installed',
        source    => '/x/pb/BTPBlibs.ds',
        adminfile => '/x/pb/BTPBadmin',
        require   => [
          Package[ 'BTPBsbmh' ],
          File[ '/x/pb/BTPBlibs.ds' ],
          File[ '/x/pb/BTPBadmin' ],
        ],
      }

      package { 'BTPBrunh':
        ensure    => 'installed',
        source    => '/x/pb/BTPBrunh.ds',
        adminfile => '/x/pb/BTPBadmin',
        require   => [
          Package[ 'BTPBlibs' ],
          Package[ 'BTPBsbmh' ],
          File[ '/x/pb/BTPBrunh.ds' ],
          File[ '/x/pb/BTPBadmin' ],
        ],
      }
    }
    default: {
      fail ('Unable to determine platform. Exiting.')
    }
  }
}
