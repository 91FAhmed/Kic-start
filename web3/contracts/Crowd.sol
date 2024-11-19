// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract MyCrowd {
    struct Campaign{
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
mapping(uint256 => Campaign)public Campaigns; //Campaigns[0]

uint256 public noOfCampaings = 0; 

function createCampaingn(address _owner,string memory _title,string memory _description, uint256 _target, uint256 _deadline string memeory _image ) public return(uint256)   {
    Campaign storage Campaign = Campaigns[numberOfCampaings]

    require(Campaign.deadline < block.timestamp, "The deadline should be in future")

    Campaign.owner = _owner ;
    Campaign.title = _title;
    Campaign.deadline = _deadline;
    Campaign.amountCollected = 0;
    Campaign.images = _image;
    Campaign.description = _description;
    Campaign.target = _target ;

    noOfCampaings++


}

function donateToCampaings()  returns () {
    
}

function getDonors()  returns () {
    
}

function getCampaigs()  returns () {
    
}

}
