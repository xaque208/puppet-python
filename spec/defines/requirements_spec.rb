require 'spec_helper'

describe 'python::requirements', type: :define do
  let(:title) { '/requirements.txt' }

  context 'on Debian OS' do
    let :facts do
      {
        id: 'root',
        kernel: 'Linux',
        lsbdistcodename: 'squeeze',
        osfamily: 'Debian',
        operatingsystem: 'Debian',
        operatingsystemrelease: '6',
        path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        concat_basedir: '/dne'
      }
    end

    describe 'requirements as' do
      context '/requirements.txt' do
        let(:params) { { requirements: '/requirements.txt' } }

        it { is_expected.to contain_file('/requirements.txt').with_mode('0644') }
      end

      describe 'with owner' do
        context 'bob:bob' do
          let(:params) do
            {
              owner: 'bob',
              group: 'bob'
            }
          end

          it do
            expect do
              is_expected.to compile
            end.to raise_error(%r{root user must be used when virtualenv is system})
          end
        end
      end

      describe 'with owner' do
        context 'default' do
          it { is_expected.to contain_file('/requirements.txt').with_owner('root').with_group('0') }
        end
      end
    end
  end
end
