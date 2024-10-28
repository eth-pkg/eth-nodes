### About Configurations

The genesis validators include the initial validators used to start the testnet.

**Warning: Please do not use these validator keys for any network other than the genesis testnet. Using them elsewhere will result in the loss of your staked ETH.**

Currently, you cannot use the `additional_validators` (additional_validators.txt) because it is not compatible with `eth2-val-tools`. 

To generate keys for validators, you can follow these steps:

```bash
mkdir validators
# See genesis.json for example, not you need to change the validator root to match your testnet
# Run the staking-deposit-cli
deposit existing-mnemonic --chain mainnet --devnet_chain_setting genesis.json
# Choose English as the language
# Repeat the index: 0
# Enter the mnemonic (refer to values.env for details)
# Type the password: test test
# Confirm your password
```