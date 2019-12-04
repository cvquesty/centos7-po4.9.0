require 'spec_helper'

describe 'powerbroker::service' do
  let :facts  do
    {
      :concat_basedir => '/foo',
      :operatingsystem => 'RedHat',
      :operatingsystemmajrelease => '6',
      :datacenter => 'lvs',
    }
  end

  context "powerbroker::service class without any parameters" do
    it { is_expected.to contain_class('powerbroker::service') }
    it { is_expected.to contain_service('pblocald').with(
      :ensure => 'running',
    ) }
  end
end
