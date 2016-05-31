# This function contains the python package name determination logic.
#
function python::virtualenv_name() {
  case $facts['kernel'] {
    'Linux': {
      if $facts['operatingisystem'] == 'Debian' {
        if $::python::version =~ /^3/ {
          $virtualenv_name = 'python3-virtualenv'
        } else {
          $virtualenv_name = 'python-virtualenv'
        }
      } elsif $facts['osfamily'] == 'RedHat' {
        if $::python::version =~ /^3/ {
          # Use the pip name when on python3
          $virtualenv_name = 'virtualenv'
        } else {
          $virtualenv_name = 'python-virtualenv'
        }
      } else {
        if $::python::version =~ /^3/ {
          $virtualenv_name = 'python3-virtualenv'
        } else {
          $virtualenv_name = 'python-virtualenv'
        }
      }
    }
    'FreeBSD': {
      if $::python::version =~ /^3/ {
        $virtualenv_name = 'virtualenv'
      } else {
        $virtualenv_name = 'py27-virtualenv'
      }
    }
  }
}
