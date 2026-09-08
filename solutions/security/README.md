# Lab 3 reference

This standalone module accepts subnet IDs; it never looks up or creates the
network. Compare the NSG, standalone rule map and associations. Empty custom
rules retain Azure's built-in NSG defaults; the module is not a zero-trust policy.
The inherited provider is mocked in tests. Use realistic fake IDs in the example.
