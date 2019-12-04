require 'spec_helper'

describe 'powerbroker' do
  let :facts  do
    {
      :concat_basedir => '/foo',
      :operatingsystem => 'RedHat',
      :operatingsystemmajrelease => '6',
      :datacenter => 'lvs',
    }
  end

  context "powerbroker class without any parameters" do
    it { is_expected.to contain_class('powerbroker::uninstaller') }
    it { is_expected.to contain_class('powerbroker::params') }
    it { is_expected.to contain_class('powerbroker::config') }
    it { is_expected.to contain_class('powerbroker::install') }
    it { is_expected.to contain_class('powerbroker::service') }
  end
end
