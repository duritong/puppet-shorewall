# See http://shorewall.net/shorewall_extension_scripts.htm
define extension_script($script = '') {
    case $name {
        'init', 'initdone', 'start', 'started', 'stop', 'stopped', 'clear', 'refresh', 'continue', 'maclog': {
            shorewall::managed_file { "${name}": }
            shorewall::entry { "${name}.d/500-${hostname}":
                line => "${script}\n";
            }
        }
        '', default: {
            err("${name}: unknown shorewall extension script")
        }
    }
}
