Facter.add("shorewall_major_version") do
  setcode do
    Facter::Util::Resolution.exec('shorewall version').split('.')[0]    || nil
  end
end
