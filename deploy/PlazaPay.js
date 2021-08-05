module.exports = async function ({ getNamedAccounts, deployments }) {
    const { deploy } = deployments
    const { deployer , dev} = await getNamedAccounts()
    //
    tokenA = '0xEcafC0F1E5448868A08d89fa99e1d2a0694aEe23'
    busd = '0xe9e7cea3dedca5984780bafc599bd69add087d56'
    md = '0x9c882a7004D4bB7E5fa77856625225EA29619323' // BKC
    payTo = '0xD2aa195D683cb782685EBdaC2B76788349eF6579'
    // dev off 
    // payTo = '0x626939e224FbD56F5DE5b244dC04f8a1cEF40613'
    feeTo = '0xcD64a1fb76085F6184C1A8592f44DcF713EAD517'
  
    await deploy("PlazaPay", {
      from: deployer,
      args: [md, payTo, feeTo, dev],
      log: true,
      deterministicDeployment: false
    })
  }
  
  module.exports.tags = ["PlazaPay"]
  