function python::ensure_virtualenv($ensure) {

  $virtualenv_name = python::virtualenv_name()

  if $virtualenv_name {
    if $facts['osfamily'] == 'FreeBSD' {
      if $ensure == 'present' {
        python::require_pip()
        $pip_name = python::pip_name()

        package { $virtualenv_name:
          ensure   => $ensure,
          provider => 'pip',
          require  => Package[$pip_name],
        }
      }
    } elsif $facts['osfamily'] == 'RedHat' and $::python::version =~ /^3/ {
      if $ensure == 'present' {
        python::require_pip()
        package { $virtualenv_name:
          ensure   => $ensure,
          provider => 'pip3',
          require  => Exec['install_pip3'],
        }
      } else {
        package { $virtualenv_name:
          ensure   => $ensure,
          provider => 'pip3',
        }
      }
    } else {
      package { $virtualenv_name:
        ensure  => $ensure,
        require => Package[$python::install::python_name],
      }
    }
  }
}
