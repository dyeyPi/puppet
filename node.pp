node default {
}

node 'server.domain.net' {
  include accounts
  realize (Accounts::Virtual['johndoe'])
  realize (Accounts::Dependencies['latest'])
  realize (Accounts::Scripts['scripts'])
  realize (Accounts::Srccron['src'])
}
