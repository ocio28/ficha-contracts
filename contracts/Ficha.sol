pragma solidity ^0.4.22;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

import "openzeppelin-solidity/contracts/math/SafeMath.sol";

contract Ficha is ERC20, ERC20Detailed, Ownable {
  using SafeMath for uint256;
  string public name = "Ficha";
  string public symbol = "FHA";
  uint8 public decimals = 18;
  uint256 public INITIAL_SUPPLY = 10000 * (10 ** uint256(decimals));

  mapping(bytes32 => address) public nicknames;
  mapping(address => bytes32) public ownerNickname;

  struct Profile {
    string description;
    uint256 icon = 0;
  }

  mapping(address => Profile) public profiles;

  constructor() public ERC20Detailed(name, symbol, decimals) {
    _mint(msg.sender, INITIAL_SUPPLY);
  }

  function register(string _description) public {
    profiles[msg.sender] = Profile(_description);
  }

  function changeNickname(bytes32 _nickname) public {
    require(nicknames[_nickname] == 0x0, 'Already Used');
    bytes32 current = ownerNickname[msg.sender];
    nicknames[_nickname] = msg.sender;
    nicknames[current] = 0x0;
    ownerNickname[msg.sender] = _nickname;
    emit ChangeNickname(current, _nickname, msg.sender);
  }

  event ChangeNickname(bytes32 _from, bytes32 _to, address indexed _owner);
}
