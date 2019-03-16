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

        // registerProposal(taskId)
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

    struct Payment {
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
    mapping(address => bool) voted;


    // Assumption names of entities are unique
    mapping(uint => uint) distMap;// distTitle  to index in dist with distTitle
    mapping(uint => uint) orgMap; // orgTitle to index in organizations with orgTitle
    mapping(uint => uint) taskMap;// taskTitle to index in tasks with orgTitle
    mapping(uint => uint) propMap;// propTitle to index in proposals with propTitle
    mapping(string => uint) citiMap;// citizenName to index in citizens with citizenName
    mapping(string => uint) authMap;


    constructor() public {
        state_gov = msg.sender;
        tag[msg.sender] = 1;
    }

    function registerTask(uint task_id, string memory task_title) public {
        require(msg.sender == state_gov);
        uint[] memory empArr;
        tasks.push(Task({taskId:task_id, taskTitle:task_title,numVotes:0, propId:0,status:0,is_completed: false, taskProposalsId:empArr}));
        taskMap[task_id] = tasks.length-1;
    }

    function registerDistrict(address dist_address, uint dist_Id, string memory dist_Title) public {
        require(msg.sender == state_gov);
        uint[] memory empArr;
        districts.push(District({districtAddress:dist_address,districtId: dist_Id, districtTitle:dist_Title,districtTasksId:empArr}));
        distMap[dist_Id] = districts.length - 1;
        tag[dist_address] = 2;
    }

    function passContract(uint task_id, uint dist_id) public {
        uint[] memory emp;
        contracts.push(Contract({distId: dist_id, taskId: task_id, isIssued: false, votes: 0, ProposalIds: emp}));
        districts[distMap[dist_id]].districtTasksId.push(contracts.length-1);
    }

    function registerOrganization(address org_address, uint org_Id, string memory org_title) public
    {
        require(msg.sender == state_gov);
        uint[] memory empArr;
        organizations.push(Organization({organizationAddress:org_address, organizationId:org_Id, organizationTitle: org_title,organizationProposalsId:empArr}));

        orgMap[org_Id] = organizations.length-1;
        tag[org_address] = 3;
    }

    function issueContract(uint cont_id) public {
        require(tag[msg.sender] == 2);
        contracts[cont_id].isIssued = true;
    }

    function registerProposal(uint org_Id, uint cont_Id, string memory prop_Desc, string memory prop_Title, uint cost) public {
        require(tag[msg.sender] == 3 && contracts[cont_Id].isIssued);

        proposals.push(Proposal({organizationId:org_Id, contId:cont_Id, is_awarded:false, proposalDescription:prop_Desc,proposalTitle:prop_Title, costEstimate: cost}));
        contracts[cont_Id].ProposalIds.push(proposals.length-1);


        // the current proposal has to be added to the respective task ,and organization
        organizations[orgMap[org_Id]].organizationProposalsId.push(proposals.length-1);

    }

    function winningProposal(uint cont_Id, uint prop_Id) public {
        bool pr = false;
        for (uint i = 0; i < contracts[cont_Id].ProposalIds.length; i++)
            if (contracts[cont_Id].ProposalIds[i] == prop_Id)
                pr = true;
        require(pr);
        proposals[prop_Id].is_awarded = true;
        winners[cont_Id] = prop_Id;
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
            1. Assert if the organization claiming the task has actually been awarded that task
        /




        verifyCompletion(task_id);

    }
    //*/
    function registerCitizen(address cit_address,uint cit_Id,string memory cit_Name) public
    {
        require(msg.sender == state_gov);

        citizens.push(Citizen({citizenAddress:cit_address, citizenName: cit_Name, citizenId: cit_Id}));
        citiMap[cit_Name] = citizens.length-1;
        tag[cit_address] = 4;
    }


    function taskingVote(uint cont_Id,uint vote) public
    {
        require(tag[msg.sender] == 2 || tag[msg.sender] == 4 && !voted[msg.sender]);
        /*
        TODO :
            1. Take care of case when votes are being cast for task that is not awarded yet
            2. Take care of citizen voting on the same task multiple times
        //*/
        uint weight = 1;
        if (tag[msg.sender] == 2)
            weight = 5;

        votes.push(Vote({contId:cont_Id,vote_points:weight}));

        if (vote == 1)
            contracts[cont_Id].votes += weight;
        else
            contracts[cont_Id].votes -= weight;

    }

    function verifyCompletion(uint cont_id) view public returns (bool) {
        if (contracts[cont_id].votes > 0)
            return true;
        else
            return false;
    }

    function payment (uint cont_id) public {
        if (verifyCompletion(cont_id)) {
            payments.push(Payment(organizations[proposals[winners[cont_id]].organizationId].organizationAddress, proposals[winners[cont_id]].costEstimate));
        }
    }





    //


}
