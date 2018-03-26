pragma solidity ^0.4.18;

contract Coursetro {
    
   string public fName;
   uint public age;

    
    event Instructor(
       string name,
       uint age
    );
    
    
   function setInstructor(string _fName, uint _age) public {
       fName = _fName;
       age = _age;
       Instructor(_fName, _age);
   }
   
   function getInstructor() view public returns (string, uint) {
       return (fName, age);
   }
   
}