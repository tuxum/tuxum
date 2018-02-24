ExUnit.start()

Mox.defmock(MockIdentities, for: Core.Identities)

Application.put_env(:auth, :identities_module, MockIdentities)
