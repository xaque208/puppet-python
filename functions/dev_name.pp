function python::dev_name() {
  case $facts['osfamily'] {
    'RedHat': {
      $dev_name = "${::python::install::python}-devel"
    }
    'Debian': {
      $dev_name = "${::python::install::python}-dev"
    }
    default: {
      $dev_name = undef
    }
  }
}
