/// SPDX: License-Identifier: GPL-3.0-only
pragma solidity 0.8.19;

import "../MevEthTest.sol";
import "src/libraries/Auth.sol";
import "../mocks/DepositContract.sol";
import { MevEthShareVault } from "src/MevEthShareVault.sol";
import { IStakingModule } from "../../src/interfaces/IStakingModule.sol";
import "../../src/interfaces/IMevEthShareVault.sol";
import "../../lib/safe-tools/src/SafeTestTools.sol";

//TODO: These tests should be bolstered
contract MevRewardsTest is MevEthTest {
    /**
     * Tests granting rewards when the share vault is a multisig.
     */

    function testGrantRewardsFromMultisig(uint128 amount) public {
        vm.assume(amount > 10_000);
        address mevShare = mevEth.mevEthShareVault();

        vm.deal(address(this), amount);
        mevShare.call{ value: amount }("");

        bytes memory data = abi.encodeWithSelector(ITinyMevEth.grantRewards.selector);

        (uint256 elastic, uint256 base) = mevEth.fraction();
        SafeTestLib.execTransaction(multisigSafeInstance, address(mevEth), amount, data);

        (uint256 elastic2, uint256 base2) = mevEth.fraction();

        assertEq(elastic2, elastic + amount);
    }
}
