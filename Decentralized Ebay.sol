pragma solidity >0.7<0.9;
//Making of decentralized ebay
contract Auction {
    address payable public beneficiary;
    uint public AuctionEndTIme;
    address public HighestBidder;
    uint public HighestBid;
    uint public amount;
    bool ended;

    mapping (address => uint) pendingReturns;

    event HighestBidIncreased (address bidder,uint amount);
    event AuctionEnded (address winner,uint amount);

    constructor (uint _biddingTime, address payable _beneficiary){
        beneficiary = _beneficiary;
        AuctionEndTIme = block.timestamp + _biddingTime;
    }
    
    function bid() public payable {
            if(block.timestamp > AuctionEndTIme){revert ('Sorry, The auction has ended');}

            if (msg.value <= HighestBid){revert ('Sorry, your bid is not high enough');}

            if(HighestBid != 0){pendingReturns[HighestBidder] += HighestBid;}

            HighestBidder = msg.sender;
            HighestBid = msg.value;
            emit HighestBidIncreased(msg.sender, msg.value);
            }

            //wuthdraw bids that were overbid
         function withdraw () public payable returns (bool){
             if (amount > 0){
                 pendingReturns[msg.sender]= 0;
             }
             if (!payable(msg.sender).send(amount)){
                 pendingReturns[msg.sender]= amount;
             }
             return true;
         }   

         function auctionEnd () public {
             if(block.timestamp < AuctionEndTIme) revert ('The acution has not ended yet');
             if(ended) revert ('The auction is already over!');
             ended = true;
             emit AuctionEnded (HighestBidder, HighestBid);
             beneficiary.transfer(HighestBid);
         }

         
        }
    