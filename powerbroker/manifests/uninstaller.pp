# Uninstaller for legacy Powerbroker Install
#
class powerbroker::uninstaller {

  case $::operatingsystem {
    'RedHat', 'CentOS', 'OracleLinux': {
      # Exec a removal of the packages if the pp-powerbroker-cfg package exists
      exec { 'legacy_uninstall':
        path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        onlyif  => 'rpm -qa |grep pp-powerbroker-cfg',
        command => 'rpm -e pp-powerbroker-sudo-wrapper pp-powerbroker-bin pp-powerbroker-cfg',
      }
    }
    default: { notice( 'This platform has no tasks.') }
  }

}
