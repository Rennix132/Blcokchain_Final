Compiling 104 files with Solc 0.8.35
Solc 0.8.35 finished in 1.27s
Compiler run successful with warnings:
Warning (6335): "error" will be promoted to keyword in the future and will not be allowed as an identifier anymore.
   --> lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol:125:29:
    |
125 |         (address recovered, RecoverError error, bytes32 errorArg) = tryRecover(hash, signature);
    |                             ^^^^^^^^^^^^^^^^^^

Warning (6335): "error" will be promoted to keyword in the future and will not be allowed as an identifier anymore.
   --> lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol:134:29:
    |
134 |         (address recovered, RecoverError error, bytes32 errorArg) = tryRecoverCalldata(hash, signature);
    |                             ^^^^^^^^^^^^^^^^^^

Warning (6335): "error" will be promoted to keyword in the future and will not be allowed as an identifier anymore.
   --> lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol:161:29:
    |
161 |         (address recovered, RecoverError error, bytes32 errorArg) = tryRecover(hash, r, vs);
    |                             ^^^^^^^^^^^^^^^^^^

Warning (6335): "error" will be promoted to keyword in the future and will not be allowed as an identifier anymore.
   --> lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol:203:29:
    |
203 |         (address recovered, RecoverError error, bytes32 errorArg) = tryRecover(hash, v, r, s);
    |                             ^^^^^^^^^^^^^^^^^^

Warning (6335): "error" will be promoted to keyword in the future and will not be allowed as an identifier anymore.
   --> lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol:273:26:
    |
273 |     function _throwError(RecoverError error, bytes32 errorArg) private pure {
    |                          ^^^^^^^^^^^^^^^^^^

Warning (6335): "at" will be promoted to keyword in the future and will not be allowed as an identifier anymore.
   --> lib/openzeppelin-contracts/contracts/utils/structs/DoubleEndedQueue.sol:191:5:
    |
191 |     function at(Bytes32Deque storage deque, uint256 index) internal view returns (bytes32) {
    |     ^ (Relevant source part starts here and spans across multiple lines).

Warning (6335): "at" will be promoted to keyword in the future and will not be allowed as an identifier anymore.
   --> lib/openzeppelin-contracts/contracts/utils/structs/Checkpoints.sol:126:5:
    |
126 |     function at(Trace256 storage self, uint32 pos) internal view returns (Checkpoint256 memory) {
    |     ^ (Relevant source part starts here and spans across multiple lines).

Warning (6335): "at" will be promoted to keyword in the future and will not be allowed as an identifier anymore.
   --> lib/openzeppelin-contracts/contracts/utils/structs/Checkpoints.sol:329:5:
    |
329 |     function at(Trace224 storage self, uint32 pos) internal view returns (Checkpoint224 memory) {
    |     ^ (Relevant source part starts here and spans across multiple lines).

Warning (6335): "at" will be promoted to keyword in the future and will not be allowed as an identifier anymore.
   --> lib/openzeppelin-contracts/contracts/utils/structs/Checkpoints.sol:532:5:
    |
532 |     function at(Trace208 storage self, uint32 pos) internal view returns (Checkpoint208 memory) {
    |     ^ (Relevant source part starts here and spans across multiple lines).

Warning (6335): "at" will be promoted to keyword in the future and will not be allowed as an identifier anymore.
   --> lib/openzeppelin-contracts/contracts/utils/structs/Checkpoints.sol:735:5:
    |
735 |     function at(Trace160 storage self, uint32 pos) internal view returns (Checkpoint160 memory) {
    |     ^ (Relevant source part starts here and spans across multiple lines).

Warning (9302): Return value of low-level calls not used.
   --> test/TokensAndVault.t.sol:123:9:
    |
123 |         address(treasury).call(abi.encodeWithSignature("upgradeToAndCall(address,bytes)", address(newImpl), data));
    |         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Analysing contracts...
Running tests...

Ran 1 test for test/DAO.t.sol:DAOTest
[PASS] test_GovernanceLifecycle() (gas: 325778)
Suite result: ok. 1 passed; 0 failed; 0 skipped; finished in 6.39ms (1.33ms CPU time)

Ran 6 tests for test/AMM.t.sol:AMMTest
[PASS] testFuzz_Swap(uint256) (runs: 256, μ: 263410, ~: 263567)
[PASS] test_AddLiquidity() (gas: 204638)
[PASS] test_FactoryGettersAndReverts() (gas: 28412)
[PASS] test_InvariantKNeverDecreases() (gas: 263240)
[PASS] test_RevertIfInsufficientAmount() (gas: 21144)
[PASS] test_RevertIfInvalidPath() (gas: 19108)
Suite result: ok. 6 passed; 0 failed; 0 skipped; finished in 34.88ms (48.38ms CPU time)

Ran 9 tests for test/TokensAndVault.t.sol:TokensAndVaultTest
[PASS] testFuzz_VaultDepositWithdraw(uint256) (runs: 256, μ: 117696, ~: 117824)
[PASS] test_GovTokenMint() (gas: 115467)
[PASS] test_GovTokenMintRevertNotOwner() (gas: 14516)
[PASS] test_GovTokenTransferAndNonces() (gas: 149787)
[PASS] test_OracleLatestPrice() (gas: 14885)
[PASS] test_OracleRevertInvalidPrice() (gas: 19017)
[PASS] test_OracleRevertStalePrice() (gas: 18833)
[PASS] test_TreasuryInitialization() (gas: 20256)
[PASS] test_TreasuryUpgrade() (gas: 971036)
Suite result: ok. 9 passed; 0 failed; 0 skipped; finished in 55.59ms (50.64ms CPU time)

Ran 3 tests for test/YulMath.t.sol:YulMathTest
[PASS] testFuzz_SumEquivalence(uint256[]) (runs: 256, μ: 66839, ~: 68524)
[PASS] test_SumSolidity() (gas: 9609)
[PASS] test_SumYul() (gas: 8987)
Suite result: ok. 3 passed; 0 failed; 0 skipped; finished in 62.93ms (63.02ms CPU time)

Ran 4 test suites in 64.87ms (159.79ms CPU time): 19 tests passed, 0 failed, 0 skipped (19 total tests)

╭---------------------------------+------------------+------------------+----------------+----------------╮
| File                            | % Lines          | % Statements     | % Branches     | % Funcs        |
+=========================================================================================================+
| src/AMMFactory.sol              | 100.00% (12/12)  | 100.00% (11/11)  | 66.67% (4/6)   | 100.00% (2/2)  |
|---------------------------------+------------------+------------------+----------------+----------------|
| src/AMMPair.sol                 | 88.24% (30/34)   | 82.93% (34/41)   | 44.44% (4/9)   | 100.00% (4/4)  |
|---------------------------------+------------------+------------------+----------------+----------------|
| src/DeFiGovernor.sol            | 90.00% (18/20)   | 89.47% (17/19)   | 100.00% (0/0)  | 90.00% (9/10)  |
|---------------------------------+------------------+------------------+----------------+----------------|
| src/GovernanceToken.sol         | 100.00% (6/6)    | 100.00% (4/4)    | 100.00% (0/0)  | 100.00% (3/3)  |
|---------------------------------+------------------+------------------+----------------+----------------|
| src/PriceOracle.sol             | 100.00% (8/8)    | 100.00% (10/10)  | 100.00% (2/2)  | 100.00% (2/2)  |
|---------------------------------+------------------+------------------+----------------+----------------|
| src/TreasuryV1.sol              | 100.00% (8/8)    | 100.00% (4/4)    | 100.00% (0/0)  | 100.00% (4/4)  |
|---------------------------------+------------------+------------------+----------------+----------------|
| src/YulMath.sol                 | 100.00% (11/11)  | 100.00% (14/14)  | 100.00% (0/0)  | 100.00% (2/2)  |
|---------------------------------+------------------+------------------+----------------+----------------|
| test/AMM.t.sol                  | 100.00% (2/2)    | 100.00% (1/1)    | 100.00% (0/0)  | 100.00% (1/1)  |
|---------------------------------+------------------+------------------+----------------+----------------|
| test/DAO.t.sol                  | 100.00% (2/2)    | 100.00% (1/1)    | 100.00% (0/0)  | 100.00% (1/1)  |
|---------------------------------+------------------+------------------+----------------+----------------|
| test/TokensAndVault.t.sol       | 100.00% (4/4)    | 100.00% (2/2)    | 100.00% (0/0)  | 100.00% (2/2)  |
|---------------------------------+------------------+------------------+----------------+----------------|
| test/mocks/MockV3Aggregator.sol | 100.00% (9/9)    | 100.00% (6/6)    | 100.00% (0/0)  | 100.00% (3/3)  |
|---------------------------------+------------------+------------------+----------------+----------------|
| Total                           | 94.83% (110/116) | 92.04% (104/113) | 58.82% (10/17) | 97.06% (33/34) |
╰---------------------------------+------------------+------------------+----------------+----------------╯
