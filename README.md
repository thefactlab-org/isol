<p align="center">
  <br>
    isol | Interface SmartContract Solidity - A modern smart contract toolkit.
  <br>
</p>

<div align="center" style="display: flex; justify-content: center; flex-wrap: wrap; gap: 10px;">
  <a href="https://github.com/thefactlab-org/isol/stargazers">
    <img src="https://img.shields.io/github/stars/thefactlab-org/isol?style=social" alt="Stars Badge" />
  </a>
  <a href="https://github.com/thefactlab-org/isol/forks">
    <img src="https://img.shields.io/github/forks/thefactlab-org/isol?style=social" alt="Forks Badge" />
  </a>
  <a href="https://github.com/thefactlab-org/isol/pulls">
    <img src="https://img.shields.io/github/issues-pr/thefactlab-org/isol?style=social" alt="Pull Requests Badge" />
  </a>
  <a href="https://github.com/thefactlab-org/isol/issues">
    <img src="https://img.shields.io/github/issues/thefactlab-org/isol?style=social" alt="Issues Badge" />
  </a>
  <a href="https://github.com/thefactlab-org/isol/graphs/contributors">
    <img alt="GitHub contributors" src="https://img.shields.io/github/contributors/thefactlab-org/isol?style=social" />
  </a>
</div>

## Installation

> foundry for install <br/>
> `forge install thefactlab-org/isol --no-commit`
> and add file `remappings.txt` with `@thefactlab-org/=lib/contracts`

```bash [npm]
npm i isol
```

## Quick Start

```ts
pragma solidity ^0.8.30;

import "isol/contracts/kit/KitxERC20.sol";

contract Kit is KitxERC20 {
    constructor()
        KitxERC20(
            "Kit Token", // Name (string)
            "KIT", // Symbol (string)
            1000000 // Initial Supply (number: uint256)
        )
    {}
}
```

## Donate

Support core development team and help to the project growth.

```bash [EVM Compatible]
0x6A74308F267c07556ED170025AE2D1753F747E20
```
