# Ethereum Track: Blockchain to target the problem of corruption

>> Video Links - 
https://www.youtube.com/watch?v=5qb7n_Tvdwc (Overview of Dapp functionality using Remix IDE)
https://www.youtube.com/watch?v=qC6JcwVnQNM (Frontend of Dapp using ganache and truffle)

> “Corruption, embezzlement, fraud, these are all characteristics which exist everywhere. It is regrettably the way human 
> nature functions, whether we like it or not. What successful economies do is keep it to a minimum. No one has ever eliminated 
> any of that stuff.” 
##        “…until now.” -Blockchain

### &#x1F534; PROBLEM 
Many times we have witnessed that the money issued by the government is often misused.
It hardly reaches its destination. The government transfers money to the intermediaries to
complete the task but no one knows where that money is finally used. Most of the times it
ends up in officials personal account as black money.
We have also seen that many times when a citizen go for completion of their work, the
officials demand bribe to do that task. This also adds up in the total corruption in the
country.
So our idea will eradicate these two problems of money laundering and bribery.

### &#x1F535; SOLUTION
In the current age, there is corruption in every government sector. The problem persists not
only in India but it has become a major global issue. Till now there was no particular method
that guaranteed to tackle this problem. But now after the introduction of Blockchain
technology in the world, the problem seems to get solved. For the first time, we may actually
have a viable solution to rampant political and economic corruption in the world.
Blockchain has two distinctive features that make it a potent tool against corruption. First, it
**provides an unprecedented level of security of the information and the integrity of records it
manages, guaranteeing their authenticity**. It eliminates opportunities for falsification and
the risks associated with having a single point of failure in the management of data.
Second, **blockchain provides a transparent and decentralised system to record a sequence
of transactions, or “blocks”. Blockchain creates an immutable trail of transactions, allowing
for the full traceability of every transaction**.
Blockchain is particularly suited to fight corruption in the registry of assets and the tracking
of transactions such as procurement processes. By leveraging a shared and distributed
database of ledgers, it eliminates the need for intermediaries, cutting red-tape and reducing
discretionality.
# WORKFLOW
![workflow](https://github.com/harsh0240/Corruption/blob/master/Corruption%20(5).png)
For the solution of first problem of eradicating the case of money laundering we will
eliminate the transferring of funds through mediators. We will develop a system in which
the government will directly transact the funds to the developer of the project and every
action will be published on blockchain network so that it is transparent for public.
Let us understand the approach taking an example. Consider a case where the central
government declares to open schools in cities. Below are the steps being followed to
complete the task :
</br>
●   First the central government will ask the state governments to provide with the list of
companies/organizations they have selected to provide the task and the details of
selecting that organization particularly.
In this step the list and details of selecting the organization will be made public
on the blockchain network so that everyone can look which organization has been
assigned the task and all the details.
</br>
●   For selecting the company, the state government will issue a tender with deadline for
working on the task publically. Interested companies will provide the money and time
they require to accomplish the given task.
Now the state government will choose the best option among them and
publically issue the details of selection of organization.
</br>
●   Now after scrutinizing the details of selected organizations, the organization will start
working on the project and the central government will issue a contract on the
network providing the funds directly to that company.
The citizens of that area will also be able to review the work of the company
and provide a feedback. If the public says that no work is being done by the company
then the government can cancel the issued contract and take action on that
company.





# Setup
- Clone this repo
- Install latest version of [NodeJS](https://nodejs.org/en/)
- Install `truffle` globally using `npm install -g truffle` 
- Install Ganache from truffle  
- Open ganache in a terminal which will emulate the blockchain on HTTP://127.0.0.1:8545
*  Open another terminal/cmd and navigate to current working directory and again, cd into 'backend'. `cd backend`. You will now need to compile solidity contracts, migrate them to your Ethereum Server before front end is started.
    * `truffle compile` (On Windows 10, `truffle.cmd compile`)
    * `truffle migrate` (On Windows 10, `truffle.cmd migrate`)
    * `truffle console` (On Windows 10, `truffle.cmd console`)
        * Within console, we need the address (SHA256) address of 'Gov.sol' & 'Customer.Sol' solidity contracts.
        * We can get that using `Gov.address`
            * Copy the SHA256 string safely. We will need this later. [TAG - Supplier SHA256]
        * Get Customer contract address using `Customer.address` 
            * Copy the SHA256 safely, We will need this later. [TAG - Customer SHA256]

* Now, lets get the front end functional!
* Open the file named 'EthereumSetup.js'
    * Copy `Gov.address` from [TAG - Supplier SHA256] step to line (`let GovAddress = '<YOUR SHA256 Address for Gov Contract>'`)
    * Copy `CustomerAddress` from [TAG - Customer SHA256] step to line (`let customerAddress = '<YOUR SHA256 Address for Customer Contract>').
    * Save file `EthereumSetup.js`
* Open a new terminal/cmd and navigate to current working directory
* cd into 'GovFrontend'. `cd Govfrontend` 
* `npm install`
* `npm start` to bring the Customer front end to life!
* cd into 'CustomerFrontend'. `cd Custometfrontend` 
* `npm install`
* `npm start` to bring the Customer front end to life!



