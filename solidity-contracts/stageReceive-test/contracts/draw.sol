// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

interface TestToken {
  function transferFrom (address from ,address to ,uint amount) external;
}

contract Draw{
  address testTokenAddress;
  uint receiveAmount;
  uint256 currentTime;
  uint256 startTime;
  uint receiptRatio;
  uint ThreeMonthSeconds = 7776000;
  uint oneMonthSeconds = 2592000;
  struct receiveInformation{
    uint amount;
    uint stage;
  }
  mapping (address=>receiveInformation) public receiveData;
  constructor(uint256 _startTime,address _testTokenAddress) {
    startTime = _startTime;//开始时间
    testTokenAddress = _testTokenAddress;//测试ERC20代币合约地址
  }
  //设置领取mapping映射
  function setReceiveData(address[] calldata addressList,uint256 amount) external returns(bool data){
    uint addressListLength = addressList.length;
    for(uint i;i<addressListLength;i++){
      receiveData[addressList[i]].amount = amount;
      receiveData[addressList[i]].stage = 0;
    }
    return true;
  }

  //查找领取阶段
  function receiveStage(address accountAddress) public view returns(uint amount){
    return receiveData[accountAddress].stage;
  }
  // 查找账户可领取数量
  function receiveAccountAmount(address accountAddress) public view returns(uint amount){
    return receiveData[accountAddress].amount;
  }
  // 领取DFI
  function receiveDFI(address accountAddress) external {
    currentTime = block.timestamp * 1000;//当前时间
    require(currentTime > startTime,'not the start time');
    require(accountAddress != 0x0000000000000000000000000000000000000000,'Please enter the correct account address');

    if(currentTime >= startTime + ThreeMonthSeconds && currentTime <  startTime + ThreeMonthSeconds + oneMonthSeconds){
      receiveAmount = receiveData[accountAddress].amount * 20/100;
      receiveData[accountAddress].stage = 1;
    }
    if(currentTime >= startTime + ThreeMonthSeconds + oneMonthSeconds && currentTime < startTime + ThreeMonthSeconds + oneMonthSeconds * 2){
      if(receiveData[accountAddress].stage == 0){
        receiveAmount = receiveData[accountAddress].amount * 40/100 ;
      }else{
        receiveAmount = receiveData[accountAddress].amount * 20/100;
      }
      receiveData[accountAddress].stage = 2;
    }
    if(currentTime >= startTime + ThreeMonthSeconds + oneMonthSeconds * 2 && currentTime < startTime + ThreeMonthSeconds + oneMonthSeconds *3){
      if(receiveData[accountAddress].stage == 0){
        receiveAmount = receiveData[accountAddress].amount * 60/100;
      }else if(receiveData[accountAddress].stage == 1){
        receiveAmount = receiveData[accountAddress].amount * 40/100;
      }else{
        receiveAmount = receiveData[accountAddress].amount * 20/100;
      }
      receiveData[accountAddress].stage = 3;
    }
    if(currentTime >= startTime + ThreeMonthSeconds + oneMonthSeconds * 3 && currentTime < startTime + ThreeMonthSeconds + oneMonthSeconds * 4){
      if(receiveData[accountAddress].stage == 0){
        receiveAmount = receiveData[accountAddress].amount * 80/100;
      }else if(receiveData[accountAddress].stage == 1){
        receiveAmount = receiveData[accountAddress].amount * 60/100;
      }else if(receiveData[accountAddress].stage == 2){
        receiveAmount = receiveData[accountAddress].amount * 40/100;
      }else{
        receiveAmount = receiveData[accountAddress].amount * 20/100;
      }
      receiveData[accountAddress].stage = 4;
    }
    if(currentTime >= startTime + ThreeMonthSeconds + oneMonthSeconds * 4 && currentTime < startTime + ThreeMonthSeconds + oneMonthSeconds * 5){
      if(receiveData[accountAddress].stage == 0){
        receiveAmount = receiveData[accountAddress].amount * 100/100;
      }else if(receiveData[accountAddress].stage == 1){
        receiveAmount = receiveData[accountAddress].amount * 80/100;
      }else if(receiveData[accountAddress].stage == 2){
        receiveAmount = receiveData[accountAddress].amount * 60/100;
      }else if(receiveData[accountAddress].stage == 3){
        receiveAmount = receiveData[accountAddress].amount * 40/100;
      }else{
        receiveAmount = receiveData[accountAddress].amount * 20/100;
      }
      receiveData[accountAddress].stage = 5;
    }

    TestToken contractAddress = TestToken(testTokenAddress);
    contractAddress.transferFrom(msg.sender, accountAddress, receiveAmount);
  }
}
