// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ClassroomManagement {
    address public teacher; // The class teacher (admin)

    struct Student {
        string name;
        uint256 marks;
        bool isRegistered;
    }

    mapping(address => Student) private students; // Mapping to store student details

    event StudentAdded(address indexed studentAddress, string name, uint256 marks);
    event StudentRemoved(address indexed studentAddress);
    
    modifier onlyTeacher() {
        require(msg.sender == teacher, "Only the teacher can perform this action");
        _;
    }

    modifier onlyStudent() {
        require(students[msg.sender].isRegistered, "Only registered students can access this");
        _;
    }

    constructor() {
        teacher = msg.sender; // The deployer is the teacher
    }

    function addStudent(address _studentAddress, string memory _name, uint256 _marks) public onlyTeacher {
        require(!students[_studentAddress].isRegistered, "Student already exists");

        students[_studentAddress] = Student(_name, _marks, true);
        emit StudentAdded(_studentAddress, _name, _marks);
    }

    function removeStudent(address _studentAddress) public onlyTeacher {
        require(students[_studentAddress].isRegistered, "Student not found");

        delete students[_studentAddress];
        emit StudentRemoved(_studentAddress);
    }

    function viewProfile() public view onlyStudent returns (string memory, uint256) {
        Student memory student = students[msg.sender];
        return (student.name, student.marks);
    }

    function viewStudentProfile(address _studentAddress) public view onlyTeacher returns (string memory, uint256) {
        require(students[_studentAddress].isRegistered, "Student not found");
        Student memory student = students[_studentAddress];
        return (student.name, student.marks);
    }
}