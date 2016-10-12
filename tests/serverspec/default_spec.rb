require 'spec_helper'

packages = %w[ epel-release ]
repo_name = 'epel'

# choose a package that is not included in the default repos
package_not_in_default_repo = %w[ python-pip ]

packages.each do |p|
  describe package(p) do
    it { should be_installed }
  end
end

describe file("/etc/yum.repos.d/#{ repo_name }.repo") do
  it { should be_file }
  its(:content) { should match(/^\[#{ repo_name }\]\nenabled = 1\ngpgcheck = 1\nmirrorlist = #{ Regexp.escape('http://mirrors.fedoraproject.org/mirrorlist?repo=epel-7&arch=x86_64') }/) }
end

package_not_in_default_repo.each do |p|
  describe command("yum install -y #{p}") do
    its(:stdout) { should match(/Complete!/) }
    its(:stderr) { should_not match(/Error:/) }
    its(:exit_status) { should eq 0 }
  end
end
