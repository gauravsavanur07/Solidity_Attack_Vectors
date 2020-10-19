pragma solidity ^0.5.0;
// Example Integer Overflow and Underflow

contract VulnerableContract {
    uint MINIMUM_INVESTMENT = 50 ether;
    uint32 INITIAL_LOCK_TIME = 2592000; // 30 days in seconds
    address payable currentInvestor;
    uint investmentTimestamp;
    uint32 public lockTime = INITIAL_LOCK_TIME;

    function  increaseLockTime(uint32 _seconds) public {
        require(msg.sender == currentInvestor);
        lockTime += _seconds; // uint32 max is 4294967295 seconds. Attack passing 4292375295
    }

    function invest() public payable {
        require(currentInvestor == address(0));
        require(msg.value >= MINIMUM_INVESTMENT);
        currentInvestor = msg.sender;
        investmentTimestamp = now;
    }

    function withdrawWithProfit() public {
        require(msg.sender == currentInvestor);
        require(now - investmentTimestamp >= lockTime);
        uint profit = 1 ether + lockTime * 1 wei;
        currentInvestor.transfer(MINIMUM_INVESTMENT + profit);
        currentInvestor = address(0);
        lockTime = INITIAL_LOCK_TIME;
    }

    function getBalance() view public returns(uint) {
        return address(this).balance;
    }

    function() external payable {}
}
