require 'spec_helper'

describe Facter::Util::Fact do
  before do
    Facter.clear
  end

  let(:exec) {}

  let(:virtualenv_version_output_old) do
    <<-EOS
12.0.7
EOS
  end

  let(:virtualenv_version_output_new) do
    <<-EOS
20.0.17
EOS
  end

  describe 'virtualenv_version' do
    context 'returns virtualenv version when an old virtualenv is present' do
      it do
        allow(Facter::Util::Resolution).to receive(:which).with('virtualenv') { true }
        allow(Facter::Util::Resolution).to receive(:exec).with('virtualenv --version 2>&1') { virtualenv_version_output_old }
        Facter.value(:virtualenv_version).should == '12.0.7'
      end
    end

    context 'returns virtualenv version when a new virtualenv is present' do
      it do
        allow(Facter::Util::Resolution).to receive(:which).with('virtualenv') { true }
        allow(Facter::Util::Resolution).to receive(:exec).with('virtualenv --version 2>&1') { virtualenv_version_output_new }
        Facter.value(:virtualenv_version).should == '20.0.17'
      end
    end

    context 'returns nil when virtualenv not present' do
      it do
        expect(Facter::Util::Resolution).to receive(:which).with('virtualenv').and_return(false)
        Facter.value(:virtualenv_version).should.nil?
      end
    end
  end
end
