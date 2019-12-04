require 'spec_helper'

describe 'powerbroker::uninstaller' do
  let :facts  do
    {
      :concat_basedir => '/foo',
      :os => { :family => 'RedHat' },
      :operatingsystemmajrelease => '6',
      :operatingsystem => 'RedHat',
      :datacenter => 'lvs',
      :yum_pb_version => '9.4.1-1',
      :apt_pb_version => '9.4.1-1',
    }
  end

  context "powerbroker::uninstaller class" do

    it do

      is_expected.to contain_class('powerbroker::uninstaller')

      is_expected.to contain_exec('legacy_uninstall').with(
        :path    => '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin',
        :onlyif  => 'rpm -qa |grep pp-powerbroker-cfg',
        :command => 'rpm -e pp-powerbroker-sudo-wrapper pp-powerbroker-bin pp-powerbroker-cfg',
      )
    end

    it do
      should compile
    end
  end
end
