# frozen_string_literal: true

require 'spec_helper'

describe 'portainer' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      it { is_expected.to compile }
    end
  end

  context "with default parameters" do
      it { is_expected.to compile }
      it { is_expected.to contain_file('portainer.service').with({
          'path' => '/etc/systemd/system/portainer.service'}) }
      it { is_expected.to contain_file('portainer.service')
          .with_content(/^Description=Portainer CE$/) }
      it {
        is_expected.to contain_file('data_path').with({
          'ensure' => 'directory',
          'path' => '/var/lib/portainer',
        })
      }
  end

  context "with custom parameters" do
    let(:params) {{
      'systemd_unit_path' => '/foo/bar/system',
      'data_path'         => '/qux/corge/portainer',
      'pki_mount_path'    => '/sparkle/pki',
    }}
    it { is_expected.to compile }
    it { is_expected.to contain_file('portainer.service').with({
        'path' => '/foo/bar/system/portainer.service'}) }
    it {
      is_expected.to contain_file('data_path').with({
        'ensure' => 'directory',
        'path' => '/qux/corge/portainer',
      })
    }
  end

end
