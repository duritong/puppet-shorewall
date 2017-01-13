Facter.add("shorewall_major_version") do
  setcode do
    Facter::Util::Resolution.exec('shorewall version').split('.').first || nil
  end
end
