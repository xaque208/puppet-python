require 'spec_helper'

describe 'python' do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context "with system version" do
        let(:params) {{
          :pip => false,
          :dev => false,
          :virtualenv => false,
          :version => 'system'
        }}

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class("python::install") }

        context 'with dev' do
          let(:params) {{
            :version => 'system',
            :dev => true,
            :pip => false,
            :virtualenv => false,
          }}

          case facts[:osfamily]
          when 'RedHat'
            it { is_expected.to contain_package('python-devel') }
          when 'Debian'
            it { is_expected.to contain_package('python-dev') }
          else
          end
        end

        context 'with pip' do
          let(:params) {{
            :version => 'system',
            :pip => true,
            :dev => false,
            :virtualenv => false,
          }}

          case facts[:kernel]
          when 'Linux'
            it { is_expected.to contain_package('python-pip') }
          when 'FreeBSD'
            it { is_expected.to contain_package('py27-pip') }
          else
            it { is_expected.to_not contain_package('py27-pip') }
            it { is_expected.to_not contain_package('python-pip') }
            it { is_expected.to_not contain_package('python3-pip') }
          end

        end

        context 'with virtualenv' do 
          let(:params) {{
            :version => 'system',
            :virtualenv => true,
            :dev => false,
            :pip => false,
          }}

          case facts[:kernel]
          when 'Linux'
            case facts[:operatingsystemmajrelease]
            when '8'
              it { is_expected.to contain_package('virtualenv') }
            else
              it { is_expected.to contain_package('python-virtualenv') }
            end
          when 'FreeBSD'
            it { is_expected.to contain_package('py27-virtualenv') }
          else
          end
        end

      end

      context "with a python3 version" do

        three_version = case facts[:operatingsystem]
          when 'FreeBSD'
            case facts[:operatingsystemmajrelease]
            when '10'
              '34'

            end
          when 'OpenBSD'
            case facts[:kernelversion]
            when '5.8'
              '3.4.3'

            when '5.9'
                '3.4.4'

            end
          when 'Debian'
            case facts[:operatingsystemmajrelease]
            when '8'
              '3.4'

            end
          when 'CentOS'
            case facts[:operatingsystemmajrelease]
            when '7'
              '3'

            end
          when 'RedHat'
            case facts[:operatingsystemmajrelease]
            when '7'
              '3'

            end
          else nil
        end

        if three_version.nil?
          puts "skipping python3 tests on #{facts[:os]}"
          next
        end

        let(:params) {{
          :pip => false,
          :dev => false,
          :virtualenv => false,
          :version => three_version,
        }}

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class("python::install") }

        case facts[:operatingsystem]
        when 'FreeBSD'
          it { is_expected.to contain_package('python3')}
        when 'Debian'
          it { is_expected.to contain_package('python3.4')}

        end

        context 'when dev enabled is enabled' do
          let(:params) {{
            :pip => false,
            :dev => true,
            :virtualenv => false,
            :version => three_version,
          }}

          case facts[:osfamily]
          when 'RedHat'
            it { is_expected.to contain_package('python3-devel') }
          when 'Debian'
            it { is_expected.to contain_package('python3.4-dev') }
          else
          end
        end

        context 'when pip is enabled' do
          let(:params) {{
            :pip => true,
            :dev => false,
            :virtualenv => false,
            :version => three_version,
          }}

          case facts[:osfamily]
          when 'RedHat'
            case facts[:operatingsystemmajrelease]
            when '7'
              it { is_expected.to contain_package('python-pip') }
            else
              it { is_expected.to contain_package('python3-pip') }
            end
          when 'Debian'
            it { is_expected.to contain_package('python3-pip') }
          when 'FreeBSD'
            it { is_expected.to contain_exec('install_pip34')}
            it { is_expected.to_not contain_package("py27-pip") }
          else
            it { is_expected.to_not contain_package('py27-pip') }
            it { is_expected.to_not contain_package('python-pip') }
          end

        end

        context 'when virtualenv is enabled' do
          let(:params) {{
            :pip => false,
            :dev => false,
            :virtualenv => true,
            :version => three_version,
          }}

          case facts[:operatingsystem]
          when 'Debian'

            case facts[:operatingsystemmajrelease]
            when '8'
              it { is_expected.to contain_package('virtualenv') }
            else
              it { is_expected.to contain_package('python-virtualenv') }

            end
          when 'FreeBSD'
            it { is_expected.to contain_package("virtualenv").with_provider('pip') }

          else
          end
        end

      end

    end
  end

end
