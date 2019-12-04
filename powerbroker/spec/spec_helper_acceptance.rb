require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'

run_puppet_install_helper
install_ca_certs unless ENV['PUPPET_INSTALL_TYPE'] =~ /pe/i

UNSUPPORTED_PLATFORMS = ['Windows', 'AIX']

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    hosts.each do |host|
      if fact('osfamily') == 'RedHat'
        if fact('operatingsystemrelease') =~ /7/
          shell("yum -y install bzip2")
        end
      end
      copy_module_to(host, :source => proj_root, :module_name => 'powerbroker')
      on host, puppet('module install puppetlabs-stdlib'),
        {:acceptable_exit_codes => [0]}
    end
  end

  shared_examples "a idemotent resource" do
    it 'should apply with no errors' do
      apply_manifest(pp, :catch_failures => true)
    end

    it 'should apply a second time without changes' do
      apply_manifest(pp, :catch_changes => true)
    end
  end
end
