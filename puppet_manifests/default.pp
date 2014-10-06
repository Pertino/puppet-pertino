node default {
  class { 'pertino_client':
    username => 'email@example.com',
    password => 'secretPW',
    network  => '', # OPTIONAL: specify network name
                    # if multiple networks are available.
  }
}
