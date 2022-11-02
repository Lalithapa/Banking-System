// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract banking {
    address public immutable i_bankOwner; //Code Deployer will be the BankOwner
    uint256 constant registrationAmt = 1 ether;
    uint256 constant minDepositAmt = 100 wei; //as to prevent that a person can deposit more than 0 ether/ 0wei
    address payable[] depositors;
    mapping(address => uint256) public userBalances;
    mapping(address => bool) public isRegistered;

    constructor() {
        i_bankOwner = msg.sender;
    }

    function registration() public payable returns (bool) {
        require(
            isRegistered[msg.sender] == false,
            "You have already Registered"
        );
        require(
            msg.value == registrationAmt,
            "The Registration amount is 1 Ether"
        ); //it is like ifElse condition
        userBalances[msg.sender] += msg.value;
        depositors.push(payable(msg.sender));
        isRegistered[msg.sender] = true;
        return true;
    }

    function deposit() public payable {
        require(
            isRegistered[msg.sender] == true,
            "You are not registered with our Bank , Kindly Register Yourself!"
        );
        require(
            msg.value > minDepositAmt,
            "Deposit amount should be more than 100 wei"
        );
        userBalances[msg.sender] += msg.value;
    }

    function widthdrawal(uint256 amount) public payable {
        require(
            amount <= userBalances[msg.sender],
            "You don't have sufficient funds in your wallet"
        );
        userBalances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function myBankBalance() public view returns (uint256) {
        return userBalances[msg.sender];
    }

    function bankBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    modifier onlyOwner() {
        require(msg.sender == i_bankOwner, "You're not the BankOwner");
        _;
    }
}
