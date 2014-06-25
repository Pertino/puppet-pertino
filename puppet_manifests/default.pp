node default {
  class { 'pertino_client':
    username => 'email@example.com',
    password => 'secretPW',
  }
}
