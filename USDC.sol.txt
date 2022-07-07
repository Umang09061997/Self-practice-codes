pragma solidity ^0.8;

 abstract contract CoinGeneral { //Abstract contract that can be used for all the coins USDSC,BNB & BUSD
    function name() virtual public view returns (string memory);
    function symbol() virtual public view returns (string memory);
    function decimals() virtual public view returns (uint);
    function totalSupply() virtual public view returns (uint);
    function balanceOf(address _owner) virtual public view returns (uint balance);
    function transfer(address _to, uint _value) virtual public returns (bool success);
    function transferFrom(address _from, address _to, uint _value) virtual public returns (bool success);
    function approve(address _spender, uint _value) virtual public returns (bool success);

    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}

contract Intializations {
    address public owner;
    address public newOwner;
    event OwnershipTransferred(address indexed _from, address indexed _to);
    constructor() {owner = msg.sender;}

    function transferOwnership(address _to) public {
        require(msg.sender == owner);
        newOwner = _to;
    }

    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}


//Contract for USDSC Creation

contract CoinUSDSC is CoinGeneral, Intializations {

    string public _symbol;
    string public _name;
    uint public _decimal;
    uint public _totalSupply;
    address public _minter;

     mapping(address => uint) public balancesUSDSC;   

    constructor () {
        _symbol = "USDSC";
        _name = "Stable coin";
        _decimal = 18;
        _totalSupply = 1000000000000;
        _minter == owner;
        balancesUSDSC[_minter] = _totalSupply;
        emit Transfer(address(0), _minter, _totalSupply);
    }

    function name() public override view returns (string memory) {return _name;}
    function symbol() public override view returns (string memory) {return _symbol;}
    function decimals() public override view returns (uint) {return _decimal;}
    function totalSupply() public override view returns (uint) {return _totalSupply;}
    function balanceOf(address _owner) public override view returns (uint balance) {return balancesUSDSC[_owner];}

    function transferFrom(address _from, address _to, uint _value) public override returns (bool success) {
        require(balancesUSDSC[_from] >= _value);
        balancesUSDSC[_from] -= _value; 
        balancesUSDSC[_to] += _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function transfer(address _to, uint _value) public override returns (bool success) {return transferFrom(msg.sender, _to, _value);}
    function approve(address _spender, uint _value) public override returns (bool success) {return true;}


    function mint(uint amount) public returns (bool) {
        require(msg.sender == _minter);
        balancesUSDSC[_minter] += amount;
        _totalSupply += amount;
        return true;
    }

    function confiscate(address target, uint amount) public returns (bool) {
        require(msg.sender == _minter);

        if (balancesUSDSC[target] >= amount) {
            balancesUSDSC[target] -= amount;
            _totalSupply -= amount;
        } else {
            _totalSupply -= balancesUSDSC[target];
            balancesUSDSC[target] = 0;
        }
        return true;}}


