## Testing

Ensure Go and Terraform are installed.

### Unit Testing

Run the native terraform tests. They use a mocked provider, so they need no Azure credentials and create nothing:

`make test-unit`

Run a single file

`make test-unit file=ignore_auth_settings_v2.tftest.hcl`

### Individual Module Testing

Test specific examples from the `examples/` directory:

Test a single example

`make test example=default`

Test multiple examples

`make test example=default,nsg-rules,peering`

Test with local source (uses current repo code instead of registry)

`make test example=default local=true`

Skip terraform destroy after apply

`make test example=default skip-destroy=true`

Combine flags

`make test example=default local=true skip-destroy=true`

### Bulk Testing

Run tests on all discovered examples:

All examples in parallel (registry source)

`make test-parallel`

All examples sequentially (registry source)

`make test-sequential`

All examples in parallel with local source conversion

`make test-local`

### Filtering Examples

Exclude specific examples from bulk testing

`make test-parallel exception=routes,service-endpoints`

`make test-sequential exception=default`

`make test-local exception=peering,routes`

### Available Flags

Test specific examples (comma-separated)

`example=name1,name2`

Convert registry module sources to local paths

`local=true`

Skip terraform destroy after apply

`skip-destroy=true`

Exclude examples from bulk testing (comma-separated)

`exception=name1,name2`

These tests ensure the module's reliability across different configurations and deployment scenarios.
