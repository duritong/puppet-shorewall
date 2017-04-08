Facter.add("shorewall_major_version") do
  setcode do
    v = Facter.value('shorewall_version')
    v.nil? ? nil : v.split('.').first
  end
end
