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
            case facts[:lsbdistcodename]
            when 'jessie'
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
        three_version = {
          'FreeBSD' => '34',
          'Debian' => '3.4',
          'OpenBSD' => '3.4.3',
          'RedHat' => '3',
        }

        let(:params) {{
          :pip => false,
          :dev => false,
          :virtualenv => false,
          :version => three_version[facts[:osfamily]],
        }}

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class("python::install") }
        case facts[:osfamily]
        when 'FreeBSD'
          it { is_expected.to contain_package('python3')}
        else
        end

        context 'with dev' do
          let(:params) {{
            :pip => false,
            :dev => true,
            :virtualenv => false,
            :version => three_version[facts[:osfamily]],
          }}
          case facts[:osfamily]
          when 'RedHat'
            it { is_expected.to contain_package('python3-devel') }
          when 'Debian'
            it { is_expected.to contain_package('python3.4-dev') }
          else
          end
        end

        context 'with pip' do
          let(:params) {{
            :pip => true,
            :dev => false,
            :virtualenv => false,
            :version => three_version[facts[:osfamily]],
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

        context 'with virtualenv' do
          let(:params) {{
            :pip => false,
            :dev => false,
            :virtualenv => true,
            :version => three_version[facts[:osfamily]],
          }}

          case facts[:kernel]
          when 'Linux'
            case facts[:lsbdistcodename]
            when 'jessie'
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
