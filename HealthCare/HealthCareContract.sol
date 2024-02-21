// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HealthRecordContract {
    // Structure to represent a health record
    struct HealthRecord {
        string patientName;
        uint8 patientAge;
        string diagnosis;
        bool isActive;
    }

    // Address array to store the list of all patients
    address[] public patients;

    // Mapping to store health records by a unique identifier (e.g., patient Ethereum address)
    mapping(address => HealthRecord) public healthRecords;

    // Event to log when a new health record is added
    event HealthRecordAdded(address indexed patientAddress, string patientName, uint8 patientAge, string diagnosis, bool isActive);

    // Event to log errors
    event Error(string message);

    // Address of the contract owner
    address public contractOwner;

    // Constructor to set the contract owner
    constructor() {
        contractOwner = msg.sender;
    }

    // Modifier to check if the sender is the owner of the health record
    modifier onlyOwner() {
        require(msg.sender == contractOwner, "Only the contract owner can access this function");
        _;
    }

    // Modifier to check if a health record exists for the given address
    modifier healthRecordExists(address patientAddress) {
        require(healthRecords[patientAddress].isActive, "Health record does not exist for the given address");
        _;
    }

    // Fallback function to reject Ether sent directly to the contract
    receive() external payable {
        emit Error("Fallback function is not allowed. Use specific payable functions.");
        revert();
    }

    // Payable function to accept payments
    function makePayment() public payable {
    }

    function addHealthRecord(string memory _name, uint8 _age, string memory _diagnosis, bool _isActive) public {
        // Creating a new health record with provided details
        HealthRecord memory hrecord = HealthRecord(_name, _age, _diagnosis, _isActive);

        // Assigning this new health record to the sender's address in the mapping
        healthRecords[msg.sender] = hrecord;

        // Storing the sender's address in an array (just for reference)
        patients.push(msg.sender);

        // Emitting an event to log the addition of a new health record
        emit HealthRecordAdded(msg.sender, _name, _age, _diagnosis, _isActive);
    }

    function getHealthRecord(address patientAddress) public view healthRecordExists(patientAddress) returns (string memory, uint8, string memory, bool) {
        // Retrieving the health record details for the specified address
        HealthRecord memory hrecord = healthRecords[patientAddress];

        // Returning the details
        return (hrecord.patientName, hrecord.patientAge, hrecord.diagnosis, hrecord.isActive);
    }
}
