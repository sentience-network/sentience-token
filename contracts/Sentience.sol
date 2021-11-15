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

  /** @dev Adds a minter. Can only be executed by contract owner
   *  @param minter_ The address to add as minter
   */
  function addMinter(address minter_) external onlyOwner {
    _minters[minter_] = true;
  }

  /** @dev Removes a minter. Can only be executed by contract owner
   *  @param minter_ The address to remove as a minter
   */
  function removeMinter(address minter_) external onlyOwner {
    _minters[minter_] = false;
  }

  /** @dev Mints tokens. Can only be called by a minter
   *  @param account_ Address to mint tokens for
   *  @param amount_ Amount of tokens to mint
   */
  function mint(address account_, uint256 amount_) external onlyMinter {
    _mint(account_, amount_);
  }

  /** @dev Burns token. Can only be called by a minter
   *  @param account_ Address whose tokens should be burned
   *  @param amount_ Amount of tokens to burn
   */
  function burn(address account_, uint256 amount_) external onlyMinter {
    _burn(account_, amount_);
  }

  /** @dev Retrieve ERC20/BEP20 tokens sent to contract. Can only be called by contract owner
   *  @param token_ Address of token to retrieve
   *  @param to_ Address to send tokens to
   *  @param amount_ Amount of tokens to send
   */
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

  /** @dev Retrieve Ether sent to contract. Can only be called by contract owner
   *  @param to_ Address to send Ether to
   *  @param amount_ Amount of Ether to send
   */
  function retrieveEther(address payable to_, uint256 amount_)
    external
    onlyOwner
  {
    to_.transfer(amount_);
  }
}
