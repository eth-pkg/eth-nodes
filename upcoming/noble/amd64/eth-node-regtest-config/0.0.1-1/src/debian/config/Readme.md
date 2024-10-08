### About Configurations

The genesis validators include the initial validators used to start the testnet.

**Warning: Please do not use these validator keys for any network other than the genesis testnet. Using them elsewhere will result in the loss of your staked ETH.**

Currently, you cannot use the `additional_validators` (additional_validators.txt) because it is not compatible with `eth2-val-tools`. 

To generate keys for validators, you can follow these steps:

```bash
mkdir validators
# Run the staking-deposit-cli
deposit existing-mnemonic --num_validators 200 --chain mainnet --validator_start_index 0 
# Choose English as the language
# Repeat the index: 0
# Enter the mnemonic (refer to values.env for details)
# Type the password: test test
# Confirm your password
```