Facter.add("shorewall_major_version") do
  setcode do
    ver = Facter::Util::Resolution.exec('shorewall version')
    (ver.nil?) ? nil : ver.split('.').first
  end
end
