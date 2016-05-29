function python::python_name() {
  $python_name = $::python::version ? {
    'system' => 'python',
    'pypy'   => 'pypy',
    default  => "python${python::version}",
  }
}
