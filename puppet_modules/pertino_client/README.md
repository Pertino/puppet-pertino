Pertino client module
=

Pertino client install and configuration module

To use it: edit puppet_manifests/default.pp with your Pertino credentials.

    class { 'pertino_client':
      username     => 'joe@example.com',
      password     => 'SuperscretPassword'
    } 

To remove a meter change your include to:

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


