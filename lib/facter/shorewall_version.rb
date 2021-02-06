Facter.add('shorewall_version') do
  setcode do
    Facter::Util::Resolution.exec('shorewall version')
  end
end

