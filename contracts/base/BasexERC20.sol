// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title BasexERC20 (Base)
 * @notice Provides a simple and efficient way to deploy your own ERC20 token with custom parameters, saving time and reducing errors.
 * @dev Inherit this contract to quickly deploy an ERC20 token using OpenZeppelin's implementation.
 *      Set name, symbol, and initial supply via constructor. Mints all supply to deployer.
 * 
 * docs: https://isol.thefactlab.org/contracts/base/BasexERC20
 *
 * Arguments:
 * - name (string): Token name
 * - symbol (string): Token symbol
 * - initialSupply (uint256): Initial token supply (Integer number)
 *
 * Example:
 * import "isol/contracts/base/BasexERC20.sol";
 * 
 * contract MyToken is BasexERC20 {
 *     constructor() 
 *         BasexERC20(
 *          "MyToken", 
 *          "MTK", 
 *          1000000
 *         ) 
 *     {}
 * }
 */
abstract contract BasexERC20 is ERC20 {
    constructor(
        string memory name, 
        string memory symbol, 
        uint256 initialSupply
    )
        ERC20(name, symbol)
    {
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }
}
