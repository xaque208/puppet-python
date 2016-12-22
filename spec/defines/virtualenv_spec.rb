require 'spec_helper'

describe 'python::virtualenv' do
  let (:title) { '/opt/v' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

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

            when '6.0'
                '3.5.2'

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

        let :pre_condition do
          "
          class {'python':
            version    => '#{three_version}',
            virtualenv => true,
          }
          "
        end

        case facts[:osfamily]
        when 'OpenBSD'
          it {
            short_version = three_version.split('.').take(2).join('.')
            is_expected.to contain_exec('python_virtualenv_/opt/v').with_command(
              #/virtualenv-3\s+-p\spython-#{short_version}\s\/opt\/v/
              /virtualenv-3\s+-p\spython\s\/opt\/v/
            )
          }

        else
          it { is_expected.to contain_python__virtualenv('/opt/v') }
        end

      end


    end
  end

end
