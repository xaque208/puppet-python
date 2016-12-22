# This function takes a platform specific version string and returns a hash
# who's keys map to the various commands, package names, etc for parts of the
# isntallation and management of python.  This helps centralize the logic for
# where data comes from, so that we can more easily hack around the various
# oddities and inconsistencies that is the nature of python deployment on a
# variety of platforms.

function python::version_data($version) {
  unless $version in $python::valid_versions or $version == 'system' {
    fail "The python version ${version} is unknown on ${facts['osfamily']}"
  }

  $data = lookup('python::version_data')

  # Virtualenv Data
  $virtualenv_cmd     = $data.dig($version, 'virtualenv_cmd')

  # Here to support the transition from the python::virtual_name(() function to
  # hiera data
  $_virtualenv_package = $data.dig($version, 'virtualenv_package')
  if $_virtualenv_package {
    $virtualenv_package = $_virtualenv_package
  } else {
    $virtualenv_package = python::virtualenv_name()
  }

  $blob = {
    'virtualenv_cmd'     => $virtualenv_cmd,
    'virtualenv_package' => $virtualenv_package,
  }
}
