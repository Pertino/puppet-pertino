Pertino client module
=

Pertino client install and configuration Puppet module

To use it: edit puppet_manifests/default.pp with your Pertino credentials.
e.g.:

    class { 'pertino_client':
      username => 'joe@example.com',    # REQUIRED
      password => 'SuperscretPassword', # REQUIRED
       network => 'your_network',       # OPTIONAL: may leave blank or omit.
    } 

To remove the Pertino client, use:

    class { 'pertino_client::delete': }

Author
---

Pertino DevOps <puppet-pertino@pertino.com>

Copyright
---

Pertino 2014

License
---

Apache 2.0


