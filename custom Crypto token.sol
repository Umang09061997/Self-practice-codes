pragma solidity ^0.8;
contract AvantiiCoin{
    //The keyword public makes variable
    //accessible from other contracts
    address public minter;
    mapping(address => uint) public balances;

    //Events allow clients to specific contract changes we declare
    //Event is an inheritable member of a contract. An event is emitted, it stores the arguments passed in transaction logs.
    //These logs are stored in blockchain and are accessible using address of the contract till the contract is present
    
    event Sent (address from, address to, uint amount);

    //Constructor code is only run when the contract is created
    constructor(){
        minter = msg.sender;
    }

    //Sends an amount of newly minted coins to an address, can be called only by the contract creator

    function mint(address receiver, uint amount) public {
        require (minter == msg.sender);
        balances[receiver] = balances[receiver] + amount;
    }

    //Error allows you to provide information about why the operation failed.
    //They are returned to caller by function.

    error insufficientBalance (uint requested, uint available);

    //Sends and amount of existing coins from any caller to address
    function send (address receiver, uint amount) public{
        if (amount > balances[msg.sender])
        revert insufficientBalance({
            requested : amount,
            available : balances[msg.sender]});

            balances[msg.sender]= balances[msg.sender]-amount;
            balances[receiver]= balances[receiver]+amount;
            emit Sent(msg.sender, receiver, amount);
        
    }
}