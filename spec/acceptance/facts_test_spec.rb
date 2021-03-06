require 'spec_helper_acceptance'

describe 'python class' do
  context 'facts' do
    install_python = <<-EOS
      class { 'python' :
        version    => 'system',
        pip        => true,
        virtualenv => true,
      }
      EOS

    fact_notices = <<-EOS
      notify{"pip_version: ${::pip_version}":}
      notify{"system_python_version: ${::system_python_version}":}
      notify{"python_version: ${::python_version}":}
      notify{"virtualenv_version: ${::virtualenv_version}":}
      EOS

    context 'outputs python facts when not installed' do
      apply_manifest(fact_notices, catch_failures: true) do |r|
        it do
          expect(r.stdout).to match(%r{python_version: \S+})
        end

        it do
          expect(r.stdout).to match(%r{pip_version: \S+})
        end

        it do
          expect(r.stdout).to match(%r{virtualenv_version: \S+})
        end

        it do
          expect(r.stdout).to match(%r{system_python_version: \S+})
        end
      end
    end

    it 'sets up python' do
      apply_manifest(install_python, catch_failures: true)
    end

    context 'outputs python facts when installed' do
      apply_manifest(fact_notices, catch_failures: true) do |r|
        it do
          expect(r.stdout).to match(%r{python_version: \S+})
        end

        it do
          expect(r.stdout).to match(%r{pip_version: \S+})
        end

        it do
          expect(r.stdout).to match(%r{virtualenv_version: \S+})
        end

        it do
          expect(r.stdout).to match(%r{system_python_version: \S+})
        end
      end
    end
  end
end
