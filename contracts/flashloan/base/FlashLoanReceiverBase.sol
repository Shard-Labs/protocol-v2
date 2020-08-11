// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.6.8;

import '@openzeppelin/contracts/math/SafeMath.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '../interfaces/IFlashLoanReceiver.sol';
import '../../interfaces/ILendingPoolAddressesProvider.sol';
import '../../libraries/UniversalERC20.sol';
import '@nomiclabs/buidler/console.sol';

abstract contract FlashLoanReceiverBase is IFlashLoanReceiver {
  using UniversalERC20 for IERC20;
  using SafeMath for uint256;

  ILendingPoolAddressesProvider public addressesProvider;

  constructor(ILendingPoolAddressesProvider _provider) public {
    addressesProvider = _provider;
  }

  receive() external payable {}

  function transferFundsBackInternal(
    address _reserve,
    address _destination,
    uint256 _amount
  ) internal {
    transferInternal(payable(_destination), _reserve, _amount);
  }

  function transferInternal(
    address payable _destination,
    address _reserve,
    uint256 _amount
  ) internal {
    IERC20(_reserve).universalTransfer(_destination, _amount);
  }

  function getBalanceInternal(address _target, address _reserve) internal view returns (uint256) {
    if (IERC20(_reserve).isETH()) {
      return _target.balance;
    }

    return IERC20(_reserve).balanceOf(_target);
  }
}