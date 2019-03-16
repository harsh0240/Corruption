pragma solidity ^0.5.0;

contract Level1 
{
    address public state_gov;
    
    struct Proposal
    {
        
        uint proposalId;
        uint organizationId;
        uint taskId;
        
        string proposalDescription;
        string proposalTitle;
        bool is_awarded;
        
        /*
        uint costEstimate;
        uint duration; // in months
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
        
        // registerProposal(taskId)
    }
    

    struct District
    {
        address districtAddress; // hash key for district
        string districtTitle;
        uint districtId;
        
        
        uint[] districtTasksId;
    }
    
    struct Vote
    {
        
        uint taskId;
        uint vote_points; // 0-100
    }
    
    struct Citizen
    {
        address citizenAddress;
        string citizenName;
        uint citizenId;
        
        uint[] citizenVote; // indices of votes which this citizen has cast votes for
    }
    
    struct Authority
    {
        address authorityAddress;
        string authorityName;
        uint authorityId;
        
        uint[] authVote;
    }
    
    
    
    District[] public districts;
    Task[] public tasks;
    Organization[] public organizations;
    Proposal[] public proposals;
    Citizen[] public citizens;
    Authority[] public auths;
    Vote[] public votes;
    
    
    // Assumption names of entities are unique
    mapping(string => uint) distMap;// distTitle  to index in dist with distTitle
    mapping(string => uint) orgMap; // orgTitle to index in organizations with orgTitle 
    mapping(string => uint) taskMap;// taskTitle to index in tasks with orgTitle
    mapping(string => uint) propMap;// propTitle to index in proposals with propTitle
    mapping(string => uint) citiMap;// citizenName to index in citizens with citizenName
    mapping(string => uint) authMap;


    constructor() public {
        state_gov = msg.sender;
    }

    function registerTask(uint task_id, string memory task_title) public {
        require(msg.sender == state_gov);
        uint[] memory empArr;
        tasks.push(Task({taskId:task_id, taskTitle:task_title,numVotes:0, propId:0,status:0,is_completed: false, taskProposalsId:empArr}));
        taskMap[task_title] = tasks.length-1;

    }

    function registerDistrict(address dist_address, uint dist_Id, string memory dist_Title) public {
        require(msg.sender == state_gov);
        uint[] memory empArr;
        districts.push(District({districtAddress:dist_address,districtId: dist_Id, districtTitle:dist_Title,districtTasksId:empArr}));
        distMap[dist_Title] = districts.length - 1;
    }
    
    function registerOrganization(address org_address, uint org_Id, string memory org_title) public
    {
        require(msg.sender==state_gov);
        uint[] memory empArr;
        organizations.push(Organization({organizationAddress:org_address, organizationId:org_Id, organizationTitle: org_title,organizationProposalsId:empArr}));
        
        orgMap[org_title] = organizations.length-1;
    }

    function registerProposal(uint prop_Id, string memory org_title,string memory task_title, string memory prop_Desc, string memory prop_Title) public {
        require(msg.sender == state_gov);
        uint org_Id = organizations[orgMap[org_title]].organizationId;
        uint task_Id = tasks[taskMap[task_title]].taskId;
        
        proposals.push(Proposal({proposalId:prop_Id,organizationId:org_Id, taskId:task_Id, is_awarded:false, proposalDescription:prop_Desc,proposalTitle:prop_Title}));
        propMap[prop_Title] =proposals.length - 1;
        
        
        // the current proposal has to be added to the respective task ,and organization
        organizations[orgMap[org_title]].organizationProposalsId.push(prop_Id);
        tasks[taskMap[task_title]].taskProposalsId.push(prop_Id);
        
        
    }
    
    /*
    function verifyCompletion(uint task_id)
    {
        int u=0;
        for(int i= votes[])
    }
    
    
    function claimCompletion(string memory task_title,string memory org_title,uint status)
    {
        require(msg.sender==state_gov);
        uint task_Id = tasks[taskMap[task_title]].taskId;
        
        /*
        TODO :
            1. Assert if the organization claiming the task has actually been awarded tha task
        /
        
        
        
        
        verifyCompletion(task_id);
        
    }
    //*/
    function registerCitizen(address cit_address,uint cit_Id,string memory cit_Name) public
    {
        require(msg.sender ==state_gov);
        
        uint[] memory empArr;
        citizens.push(Citizen({citizenAddress:cit_address, citizenName: cit_Name, citizenId: cit_Id,citizenVote:empArr}));
        citiMap[cit_Name] = citizens.length-1;
    }
    
    
    function citizenTaskVote(string memory cit_title,string memory task_title,uint vote_value) public
    {
        require(msg.sender==state_gov);
        /*
        TODO : 
            1. Take care of case when votes are being cast for task that is not awarded yet
            2. Take care of citizen voting on the same task multiple times
        //*/
        uint task_Id = tasks[taskMap[task_title]].taskId;
        votes.push(Vote({taskId:task_Id,vote_points:vote_value}));
        
        
        citizens[citiMap[cit_title]].citizenVote.push(votes.length-1);
        uint num_votes = tasks[taskMap[task_title]].numVotes;
        tasks[taskMap[task_title]].status = uint((tasks[taskMap[task_title]].status*num_votes+vote_value)/(num_votes+1));
        tasks[taskMap[task_title]].numVotes+=1;
        
    }
    
    function registerAuthority(address auth_address,uint auth_Id,string memory auth_Name) public
    {
        require(msg.sender ==state_gov);
        
        uint[] memory empArr;
        auths.push(Authority({authorityAddress: auth_address, authorityName:auth_Name, authorityId: auth_Id, authVote:empArr}));
        authMap[auth_Name] = auths.length-1;
    }
    
    function authorityTaskVote(string memory auth_title,string memory task_title,uint vote_value) public
    {
        require(msg.sender==state_gov);
        /*
        TODO : 
            1. Take care of case when votes are being cast for task that is not awarded yet
            2. Take care of authority is  voting on the same task multiple times
        //*/
        uint task_Id = tasks[taskMap[task_title]].taskId;
        votes.push(Vote({taskId:task_Id,vote_points:vote_value}));
        
        
        auths[authMap[auth_title]].authVote.push(votes.length-1);
        uint num_votes = tasks[taskMap[task_title]].numVotes;
        tasks[taskMap[task_title]].status = uint((tasks[taskMap[task_title]].status*num_votes+vote_value)/(num_votes+1));
        tasks[taskMap[task_title]].numVotes+=1;
        
    }
    
    
    
    //
    
    
}

