require 'spec_helper'

describe 'powerbroker::config' do
  let :facts do
    {
      :concat_basedir => '/foo',
      :operatingsystem => 'RedHat',
      :operatingsystemmajrelease => '6',
      :datacenter => 'lvs',
    }
  end

  context "powerbroker::config class" do
    it do
      is_expected.to contain_class('powerbroker::config')

      is_expected.to contain_file('/x').with(
        :ensure => 'directory',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0755',
      )

      is_expected.to contain_file('/x/pb').with(
        :ensure => 'directory',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0755',
      )

      is_expected.to contain_file('/x/pb/logs').with(
        :ensure => 'directory',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0755',
      )

      is_expected.to contain_file('/x/pb/staging').with(
        :ensure => 'directory',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0755',
      )

      is_expected.to contain_file('/x/pb/pbrun_pbtest.sh').with(
        :ensure => 'present',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0755',
        :source => "puppet:///modules/powerbroker/scripts/pbrun_pbtest.sh",
      )

      is_expected.to contain_file('/etc/pb.settings').with_content(/NOTICE:/).with(
        :ensure  => 'present',
        :owner   => 'root',
        :group   => 'root',
        :mode    => '0600',
      )

      is_expected.to contain_file('/x/pb/staging/sudo_swapper').with(
        :ensure  => 'present',
        :owner   => 'root',
        :group   => 'root',
        :mode    => '0755',
        :source  => 'puppet:///modules/powerbroker/scripts/sudo_swapper',
      )

      is_expected.to contain_file('/etc/pb.key').with(
        :ensure => 'present',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0600',
        :source => "puppet:///modules/powerbroker/keys/pb.keylvs",
      )
    end
  end
end
