Facter.add("shorewall_major_version") do
  confine :shorewall_version => /\d/
  setcode do
    v = Facter.value('shorewall_version')
    v.nil? ? nil : v.split('.').first
  end
end
