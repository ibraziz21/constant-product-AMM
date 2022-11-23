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
})


    it("Owner should be able to set pool amount and max participants",async function(){
        await Instance.deployed();

       

        expect(await Instance.contributionAmt()==amount && await Instance.maxParticipants()==maxParticipant);

    } )
    it("Should set current Beneficiary of the pool", async function(){
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
    })
})