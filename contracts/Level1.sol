pragma solidity ^0.4.25;

contract Level1 {
    address public state_gov;

    string public addr = '0x0';

    struct Task {
        string desc;
        uint status;
    }


    struct District {
        address add;
        string name;
        uint[] prj;



    }

    struct Contracts {
        uint taskID;
        address distADD;
        }

    mapping(string => uint) district;

    District[] public dists;
    Task[] public tasks;
    Contracts[] public conts;



    function getTaskId(uint idx) public view returns(uint)
    {
        return conts[idx].taskID;
    }

    function getDistAddress(uint idx) public view returns(address)
    {
            return conts[idx].distADD;
    }

    //Getters for Districts
    function getAddress(uint idx) public view returns(address)
    {
        return dists[idx].add;
    }

    function getName(uint idx) public view returns(string)
    {
        return dists[idx].name;
    }




    // Getters for Tasks
    function getDescription(uint idx) public view returns(string)
    {
        return tasks[idx].desc;
    }

    function getStatus(uint idx) public view returns (uint)
    {
        return tasks[idx].status;
    }


    constructor() public {
        state_gov = msg.sender;
    }

    function addTask(string memory d) public {
        require(msg.sender == state_gov);
        tasks.push(Task({desc: d, status: 0}));
    }

    function registerDistrict(address a, string memory n) public {
        require(msg.sender == state_gov);
        uint[] memory emp;
        dists.push(District({add: a, name: n, prj: emp}));
        district[n] = dists.length - 1;
        addr = n;
    }

    function issueContract(string memory n, uint tsk) public {
        require(msg.sender == state_gov);
        conts.push(Contracts({taskID: tsk, distADD: dists[district[n]].add}));
        District storage d = dists[district[n]];
        d.prj.push(tsk);
        if (dists[district[n]].prj.length == 0)
            revert();
    }

    function getProjects(uint districtId) public view returns (uint[]) {
            return dists[districtId].prj;
    }

}
