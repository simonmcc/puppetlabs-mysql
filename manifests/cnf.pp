# this is based on the great work by the camptocamp guys - thank you!
# https://github.com/camptocamp/puppet-mysql/blob/master/manifests/config.pp
# 
# class renamed to mysql::cnf to avoid name clash & give a better indication
# that we are working with the /etc/my.cnf file
# Also, we don't notify the service, the aim is to dynamically change 
# settings using the dynamic_variable type that's part of this module 
# & keep /etc/my.cnf in sync with dynamically set items using a yet
# to be built mysql::config parent type.

/*

== Definition: mysql::cnf

Set mysql configuration parameters

Parameters:
- *value*: the value to be set, defaults to the empty string;
- *key*: optionally, set the key (defaults to $name);
- *ensure*: defaults to present.

Example usage:
  mysql::cnf {'mysqld/pid-file':
    ensure  => present,
    value   => '/var/run/mysqld/mysqld.pid',
  }

If the section (e.g. 'mysqld/') is ommitted in the resource name,
it defaults to 'mysqld/'.

*/


define mysql::cnf (
  $ensure='present',
  $value='',
  $key=''
) {

  # collect the my.cnf location from the params module
  include mysql::params

  $real_name = $key ? {
    ''      => $name,
    default => $key,
  }

  $real_key = inline_template("<%= real_name.split('/')[-1] %>")

  $section = inline_template("<%= if real_name.split('/')[-2]
      real_name.split('/')[-2]
    else
      'mysqld'
    end %>")

  case $ensure {
    present: {
      $changes = "set ${real_key} ${value}"
    }

    absent: {
      $changes = "rm ${real_key}"
    }

    default: { err ( "unknown ensure value ${ensure}" ) }
  }

  $context   = "/files/$mysql::params::config_file/target[.='$section']"

  augeas { "my.cnf/${section}/${real_key}":
    context   => $context,
    changes   => $changes,
  }
}
