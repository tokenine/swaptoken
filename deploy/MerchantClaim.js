module.exports = async function ({ getNamedAccounts, deployments }) {
    const { deploy } = deployments
    const { deployer } = await getNamedAccounts()
    tokenA = '0xEcafC0F1E5448868A08d89fa99e1d2a0694aEe23'
    tokenB = '0x83c4CB8BEa9e049a0d8dF5F5ffC02563801E9e46'
    payTo = '0xD2aa195D683cb782685EBdaC2B76788349eF6579'
    // dev off 
    // payTo = '0x626939e224FbD56F5DE5b244dC04f8a1cEF40613'
    feeTo = '0xcD64a1fb76085F6184C1A8592f44DcF713EAD517'
  
    await deploy("MerchantClaim", {
      from: deployer,
      args: [tokenA, tokenB, payTo, feeTo],
      log: true,
      deterministicDeployment: false
    })
  }
  
  module.exports.tags = ["MerchantClaim"]
  