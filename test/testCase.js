const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { EDIT_DISTANCE_THRESHOLD } = require("hardhat/internal/constants");

describe("Automated Market Maker",  function () {
    let Instance;
    beforeEach(async function(){
    const tokenone= await hre.ethers.getContractFactory("tokenOne");
     tA = await tokenone.deploy(100000);
     await tA.deployed();

     const tokentwo= await hre.ethers.getContractFactory("tokenTwo");
     tB = await tokentwo.deploy(100000);
      await tB.deployed();

      const inst = await hre.ethers.getContractFactory("MarketMaker");
      Instance = await inst.deploy(tA.address,tB.address);
      [owner] =await ethers.getSigners();
})


    it("Should have 100000 token A",async function(){
        //await Instance.deployed();

       

        expect(await tA.balanceOf(owner.address)==100000);

    } )
    it("Should have 100000 token B",async function(){
      //await Instance.deployed();

     

      expect(await tB.balanceOf(owner.address)==100000);

  } )
  it("Should be able to add liquidity",async function(){
    await Instance.deployed();
    await tA.approve(Instance.address, 10000);
    await tB.approve(Instance.address, 10000);

   await Instance.addLiquidity(100,100);

    expect(await tA.balanceOf(Instance.address)==100 && await tB.balanceOf(Instance.address)==100);

} )
   /* it("Should set current Beneficiary of the pool", async function(){
        await Instance.deployed;
        await Instance.currentBeneficiary(contributer2.address);

        expect(Instance.recepient()==contributer2.address);
    })
    it("Owner should be able to set the time that the Pool will take",async function(){
        const time = 5*24;
      const timeinSecs = time*3600;

      const current = Math.floor(Date.now() / 1000);
      finishtime = current+timeinSecs;

        await Instance.deployed();
        await Instance.FinishTime(finishtime);

        expect(await Instance.endTime()==finishtime);
    })  */
})