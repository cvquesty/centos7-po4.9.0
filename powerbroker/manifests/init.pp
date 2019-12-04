# Class: powerbroker
# ===========================
#
# Full description of class powerbroker here.
#
# Parameters
# ----------
#
# * `sample parameter`
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
class powerbroker (
) inherits powerbroker::params {

  include ['::powerbroker::uninstaller']
  include ['::powerbroker::config']
  include ['::powerbroker::install']
  include ['::powerbroker::service']

  Class['powerbroker::uninstaller']
  -> Class['powerbroker::config']
  -> Class['powerbroker::install']
  -> Class['powerbroker::service']
}
