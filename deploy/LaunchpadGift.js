module.exports = async function ({ getNamedAccounts, deployments }) {
    const { deploy } = deployments
    const { deployer , dev} = await getNamedAccounts()

    tokenA = '0xEcafC0F1E5448868A08d89fa99e1d2a0694aEe23' // bsc testnet
    tokenB = '0x83c4CB8BEa9e049a0d8dF5F5ffC02563801E9e46' // bsc testnet
    never = '0xfff3753d511cf17baf36de1e04a6eb8eebd73358' // bsc testnet
    busd = '0xe9e7cea3dedca5984780bafc599bd69add087d56'
    dome = '0xc3a89d3EfaAb5cB5d22aD4D2792DC3d52726dC63'
    shot = '0x10638a494b05d43af25235a34ed8fd256b529d05' 
    merchant= '0xD2aa195D683cb782685EBdaC2B76788349eF6579'
    // dev off 
    // payTo = '0x626939e224FbD56F5DE5b244dC04f8a1cEF40613'
    feeTo = '0xcD64a1fb76085F6184C1A8592f44DcF713EAD517'
    await deploy("LaunchpadGift", {
      from: deployer,
      args: [tokenA, tokenB, never, never, dev, feeTo, dev],
      log: true,
      deterministicDeployment: false
    })
  }
  
  module.exports.tags = ["LaunchpadGift"]
  