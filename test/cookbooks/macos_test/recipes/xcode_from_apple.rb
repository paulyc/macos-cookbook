if mac_os_x_after_sierra?
  xcode '10.1'

elsif mac_os_x_sierra?
  xcode '9.2' do
    ios_simulators %w(11 10)
  end
end
