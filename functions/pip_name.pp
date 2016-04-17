function python::pip_name() {
  case $::kernel {
    'Linux': {
      if $::python::version == 'system' {
        $pip_name = 'python-pip'
      } elsif $::python::version =~ /^3/ {
        if $facts['osfamily'] == 'RedHat' {
          if $::os['release']['major'] == '7' {
            $pip_name = 'python-pip'
          } else {
            $pip_name = 'python3-pip'
          }
        } else {
          $pip_name = 'python3-pip'
        }
      } else {
        $pip_name = 'python-pip'
      }
    }
    'FreeBSD': {
      if $::python::version == 'system' or $::python::version =~ /^2/ {
        $pip_name = 'py27-pip'
      } else {
        $pip_name = undef
      }
    }
    default: {
      $pip_name = undef
    }
  }
}
