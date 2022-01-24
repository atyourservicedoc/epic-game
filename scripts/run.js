const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
    const gameContract = await gameContractFactory.deploy(
        ["Agumon", "Greymon", "MetalGreymon", "Wargreymon", "Veemon", "ExVeemon", "AeroVeedramon", "UlforceVeedramon", "Flamemon", "Agunimon", "BurningGreymon", "Aldamon", "Guilmon", "Growlmon", "WarGrowlmon", "Gallantmon"],       // Names
        ["https://static.wikia.nocookie.net/digimon/images/6/68/Agumon_b.jpg/revision/latest/scale-to-width-down/320?cb=20170210150934",
        "https://static.wikia.nocookie.net/digimon/images/5/56/Greymon_b.jpg/revision/latest/scale-to-width-down/320?cb=20170226001958",
        "https://static.wikia.nocookie.net/digimon/images/c/c4/MetalGreymon_%28Vaccine%29_b.jpg/revision/latest/scale-to-width-down/320?cb=20120413034532",
        "https://static.wikia.nocookie.net/digimon/images/4/49/WarGreymon_b.jpg/revision/latest/scale-to-width-down/320?cb=20090127185540",
        "https://static.wikia.nocookie.net/digimon/images/1/1b/Veemon_b.jpg/revision/latest/scale-to-width-down/320?cb=20130402185900",
        "https://static.wikia.nocookie.net/digimon/images/0/03/ExVeemon_b.jpg/revision/latest/scale-to-width-down/320?cb=20100924032923",
        "https://static.wikia.nocookie.net/digimon/images/8/80/AeroVeedramon_b.jpg/revision/latest/scale-to-width-down/320?cb=20111125042005",
        "https://static.wikia.nocookie.net/digimon/images/d/d1/UlforceVeedramon_b.jpg/revision/latest/scale-to-width-down/320?cb=20150306032451",
        "https://static.wikia.nocookie.net/digimon/images/c/cf/Flamemon_b.jpg/revision/latest/scale-to-width-down/320?cb=20130315030944",
        "https://static.wikia.nocookie.net/digimon/images/f/f1/Agunimon_b.jpg/revision/latest/scale-to-width-down/320?cb=20171127121610",
        "https://static.wikia.nocookie.net/digimon/images/6/6a/BurningGreymon_b.jpg/revision/latest/scale-to-width-down/320?cb=20131206023027",
        "https://static.wikia.nocookie.net/digimon/images/c/cf/Aldamon_b.jpg/revision/latest/scale-to-width-down/320?cb=20120803020611",
        "https://static.wikia.nocookie.net/digimon/images/a/a1/Guilmon_b.jpg/revision/latest/scale-to-width-down/320?cb=20130402191207",
        "https://static.wikia.nocookie.net/digimon/images/7/74/Growlmon_b.jpg/revision/latest/scale-to-width-down/320?cb=20090205055501",
        "https://static.wikia.nocookie.net/digimon/images/a/ab/WarGrowlmon_b.jpg/revision/latest/scale-to-width-down/320?cb=20090128171350",
        "https://static.wikia.nocookie.net/digimon/images/c/c5/Gallantmon_b.jpg/revision/latest/scale-to-width-down/320?cb=20100501172113"],
        [100, 200, 300, 400,100, 200, 300, 400,100, 200, 300, 400,100, 200, 300, 400],                    // HP values
        [100, 125, 150, 175,100, 125, 150, 175,100, 125, 150, 175,100, 125, 150, 175,],
        [3,4,5,6,3,4,5,6,3,4,5,6,3,4,5,6], "Diaboromon", "https://static.wikia.nocookie.net/digimon/images/d/dd/Diaboromon_b.jpg/revision/latest/scale-to-width-down/320?cb=20081009025602", 10000, 50    );
    await gameContract.deployed();
    //console.log("Contract deployed to:", gameContract.address);

    let txn;
    txn = await gameContract.mintCharacterNFT(2);
    await txn.wait();

    txn = await gameContract.attackBoss();
    txn = await gameContract.attackBoss();
    //await txn.wait();

    let returnedTokenUri = await gameContract.tokenURI(1);
    //console.log("Token URI:", returnedTokenUri);
}

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
}

runMain()
