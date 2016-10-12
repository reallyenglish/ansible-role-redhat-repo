require 'spec_helper'

packages = %w[ epel-release ]
repo_name = 'epel'

packages.each do |p|
  describe package(p) do
    it { should be_installed }
  end
end

# installed?
describe command('yum repolist all') do
  its(:stdout) { should match(/^#{ repo_name }/) }
end

# enabled?
describe command('yum repolist enabled') do
  its(:stdout) { should match(/^#{ repo_name }/) }
end

describe file("/etc/yum.repos.d/#{ repo_name }.repo") do
  it { should be_file }
  its(:content) { should match(/^\[#{ repo_name }\]\nenabled = 1\ngpgcheck = 1\nmirrorlist = #{ Regexp.escape('http://mirrors.fedoraproject.org/mirrorlist?repo=epel-7&arch=x86_64') }/) }
end
