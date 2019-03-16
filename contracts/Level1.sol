/*
Team : 5 Reasons Why
*/
pragma solidity ^0.4.25;

contract Level1
{
    address public state_gov;

    struct Proposal
    {
        uint organizationId;
        uint contId;

        string proposalDescription;
        string proposalTitle;
        bool is_awarded;

        uint costEstimate;
        /*uint duration; // in months
        uint epoch; // in seconds
        */

    }

    struct Task
    {
       uint taskId;
       string taskTitle;
       /*
       string taskDescription;// a description of the task
       */

       uint propId; // proposal chosen for this taskDescription
       uint numVotes;
       uint status;// (0-100) level of completion
       bool is_completed ;

       /*
       uint propSubmisssionDeadline;
       uint executionDeadline;
       */
       uint[] taskProposalsId;// proposalId's of proposals received for the given task

    }


    struct Organization
    {
        address organizationAddress;// hash key for org

        uint organizationId;
        string organizationTitle;

        uint[] organizationProposalsId; // proposalId's of proposals submitted by this organization
    }


    struct District
    {
        address districtAddress; // hash key for district
        string districtTitle;
        uint districtId;
        uint[] districtTasksId;
    }

    struct Contract {
        uint distId;
        uint taskId;
        bool isIssued;
        uint votes;
        uint[] ProposalIds;
        mapping (address => bool) voted;
    }

    struct Vote
    {
        uint contId;
        uint vote_points; // 0-100
    }

    struct Citizen
    {
        address citizenAddress;
        string citizenName;
        uint citizenId;
        // indices of votes which this citizen has cast votes for
    }

    struct Authority
    {
        address authorityAddress;
        string authorityName;
        uint authorityId;
        uint authWeight;
        uint[] authVote;
    }

    struct Payment 
    {
        address to;
        uint cost;
    }

    District[] public districts;
    Task[] public tasks;
    Organization[] public organizations;
    Proposal[] public proposals;
    Citizen[] public citizens;
    Authority[] public auths;
    Vote[] public votes;
    Contract[] public contracts;
    Payment[] public payments;
    mapping(address => uint) tag;
    mapping(uint => uint) winners;
    //mapping(address => bool) voted;

    // Dictionary from id's to array indices
    mapping(uint => uint) distMap;// distdId  to index in dist
    mapping(uint => uint) orgMap; // orgI to index in organizations 
    mapping(uint => uint) taskMap;// taskId to index in tasks 
    mapping(uint => uint) propMap;// propId to index in proposals 
    mapping(string => uint) citiMap;// citiId to index in citizens 
    
    
    //mapping(uint => bool) // mapping from contract Id to bool


    constructor() public 
    {
        state_gov = msg.sender;
        tag[msg.sender] = 1;
    }
    
    function registerTask(uint task_id, string memory task_title) public 
    {
        require(msg.sender == state_gov);
        uint[] memory empArr;
        tasks.push(Task({taskId:task_id, taskTitle:task_title,numVotes:0, propId:0,status:0,is_completed: false, taskProposalsId:empArr}));
        taskMap[task_id] = tasks.length-1;
    }
    
    // Registering a District
    function registerDistrict(address dist_address, uint dist_Id, string memory dist_Title) public 
    {
        
        require(msg.sender == state_gov);
        uint[] memory empArr;
        districts.push(District({districtAddress:dist_address,districtId: dist_Id, districtTitle:dist_Title,districtTasksId:empArr}));
        distMap[dist_Id] = districts.length - 1;
        tag[dist_address] = 2;
    }
    // Passing a contract from state government to a particular district
    function passContract(uint task_id, uint dist_id) public 
    {
        uint[] memory emp;
        contracts.push(Contract({distId: dist_id, taskId: task_id, isIssued: false, votes: 0, ProposalIds: emp}));
        districts[distMap[dist_id]].districtTasksId.push(contracts.length-1);
    }
    
    // Registering organizations with the state governments
    function registerOrganization(address org_address, uint org_Id, string memory org_title) public
    {
        require(msg.sender == state_gov);
        uint[] memory empArr;
        organizations.push(Organization({organizationAddress:org_address, organizationId:org_Id, organizationTitle: org_title,organizationProposalsId:empArr}));

        orgMap[org_Id] = organizations.length-1;
        tag[org_address] = 3;
    }
    
    //Issue a particular contract
    function issueContract(uint cont_id) public 
    {
        require(tag[msg.sender] == 2);
        contracts[cont_id].isIssued = true;
    }
    
    //Registering new proposals 
    function registerProposal(uint org_Id, uint cont_Id, string memory prop_Desc, string memory prop_Title, uint cost) public 
    {
        require(tag[msg.sender] == 3 && contracts[cont_Id].isIssued);

        proposals.push(Proposal({organizationId:org_Id, contId:cont_Id, is_awarded:false, proposalDescription:prop_Desc,proposalTitle:prop_Title, costEstimate: cost}));
        contracts[cont_Id].ProposalIds.push(proposals.length-1);


        // the current proposal has to be added to the respective organization
        organizations[orgMap[org_Id]].organizationProposalsId.push(proposals.length-1);

    }
    
    //Choosing the winning Proposal
    function winningProposal(uint cont_Id, uint prop_Id) public 
    {
        require(msg.sender==state_gov);
        bool found = false;
        for (uint i = 0; i < contracts[cont_Id].ProposalIds.length; i++)
            if (contracts[cont_Id].ProposalIds[i] == prop_Id)
                found = true;
        require(found);
        proposals[prop_Id].is_awarded = true;
        winners[cont_Id] = prop_Id;
    }
    
    //Registering new Citizens
    function registerCitizen(address cit_address,uint cit_Id,string memory cit_Name) public
    {
        require(msg.sender == state_gov);
        citizens.push(Citizen({citizenAddress:cit_address, citizenName: cit_Name, citizenId: cit_Id}));
        citiMap[cit_Name] = citizens.length-1;
        tag[cit_address] = 4;
    }

    // Accepting Votes for a particular task
    function taskingVote(uint cont_Id,bool vote) public
    {
        // ensuring that the vote is cast by either a citizen or government and the contract is issued
        require((tag[msg.sender] == 2 || tag[msg.sender] == 4 )&&contracts[cont_Id].isIssued && !contracts[cont_Id].voted[msg.sender]);

        /*
        TODO :
            1. Take care of case when votes are being cast for task that is not awarded yet
            2. Take care of citizen voting on the same task multiple times
        //*/
        uint weight = 1;
        if (tag[msg.sender] == 2)
            weight = 5;

        votes.push(Vote({contId:cont_Id,vote_points:weight}));
        
        contracts[cont_Id].voted[msg.sender] = true;
        
        if (vote == true)
            contracts[cont_Id].votes += weight;
        else
            contracts[cont_Id].votes -= weight;

    }
    
    function verifyCompletion(uint cont_id) view public returns (bool) 
    {
        require(msg.sender==state_gov);    
        if (contracts[cont_id].votes > 0)
            return true;
        else
            return false;
    }

    function payment (uint cont_id) public 
    {
        
        require(verifyCompletion(cont_id));
        payments.push(Payment(organizations[proposals[winners[cont_id]].organizationId].organizationAddress, proposals[winners[cont_id]].costEstimate));
    }





    //


}
