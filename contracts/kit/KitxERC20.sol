// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title KitxERC20 (Kit)
 * @notice Fast ERC20 fundamental with burnable and ownable features for rapid token creation.
 * @dev Inherit to quickly deploy a custom ERC20 token with burn and ownership control.
 *      Set name, symbol, and initial supply via constructor. Mints all supply to deployer.
 * 
 * docs: https://isol.thefactlab.org/contracts/kit/KitxERC20
 *
 * Arguments:
 * - name (string): Token name
 * - symbol (string): Token symbol
 * - initialSupply (uint256): Initial token supply (Integer number)
 *
 * Example:
 * import "isol/contracts/kit/KitxERC20.sol";
 *
 * contract MyToken is KitxERC20 {
 *     constructor() 
 *         KitxERC20(
 *          "MyToken",
 *          "MTK",
 *          1000000
 *         ) 
 *     {}
 * }
 */
abstract contract KitxERC20 is ERC20, ERC20Burnable, Ownable {
    constructor(
        string memory name, 
        string memory symbol, 
        uint256 initialSupply
    )
        ERC20(name, symbol)
        Ownable(msg.sender)
    {
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }
}
