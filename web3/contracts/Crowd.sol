
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract crowdFund{
    string public Campaign_name;
    string public Description;
    uint256 public goal;
    uint256 public deadLine;
    address public owner;

    enum campaign_state {active,successful,failed} //enum - multi value states
    campaign_state public states;

    modifier  campaignState(){
        require(states == campaign_state.active,"Campaign state");
        _;
    }

    struct Tier { //like a type or sub contract
         string name;
         uint256 amount;
         uint256 backers;
    }

    struct backersWallet {
        uint256 totalContribution;
        mapping(uint256 => bool) fundedTier; //hey if backer fund uint256 if true => bool value
    }

    mapping (address => backersWallet) public backers;     //adds backersWallet to address

    Tier[] public tiers; //array nammed tiers

    modifier onlyOwner() {
       require(msg.sender == owner,"Only the owner can withdraw");
       _; //run remainder of function if they met requirement
    }

    
    constructor(string memory _name,string memory _description,uint256 _goal,uint256 _durationDays)
    {
           Campaign_name = _name;
           Description = _description;
           goal = _goal;
           deadLine = block.timestamp + (_durationDays * 1 days);
           owner = msg.sender;
           states = campaign_state.active;
     }

     function checkAndUpdateContracts() internal { //INTERNAL - only visible to class
        if(states == campaign_state.active){
               if(block.timestamp >= deadLine){
                    states = address(this).balance >= goal ? campaign_state.successful :  campaign_state.failed;
               }
            else {
                states = address(this).balance >= goal ? campaign_state.successful : campaign_state.active;
            }
        }
     }

   function addFunds(uint256 _tierIndex) public payable campaignState(){ //adds funds
      //need to met to execute
          require(block.timestamp < deadLine, "The campaign has ended, your've late");
          require(_tierIndex < tiers.length,"Invalid Tier");
          require(msg.value == tiers[_tierIndex].amount,"amount Required not met");
          tiers[_tierIndex].backers++;
           backers[msg.sender].totalContribution += msg.value;
           backers[msg.sender].fundedTier[_tierIndex] = true;
          checkAndUpdateContracts();
   }

   function withdraw() public onlyOwner  {
        require(msg.sender == owner,"Only the owner can withdraw");
        require(address(this).balance >= goal,"Goal has not been reached");

        uint256 balance = address(this).balance;
        require(balance > 0,"Cant withdraw ");
        payable(owner).transfer(balance);
   }

   function getContractBalance() public view returns (uint256)  { //readonly - view
         return address(this).balance; 
   }

   function addTier(string memory _nameTier,uint256 _amount) public onlyOwner{
         require(_amount > 0,"amount must be greater than 0");
         tiers.push(Tier(_nameTier,_amount,0));
   }
 //view = readOnly
 function removeTier(uint256 _index ) public onlyOwner{
    require(_index < tiers.length,"Tier does not exist");
    tiers[_index] = tiers[tiers.length - 1];
    tiers.pop();
 }

 function refund() public{
    checkAndUpdateContracts();
    require(states == campaign_state.failed,"The refund was not available");
    uint256 amount = backers[msg.sender].totalContribution;
    require(amount > 0,"No contribution refunds");
    backers[msg.sender].totalContribution = 0;
    payable(msg.sender).transfer(amount);
 }

 function hasFunded(address _backer,uint256 _tierIndex) public view returns (bool) {
    return backers[_backer].fundedTier[_tierIndex];
 }

}