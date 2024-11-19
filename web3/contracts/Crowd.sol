
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

contract crowdFund{
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }
    mapping (uint256  => Campaign) public campagings;

    uint256 public numberofCamp = 0;
   //use memoty for string type parameter
    function createCampaign(address _owner ,string memory _title, string memory _description , uint256 _target,uint256 _deadline,string memory _image) public return (uint256) {
        Campaign storage campaign = campaigns[numberofCamp]
    //contract  //store in //variable name  
     require(campaign.deadline < block.timestamp, "The deadline should be at future ");
       campaign.owner = _owner;
       campaign.title = _title;
       campaign.description = _description;
       campaign.target = _target;
       campaign.deadline = _deadline;
       campaign.amountCollected = 0;
       campaign.image = _image ;

       numberOfCamp++;

       return numberOfCamp - 1;
    }

     function donateCampaign (uint256 _id) public payable  {
         uint256 amount = msg.value

         Campaign storage campaign = campaigns[_id] //array of _id

         campaign.donators.push(msg.sender);
         campaign.donations.push(amount);

         (bool sent,) = payable(campaign.owner).call{value:amount}("");

         if(sent){
            campaign.amountCollected = campaign.amountCollected + amount;
         }
                                     
     }

     function getDonators(uint256) view public returns (address[] memory,uint256[] memory) {
        return (campagings[_id].donators,campaigns[_id].donations)
     }
    
}