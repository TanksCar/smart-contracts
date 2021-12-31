const receiveDFIToken = artifacts.require('draw');
const ERC20TestToken = artifacts.require('testERC20')

let startTime = 1639376616629;
let currentTime = new Date().getTime()
let setExtensionTime = new Date().getTime()+1000000;

let ERC20Token = null;
let testToken = null;
let nullToken = null;
let ERC20TokenAddress = null;

contract('ReceiveDFI',accounts=>{
  before('Deploy standard ERC20 contracts',async ()=>{
    ERC20Token = await ERC20TestToken.new()
    .catch(_=>{
      return null
    })
    ERC20TokenAddress = ERC20Token.address;
    let totalSupply =await ERC20Token.totalSupply()
    console.log(`${totalSupply}` )
    assert.isNotNull(ERC20TokenAddress,`deploy failed: ${ERC20Token}`)
  })

  it('Deploy ReceiveDFI contract ',async ()=>{
    testToken = await receiveDFIToken.new(startTime,ERC20TokenAddress)
      .catch(_=>{
        return null
      })
    assert.isNotNull(testToken,`deploy failed :${testToken}`)
  })

  it('Deploying the ReceiveDFI contract, lack of parameters',async ()=>{
    nullToken = await receiveDFIToken.new(startTime)
      .catch(_=>{
        return null
      })
    assert.equal(nullToken,null,`deploy failed : ${nullToken}`)
  })

  it('Set the address and quantity of DFI users that can be collected',async ()=>{
    let addressData = ["0xd49c38C6CBaCc98444930C4524Dff73e67cA2e39","0xd49c38C6CBaCc98444930C4524Dff73e67cA2e39"]
    let setReceiveData = await testToken.setReceiveData(addressData,100)
      .catch(_=>{
        return null
      });
    assert.isNotNull(setReceiveData,`Set up users who can receive DFI failed :${setReceiveData}`)
  })
  
  it('Query the user claim stage',async ()=>{
    let receiveStage = await testToken.receiveStage('0xd49c38C6CBaCc98444930C4524Dff73e67cA2e39')
    assert.equal(receiveStage,0,`Failed in the user claim phase:${receiveStage}`)
  })

  it('Users who are not on the claim list read the claim phase',async ()=>{
    let noReceiveStage = await testToken.receiveStage('0xd49c38C6CBaCc98444930C4524Dff73e67cA2e39')
    assert.equal(noReceiveStage,0,`Failed in the user claim phase:${noReceiveStage}`)
  })

  it('not the start time Receive DFI',async ()=>{
    let testNotStartTimeToken = await receiveDFIToken.new(JSON.stringify(setExtensionTime) ,'0x95Acc35cA9087aCF4c165346291a429D541Fa5EA')
      .catch(_=>{
        return null
      })
    let receiveDFI = await testNotStartTimeToken.receiveDFI('0xd49c38C6CBaCc98444930C4524Dff73e67cA2e39').catch(_=>{
      return "not the start time"
    })
    assert.equal(receiveDFI,'not the start time',`Failed in the user claim phase:${receiveDFI}`)
  })

  it('The test receiving account address is 0',async ()=>{
    let receiveDFI = await testToken.receiveDFI('0x0000000000000000000000000000000000000000').catch(_=>{
      return "Please enter the correct account address"
    })
    assert.equal(receiveDFI,'Please enter the correct account address',`Failed in the user claim phase:${receiveDFI}`)
  })

  it('Successfully receive DFI',async ()=>{
    let receiveDFI = await testToken.receiveDFI('0xd49c38C6CBaCc98444930C4524Dff73e67cA2e39').catch((res)=>{
      return null
    })
    let receiveStage = await testToken.receiveStage('0xd49c38C6CBaCc98444930C4524Dff73e67cA2e39')
    console.log(`${receiveStage}`)
    assert.isNotNull(receiveDFI,`Failed in the user claim phase:${receiveDFI}`)
  })
})