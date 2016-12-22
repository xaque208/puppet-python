# This function contains the python package name determination logic.
#
function python::virtualenv_name() {
  case $facts['kernel'] {
    'Linux': {
      if $facts['operatingisystem'] == 'Debian' {
        if $::python::version =~ /^3/ {
          $virtualenv_package = 'python3-virtualenv'
        } else {
          $virtualenv_package = 'python-virtualenv'
        }
      } elsif $facts['osfamily'] == 'RedHat' {
        if $::python::version =~ /^3/ {
          # Use the pip name when on python3
          $virtualenv_package = 'virtualenv'
        } else {
          $virtualenv_package = 'python-virtualenv'
        }
      } else {
        if $::python::version =~ /^3/ {
          $virtualenv_package = 'python3-virtualenv'
        } else {
          $virtualenv_package = 'python-virtualenv'
        }
      }
    }
    'FreeBSD': {
      if $::python::version == 'system' {
        $virtualenv_package = "py27-virtualenv"
      } elsif $::python::version =~ /^[23].*/ {
        $virtualenv_package = "py${::python::version}-virtualenv"
      } else {
        $virtualenv_package = undef
      }
    }
    'OpenBSD': {
      if $::python::version == 'system' or $::python::version =~ /^[2].*/ {
        $virtualenv_package = "py-virtualenv"
      } elsif $::python::version =~ /^[3].*/ {
        $virtualenv_package = "py3-virtualenv"
      } else {
        $virtualenv_package = undef
      }
    }
  }
}
