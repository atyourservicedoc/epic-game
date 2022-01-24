const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
    const gameContract = await gameContractFactory.deploy(
        ["Agumon", "Greymon", "MetalGreymon", "Wargreymon", "Veemon", "ExVeemon", "AeroVeedramon", "UlforceVeedramon", "Flamemon", "Agunimon", "BurningGreymon", "Aldamon", "Guilmon", "Growlmon", "WarGrowlmon", "Gallantmon"],       // Names
        ["https://i.imgur.com/Pzzn33d.png",
        "https://i.imgur.com/ybbtrSD.png",
        "https://i.imgur.com/xYuXKRd.png",
        "https://i.imgur.com/U6msxHL.png",
        "https://i.imgur.com/wLXlvb8.png",
        "https://i.imgur.com/78GZq79.png",
        "https://i.imgur.com/t6lRsuw.png",
        "https://i.imgur.com/KtkmcDN.png",
        "https://i.imgur.com/PBfvwGH.png",
        "https://i.imgur.com/ZpHR7WY.png",
        "https://i.imgur.com/zjYIsuE.png",
        "https://i.imgur.com/FmrIGjD.png",
        "https://i.imgur.com/e654YTt.png",
        "https://i.imgur.com/ipLiiYz.png",
        "https://i.imgur.com/yp8UU09.png",
        "https://i.imgur.com/yVtzmQy.png"],
        [100, 200, 300, 400,100, 200, 300, 400,100, 200, 300, 400,100, 200, 300, 400],                    // HP values
        [100, 125, 150, 175,100, 125, 150, 175,100, 125, 150, 175,100, 125, 150, 175,],
        [3,4,5,6,3,4,5,6,3,4,5,6,3,4,5,6], "Diaboromon", "https://i.imgur.com/Sf9HWGQ.png", 10000, 50    );
    await gameContract.deployed();
    console.log("Contract deployed to:", gameContract.address);

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
