pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;
//import "http://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20Capped.sol";
import "./ERC20Capped.sol";
//import "./ERC900.sol";

contract MoovItTest is ERC20Capped {

  mapping (address => Moovr) public Moovrs;
  address[] private creators;


  modifier onlyOwner(){
      require(msg.sender == owner);
      _;
  }

struct Moovr {
//  uint id;
  uint totalKmWalked;
  uint kmWalked;
  }

  address owner;

  constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _cap)
    ERC20Capped(_cap) public{
      owner = msg.sender;
    }

function createMoovr(address creator) public {
  creator = msg.sender;
  Moovr memory newMoovr;
//  newMoovr.id = Moovrs.length;
  newMoovr.totalKmWalked = 0;

  insertMoovr(newMoovr);
  creators.push(msg.sender);

  assert(
      keccak256(
          abi.encodePacked(
          //    Moovr[msg.sender].id,
              Moovrs[creator].totalKmWalked,
              Moovrs[creator].kmWalked
          )
      )
      ==
      keccak256(
          abi.encodePacked(
            //  newMoovr.id,
              newMoovr.totalKmWalked,
              newMoovr.kmWalked
          )
      )
  );
//  emit personCreated(newPerson.name, newPerson.senior);
}

function insertMoovr(Moovr memory newMoovr) private {
    address creator = msg.sender;
    Moovrs[creator] = newMoovr;
}
function getMoovr() public view returns(uint totalKmWalked, Moovr memory){
  //  address creator = msg.sender;
    //return (totalKmWalked, Moovrs);
}

function getTotalKm(address user) public {
  //return Moovr.totalKmWalked;
}

function setTotalKm() public returns(uint totalKmWalked){
  address creator = msg.sender;
  Moovrs[creator].totalKmWalked + Moovrs[creator].kmWalked;
  return Moovrs[creator].totalKmWalked;
}

function getKm(uint256 inputKmWalked) public {
  address creator = msg.sender;
  Moovrs[creator].kmWalked = inputKmWalked;
  _mint(msg.sender, inputKmWalked);
  setTotalKm();
}
function deleteMoovr(address creator) public onlyOwner {
//  uint id = Moovr[creator].id;

   delete Moovrs[creator];
  // emit moovrDeleted(id, creator, owner);
}

function getCreators(uint index) public view returns(address){
  return creators[index];

}
}
/*
contract MoovItStake is MoovItTest, ERC900 {

  using SafeMath for uint256;

  ERC20 MilkBucket;

  mapping (address => MoovStake) public stakeHolders;

  struct Stake {
    uint256 unlockedTimestamp;
    uint256 actualAmmount;
    address stakedFor;
  }

  struct StakeContract {
    uint256 totalStakedFor;
    uint256 personalStakeIndex;
    Stake[] personalStakes;
    bool exists;
  }
  modifier canStake(address _address, uint256 _amount) {
    require(
      stakingToken.transferFrom(_address, this, _amount),
      "Stake required");

    _;
  }
constructor(ERC20 _MilkBucket) public {
  MilkBucket = _MilkBucket;
}
function getPersonalStakeActualAmounts(address _address) external view returns (uint256[]) {
    uint256[] memory actualAmounts;
    (,actualAmounts,) = getPersonalStakes(_address);

    return actualAmounts;
  }
  function getPersonalStakeForAddresses(address _address) external view returns (address[]) {
    address[] memory stakedFor;
    (,,stakedFor) = getPersonalStakes(_address);

    return stakedFor;
  }
  function stake(uint256 _amount, bytes _data) public {
      createStake(
        msg.sender,
        _amount,
        defaultLockInDuration,
        _data);
    }
  function stakeFor(address _user, uint256 _amount, bytes _data) public {
      createStake(
        _user,
        _amount,
        defaultLockInDuration,
        _data);
    }
  function unstake(uint256 _amount, bytes _data) public {
     withdrawStake(
        _amount,
        _data);
   }
  function totalStakedFor(address _address) public view returns (uint256) {
      return stakeHolders[_address].totalStakedFor;
   }
  function totalStaked() public view returns (uint256) {
      return stakingToken.balanceOf(this);
    }
  function token() public view returns (address) {
      return stakingToken;
    }

  function getPersonalStakes(
      address _address
      )
      view
      public
      returns(uint256[], uint256[], address[])
    {
      StakeContract storage stakeContract = stakeHolders[_address];

      uint256 arraySize = stakeContract.personalStakes.length - stakeContract.personalStakeIndex;
      uint256[] memory unlockedTimestamps = new uint256[](arraySize);
      uint256[] memory actualAmounts = new uint256[](arraySize);
      address[] memory stakedFor = new address[](arraySize);

      for (uint256 i = stakeContract.personalStakeIndex; i < stakeContract.personalStakes.length; i++) {
        uint256 index = i - stakeContract.personalStakeIndex;
        unlockedTimestamps[index] = stakeContract.personalStakes[i].unlockedTimestamp;
        actualAmounts[index] = stakeContract.personalStakes[i].actualAmount;
        stakedFor[index] = stakeContract.personalStakes[i].stakedFor;
      }

      return (
        unlockedTimestamps,
        actualAmounts,
        stakedFor
      );

function withdrawStake(
   uint256 _amount,
   bytes _data
 )
   internal
 {
   Stake storage personalStake = stakeHolders[msg.sender].personalStakes[stakeHolders[msg.sender].personalStakeIndex];

   // Check that the current stake has unlocked & matches the unstake amount
   require(
     personalStake.unlockedTimestamp <= block.timestamp,
     "The current stake hasn't unlocked yet");

   require(
     personalStake.actualAmount == _amount,
     "The unstake amount does not match the current stake");

   // Transfer the staked tokens from this contract back to the sender
   // Notice that we are using transfer instead of transferFrom here, so
   //  no approval is needed beforehand.
   require(
     stakingToken.transfer(msg.sender, _amount),
     "Unable to withdraw stake");

   stakeHolders[personalStake.stakedFor].totalStakedFor = stakeHolders[personalStake.stakedFor]
     .totalStakedFor.sub(personalStake.actualAmount);

   personalStake.actualAmount = 0;
   stakeHolders[msg.sender].personalStakeIndex++;

   emit Unstaked(
     personalStake.stakedFor,
     _amount,
     totalStakedFor(personalStake.stakedFor),
     _data);
 }
}
*/
