// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract election {                 // this code is to implement a school election 
    
    address public ownerAdr ;
    uint8 public counter ;

    enum electionSteps {
        register ,                   // register the candidates
        vote ,                       // start votting
        end                          // get the result of election
    }

    electionSteps public step ;

    constructor(){
        ownerAdr = msg.sender ;
        step = electionSteps.register ;
    }

    struct candidate  {
        string name ;
        uint8 id ;
        uint8 votesCount ;
    }

    struct voter {
        string name ;
        bool voted ;
    }

    candidate [] candidates ;
    mapping (address => voter) voters ;

    modifier _onlyOwner() {
        require(msg.sender == ownerAdr , "only owner can execute this function");
        _;
    }

    modifier _step(electionSteps __step ){
        require( __step == step ,"false elction step ");
        _;
    }

    function ChangeStep(uint _num)public _onlyOwner {
        if (_num == 0){
            step = electionSteps.register ;
        } else if (_num == 1){
            step = electionSteps.vote ;
        } else if (_num == 2){
            step = electionSteps.end ;
        }else{

        }

    }

    function RegisterCandidate(string memory _name)public _onlyOwner _step( electionSteps.register )  {
        candidates.push(candidate(_name , counter , 0 ));
        counter++;
    }

    function Vote(string memory _name , uint8 _candidateId) public _step(electionSteps.vote)  {
        require(voters[msg.sender].voted == false,"you can only vote one time");
        
        voters[msg.sender] = voter(_name,true);
        candidates[_candidateId].votesCount++;

    }

    function GetWinner() _onlyOwner _step(electionSteps.end) public view returns(string memory , uint8){
        // I know this function has this bug ( if 2 candidates have the same votes count, it will overwrite first candidate with seccond candidate)
        uint8 winnerIndex ;
        uint8 maxVote = 0 ;
        for(uint8 i = 0 ; i < candidates.length ; i++){
            if( candidates[i].votesCount >= maxVote){   
                maxVote = candidates[i].votesCount ;
                winnerIndex = i ;
            }
        }
        return(candidates[winnerIndex].name , maxVote);                //( winner name , winner votes )
    }
}

    // the function bellow is the correct version of function GetWinner() :
    //
    // function GetWinner() _onlyOwner _step(electionSteps.end) public  returns( candidate [] memory  ,uint8 , uint ){
    //     candidate [] memory winnerCandidates ;              // used in last function
    //     // uint8 winner_i = 0;
    //     uint8 maxVote = 0 ;
    //     for(uint8 i = 0 ; i < candidates.length ; i++){
    //         if( candidates[i].votesCount > maxVote){             // I know this line has some bug
    //             maxVote = candidates[i].votesCount ;
    //            // winner_i = i ;
    //           // winnerCandidates =  candidate(candidates[i].name,candidates[i].id,candidates[i].votesCount)  ;
    //         //winnerCandidates = [candidate(candidates[i].name,candidates[i].id,candidates[i].votesCount)];
    //         //winnerCandidates = [];
    //                 candidate [] memory winnerCandidates ;              // used in last function

    //         }else if ( candidates[i].votesCount == maxVote){
    //             candidates.push(candidates[i]);
    //         }
    //     }
    //     return( winnerCandidates , maxVote , winnerCandidates.length);                //( winner name , winner votes )
    // }

