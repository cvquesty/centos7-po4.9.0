# Manifest to handle daemonn management for all platforms
#
class powerbroker::service {

  case $::operatingsystem {
    'Solaris': {
      # Execute PB script to seliver Splunk input of client volume
      exec { 'check_connectivity_pbmaster':
        require => File['/x/pb/pbrun_pbtest.sh'],
        command => "/x/pb/pbrun_pbtest.sh ${::ipaddress} >/dev/null 2>&1 &",
      }

      # Run the sudo swapper to ensure the old sudo binary is moved out of the way
      exec { 'swapit':
        require => File['/x/pb/staging/sudo_swapper'],
        command => '/x/pb/staging/sudo_swapper',
        path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
      }

      ### For Solaris, process management is very different.  Manage each individually here ###

      # Ensure Service is running
      exec { 'pb-pblocald-sol':
        path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        command => '/etc/init.d/sypbcfg_svcsinetdsmf start',
        require => File[
          '/etc/pb.cfg',
          '/etc/.sypbcfg_svcsinetdsmf',
          '/etc/init.d/sypbcfg_svcsinetdsmf',
        ],
      }
    }
    'RedHat': {
      # Non-Solaris Daemon
      service { 'pblocald':
        ensure  => 'running',
        require => File['/etc/pb.settings'],
      }

      # Run the sudo swapper to ensure the old sudo binary is moved out of the way
      exec { 'swapit':
        command => '/x/pb/staging/sudo_swapper',
        path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        require => File['/x/pb/staging/sudo_swapper'],
      }
    }
    default: {
      notice( 'Could not determine Operating System.  Exiting...')
    }
  }
}
