# See http://shorewall.net/shorewall_extension_scripts.htm
define shorewall::extension_script($script = '') {
    case $name {
        'init', 'initdone', 'start', 'started', 'stop', 'stopped', 'clear', 'refresh', 'continue', 'maclog': {
            shorewall::managed_file { "${name}": }
            shorewall::entry { "extension_script-${order}-${name}":
                line => "${script}\n";
            }
        }
        '', default: {
            err("${name}: unknown shorewall extension script")
        }
    }
}
