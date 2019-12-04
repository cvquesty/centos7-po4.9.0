require 'spec_helper_acceptance'

describe 'powerbroker::config' do
  let(:manifest) {
    <<-EOS
include ::powerbroker::config
EOS
  }

  masters     = hosts_with_role(hosts, 'master')

  hosts.each do |host|

    context 'master' do

      masters.each do |master|
        it do
          on(master, 'mkdir -p /etc/facter/facts.d')
          scp_to(master, 'files/datacenter', '/etc/facter/facts.d')
        end
      end
    end
  end
end
