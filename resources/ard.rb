resource_name :remote_management
default_action %i(activate configure)

BASE_COMMAND = '/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart'.freeze

property :install_package, String
property :uninstall_options, Array, default: ['-files', '-settings', '-prefs']
property :restart_options, Array, default: ['-agent', '-console', '-menu']

property :users, Array
property :privs, Array, default: ['-all']
property :access, String, default: '-on'
property :allow_access_for, String, default: '-allUsers'
property :computerinfo, Array
property :clientopts, Array

action :activate do
  execute BASE_COMMAND do
    command "#{BASE_COMMAND} -activate"
    not_if { RemoteManagement.activated? }
  end
end

action :configure do
  configure_options = []
  if new_resource.users
    configure_options.insert(0, "-users #{new_resource.users.join(',')}")
  end
  if new_resource.privs
    configure_options.insert(0, "-privs #{new_resource.privs.join(' ')}")
  end
  if new_resource.access
    configure_options.insert(0, "-access #{new_resource.access}")
  end
  if new_resource.allow_access_for
    configure_options.insert(0, "-allowAccessFor #{new_resource.allow_access_for}")
  end
  if new_resource.computerinfo
    configure_options.insert(0, "-computerinfo #{new_resource.computerinfo.join(' ')}")
  end
  if new_resource.clientopts
    configure_options.insert(0, "-clientopts #{new_resource.clientopts.join(' ')}")
  end
  execute BASE_COMMAND do
    command "#{BASE_COMMAND} -configure #{configure_options.join(' ')}"
    not_if { RemoteManagement.configured?(configure_options) }
  end
end
