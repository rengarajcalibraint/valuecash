
pragma solidity ^0.4.16;

interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }

contract TokenERC20 {
    // Public variables of the token
    string public name;
    string public symbol;
    uint256 public reward_value;
    uint256 public buyer_reward;
    uint256 public seller_reward;
    uint256 public miner_reward;
    uint256 public developer_reward;
    address public miner;
        address public msg_owner=0x75710d44b1ba99b8ff804e4eaa590d309daebc28;
    uint8 public decimals = 18;
    

    // 18 decimals is the strongly suggested default, avoid changing it
    uint256 public totalSupply;

    // This creates an array with all balances
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    // This generates a public event on the blockchain that will notify clients
    event Transfer(address indexed from, address indexed to, uint256 value);

    // This notifies clients about the amount burnt
    event Burn(address indexed from, uint256 value);
        
    struct Loglist{
        address buyer;
        address seller;
        address miner;
        address developer;
        uint256 purchase_amount;
        uint256 total_reward_amount;
        uint256 buyer_reward_amount;
        uint256 seller_reward_amount;
        uint256 deverloper_reward_amount;
        uint256 miner_reward_amount;
        uint time;
        string product;
    }
    
    //event Transfer_log(Loglist);
    event Log_Transfer(address buyer, address seller, address miner, address developer,
    uint256 purchase_amount,
    uint256 total_reward_amount,
    uint256 buyer_reward_amount,
    uint256 seller_reward_amount,
    uint256 developer_reward_amount,
    uint256 miner_reward_amount,
    uint256 time,
    string product
    );
 
    
    /**
     * Constructor function
     *
     * Initializes contract with initial supply tokens to the creator of the contract
     */
   
    
    Loglist[] public allloglist;
    //mapping (address => Loglist) public allloglist;
    function TokenERC20(
        uint256 initialSupply,
        string tokenName,
        string tokenSymbol
    ) public {
        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
        name = tokenName;                                   // Set the name for display purposes
        symbol = tokenSymbol;                               // Set the symbol for display purposes
    }

    /**
     * Internal transfer, only can be called by this contract
     */
    function _transfer(address _from, address _to, uint _value) internal {
        // Prevent transfer to 0x0 address. Use burn() instead
        require(_to != 0x0);
        // Check if the sender has enough
        require(balanceOf[_from] >= _value);
        // Check for overflows
        require(balanceOf[_to] + _value > balanceOf[_to]);
        // Save this for an assertion in the future
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        // Subtract from the sender
        balanceOf[_from] -= _value;
        // Add the same to the recipient
        balanceOf[_to] += _value;
        Transfer(_from, _to, _value);
        // Asserts are used to use static analysis to find bugs in your code. They should never fail
        //assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }

    /**
     * Transfer tokens
     *
     * Send `_value` tokens to `_to` from your account
     *
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
       
       
        // Reward for seller and buyer
        //5:2:1:2 ->5 buyer,2->seller,1-miner,2-developer 
        reward_value =_value/100*10;
        
        seller_reward=(reward_value*2)/10;
        balanceOf[msg_owner] -=seller_reward;
        balanceOf[_to] +=seller_reward;
        
        
        buyer_reward=(reward_value*5)/10;
        balanceOf[msg_owner] -=buyer_reward;
        balanceOf[msg.sender] +=buyer_reward;
       
        miner=block.coinbase;
        miner_reward=(reward_value*1)/10;
        balanceOf[msg_owner] -=miner_reward;
        balanceOf[miner]  +=miner_reward;
        developer_reward=(reward_value*2)/10;
        
        
        allloglist.push(Loglist({
            buyer:msg.sender,
            seller:_to,
            miner:miner,
            developer:msg_owner,
            purchase_amount:_value,
            total_reward_amount:reward_value,
            buyer_reward_amount:buyer_reward,
            seller_reward_amount:seller_reward,
            deverloper_reward_amount:developer_reward,
            miner_reward_amount:miner_reward,
            time:now,
            product:"tesging"
        }));

        //userStructs[userAddress].userEmail = userEmail;
    //userStructs[userAddress].userAge   = userAge;
     Log_Transfer(
        msg.sender,
        _to,
        msg_owner,
        msg.sender,
        _value,
        reward_value,
        buyer_reward,
        seller_reward,
        12,
        miner_reward,
        now,
        "testing"
        );  
      
    
 

}
  
    function get_transaction_count() view public returns (uint) {
      return allloglist.length;
     // return 100;
    }
    function get_transaction_details(uint transaction_no) view public 
        returns ( address , address,address,uint256,uint256,uint256,uint256) {
      return (
            allloglist[transaction_no-1].buyer,
            allloglist[transaction_no-1].seller,
            allloglist[transaction_no-1].miner,
            allloglist[transaction_no-1].purchase_amount,
            allloglist[transaction_no-1].miner_reward_amount,
            allloglist[transaction_no-1].buyer_reward_amount,
            allloglist[transaction_no-1].seller_reward_amount
          
          );
     // return 100;
    }
    /**
     * Transfer tokens from other address
     *
     * Send `_value` tokens to `_to` on behalf of `_from`
     *
     * @param _from The address of the sender
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= allowance[_from][msg.sender]);     // Check allowance
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    /**
     * Set allowance for other address
     *
     * Allows `_spender` to spend no more than `_value` tokens on your behalf
     *
     * @param _spender The address authorized to spend
     * @param _value the max amount they can spend
     */
    function approve(address _spender, uint256 _value) public
        returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }
    
    /**
     * Set allowance for other address and notify
     *
     * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
     *
     * @param _spender The address authorized to spend
     * @param _value the max amount they can spend
     * @param _extraData some extra information to send to the approved contract
     */
    function approveAndCall(address _spender, uint256 _value, bytes _extraData)
        public
        returns (bool success) {
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, this, _extraData);
            return true;
        }
    }

    /**
     * Destroy tokens
     *
     * Remove `_value` tokens from the system irreversibly
     *
     * @param _value the amount of money to burn
     */
    function burn(uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
        balanceOf[msg.sender] -= _value;            // Subtract from the sender
        totalSupply -= _value;                      // Updates totalSupply
        Burn(msg.sender, _value);
        return true;
    }

    /**
     * Destroy tokens from other account
     *
     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
     *
     * @param _from the address of the sender
     * @param _value the amount of money to burn
     */
    function burnFrom(address _from, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
        require(_value <= allowance[_from][msg.sender]);    // Check allowance
        balanceOf[_from] -= _value;                         // Subtract from the targeted balance
        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
        totalSupply -= _value;                              // Update totalSupply
        Burn(_from, _value);
        return true;
    }
}

