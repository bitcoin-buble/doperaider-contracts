pragma solidity ^0.4.24;

// DopeRaiderGasToken Contract
// by gasmasters.io
// contact: team@doperaider.com

// ----------------------------------------------------------------------------
// Safe maths
// ----------------------------------------------------------------------------
library SafeMath {
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function sub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function div(uint a, uint b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}

// core narco contract for getting narco stats
contract NarcosCoreInterface {
  function getNarco(uint256 _id)
  public
  view
  returns(
    string  narcoName,
    uint256 weedTotal,
    uint256 cokeTotal,
    uint16[6] skills,
    uint8[4] consumables,
    string genes,
    uint8 homeLocation,
    uint16 level,
    uint256[6] cooldowns,
    uint256 id,
    uint16[9] stats
  );
  function implementsERC721() public pure returns(bool);
  function ownerOf(uint256 _tokenId) public view returns(address owner);
  function getRemainingCapacity(uint256 _id) public view returns (uint8 capacity);
}
// core districts contract for checking location and redeeming tokens
// core districts contract for checking location and redeeming tokens
contract DistrictsCoreInterface {
  function isDopeRaiderDistrictsCore() public pure returns (bool);
  function getNarcoLocation(uint256 _narcoId) public view returns (uint8 location);
  function updateConsumable(uint256 _narcoId,  uint256 _index ,uint8 _newQuantity) public;
  function updateWeedTotal(uint256 _narcoId,  uint16 _total) public;
  function updatCokeTotal(uint256 _narcoId,  uint16 _total) public;
  function distributeRevenue(uint256 _district , uint8 _splitW, uint8 _splitC) public payable;
}





// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
// ----------------------------------------------------------------------------
contract ERC20Interface {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}


// ----------------------------------------------------------------------------
// Contract function to receive approval and execute function in one call
//
// Borrowed from MiniMeToken
// ----------------------------------------------------------------------------
contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}


// ----------------------------------------------------------------------------
// Owned contract
// ----------------------------------------------------------------------------
contract Owned {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}


// ----------------------------------------------------------------------------
// ERC20 Token, with the addition of symbol, name and decimals and a
// fixed supply
// ----------------------------------------------------------------------------
contract FixedSupplyToken is ERC20Interface, Owned {
    using SafeMath for uint;

    string public symbol;
    string public  name;
    uint8 public decimals;
    uint _totalSupply;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;


    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor() public {
        symbol = "DPRG";
        name = "DopeRaider Gas Token";
        _totalSupply = 1000000000; //1Billion
        balances[owner] = _totalSupply;
        emit Transfer(address(0), owner, _totalSupply);
    }

    // ------------------------------------------------------------------------
    // Total supply
    // ------------------------------------------------------------------------
    function totalSupply() public view returns (uint) {
        return _totalSupply.sub(balances[address(0)]);
    }


    // ------------------------------------------------------------------------
    // Get the token balance for account `tokenOwner`
    // ------------------------------------------------------------------------
    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }


    // ------------------------------------------------------------------------
    // Transfer the balance from token owner's account to `to` account
    // - Owner's account must have sufficient balance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Token owner can approve for `spender` to transferFrom(...) `tokens`
    // from the token owner's account
    //
    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
    // recommends that there are no checks for the approval double-spend attack
    // as this should be implemented in user interfaces
    // ------------------------------------------------------------------------
    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Transfer `tokens` from the `from` account to the `to` account
    //
    // The calling account must already have sufficient tokens approve(...)-d
    // for spending from the `from` account and
    // - From account must have sufficient balance to transfer
    // - Spender must have sufficient allowance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = balances[from].sub(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(from, to, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Returns the amount of tokens approved by the owner that can be
    // transferred to the spender's account
    // ------------------------------------------------------------------------
    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }


    // ------------------------------------------------------------------------
    // Token owner can approve for `spender` to transferFrom(...) `tokens`
    // from the token owner's account. The `spender` contract function
    // `receiveApproval(...)` is then executed
    // ------------------------------------------------------------------------
    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
        return true;
    }


    // ------------------------------------------------------------------------
    // accept payment to allow fund airdrops
    // ------------------------------------------------------------------------
    function () public payable {
      // accept payment to allow fund airdrops
    }


    // ------------------------------------------------------------------------
    // Owner can transfer out any accidentally sent ERC20 tokens
    // ------------------------------------------------------------------------
    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
        return ERC20Interface(tokenAddress).transfer(owner, tokens);
    }
}


// ----------------------------------------------------------------------------
// DopeRaiderGasToken
// ----------------------------------------------------------------------------
contract DopeRaiderGasToken is ERC20Interface,  Owned  , FixedSupplyToken {
    using SafeMath for uint;

    uint consumableIndex = 0;

    /*
    uint constant gasIndex = 0;
    uint constant seedsIndex = 1;
    uint constant chemicalsIndex = 2;
    uint constant ammoIndex = 3;
    */

    uint redeemDistrict = 7; // the location where this token can be redeemed


    function setRedeemDistrict(uint _district) public onlyOwner {
    redeemDistrict = _district;
    }

    uint256 tokenValue = 2 ether; //
    function setTokenValue(uint _value) public onlyOwner {
    tokenValue = _value;
    }

    address public districtContractAddress;
    DistrictsCoreInterface public districtsCore;

    function setDistrictAddress(address _address) public onlyOwner {
    _setDistrictAddresss(_address);
    }

    function _setDistrictAddresss(address _address) internal {
        DistrictsCoreInterface candidateContract = DistrictsCoreInterface(_address);
        require(candidateContract.isDopeRaiderDistrictsCore());
        districtsCore = candidateContract;
        districtContractAddress = _address;
    }

   address public coreAddress;
   NarcosCoreInterface public narcoCore;

    function setNarcosCoreAddress(address _address) public onlyOwner {
    _setNarcosCoreAddress(_address);
    }

    function _setNarcosCoreAddress(address _address) internal {
        NarcosCoreInterface candidateContract = NarcosCoreInterface(_address);
        require(candidateContract.implementsERC721());
        narcoCore = candidateContract;
        coreAddress = _address;
    }

    // ------------------------------------------------------------------------
    // Redeem the token with rules.
    // ------------------------------------------------------------------------
    function redeemToken(uint256 _narcoId , uint8 _quantity) public  {
        // must be owner of the narco and narco must be in redeem location
        require(narcoCore.ownerOf(_narcoId) == msg.sender && districtsCore.getNarcoLocation(_narcoId)==redeemDistrict);
        // msg.sender must own that number of tokens
        require(balanceOf(msg.sender)>=_quantity);
        require(narcoCore.getRemainingCapacity(_narcoId) >= _quantity); // narco has capacity to carry this much

        uint256 narcoWeedTotal;
        uint256 narcoCokeTotal;
        uint8[4] memory narcoConsumables;

        (
                    ,
          narcoWeedTotal,
          narcoCokeTotal,
          ,
          narcoConsumables,
                    ,
                    ,
                    ,
                    ,
                    ,
        ) = narcoCore.getNarco(_narcoId);


        // transfer the tokens back to the owner of the contract
        transfer(owner,  _quantity);

        // update the narco with the consumable
       uint8 newQuantity = uint8(_quantity+ (narcoConsumables[consumableIndex]));
       districtsCore.updateConsumable( _narcoId,  consumableIndex , newQuantity);
       districtsCore.distributeRevenue.value(_quantity*tokenValue)(redeemDistrict,50,50); // distribute the revenue to districts pots


    }// end redeem token

    // ------------------------------------------------------------------------
    // Airdrop tokens
    // ------------------------------------------------------------------------
    function airdropTokens(address[] _recipient , uint _quantity) public onlyOwner {
        for(uint i = 0; i< _recipient.length; i++)
        {
              require(transfer(_recipient[i], _quantity));
        }
      }

      // in case we need to upgrade this
      function withdraw() external onlyOwner {
            if (address(this).balance>0){
              msg.sender.transfer(address(this).balance);
            }
        }


    // ------------------------------------------------------------------------
    // Passthru Test
    // ------------------------------------------------------------------------
    function passthrough(uint256 _id) public view returns (string  narcoName , uint location) {
          (
                narcoName   ,
                            ,
                            ,
                            ,
                            ,
                            ,
                            ,
                            ,
                            ,
                            ,
        ) = narcoCore.getNarco(_id);
         location = districtsCore.getNarcoLocation(_id);
    }

}
