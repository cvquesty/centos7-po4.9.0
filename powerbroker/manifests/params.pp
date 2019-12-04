# == Class powerbroker::params
#
# This class is meant to be called from powerbroker.
# It sets variables according to platform.
#
class powerbroker::params {

  # Global Parameters
  $staging = [
    '/x',
    '/x/pb',
    '/x/pb/logs',
    '/x/pb/staging',
  ]

  $yum_pb_version = '9.4.1-1'
  $apt_pb_version = '9.4.1-1'

}
