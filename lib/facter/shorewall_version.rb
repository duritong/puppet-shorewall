Facter.add("shorewall_major_version") do
  setcode do
    shorewall_version = Facter::Util::Resolution.exec('shorewall version')
    if shorewall_version != nil
        shorewall_major_version = shorewall_version.split('.').first
    else
      shorewall_major_version = '-1'
    end
  end
end
