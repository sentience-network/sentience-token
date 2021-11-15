pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Sentience is Context, Ownable, ERC20 {
  mapping(address => bool) _minters;

  modifier onlyMinter() {
    require(_minters[_msgSender()], "Sentience: Only minter can call");
    _;
  }

  constructor(
    string memory name_,
    string memory symbol_,
    uint256 amount_
  ) Ownable() ERC20(name_, symbol_) {
    _mint(_msgSender(), amount_);
    _minters[_msgSender()] = true;
  }

  function addMinter(address minter_) external onlyOwner {
    _minters[minter_] = true;
  }

  function removeMinter(address minter_) external onlyOwner {
    _minters[minter_] = false;
  }

  function mint(address account_, uint256 amount_) external onlyMinter {
    _mint(account_, amount_);
  }

  function burn(address account_, uint256 amount_) external onlyMinter {
    _burn(account_, amount_);
  }

  function retrieveToken(
    address token_,
    address to_,
    uint256 amount_
  ) external onlyOwner {
    require(
      token_ != address(0),
      "Sentience: Token address cannot be zero address"
    );
    require(
      to_ != address(0),
      "Sentience: Cannot transfer tokens to zero address"
    );
    require(
      to_ != address(this),
      "Sentience: Cannot transfer token to this contract"
    );
    require(
      IERC20(token_).transfer(to_, amount_),
      "Sentience: Token transfer failed"
    );
  }

  function retrieveBNB(address payable to_, uint256 amount_)
    external
    onlyOwner
  {
    to_.transfer(amount_);
  }
}
