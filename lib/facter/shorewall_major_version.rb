Facter.add("shorewall_major_version") do
  confine :shorewall_version => /\d/
  setcode do
    Facter.value(:shorewall_version).split('.').first
  end
end
