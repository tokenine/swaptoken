module.exports = async function ({ getNamedAccounts, deployments }) {
    const { deploy } = deployments
    const { deployer , dev} = await getNamedAccounts()
  
    await deploy("StoreID", {
      from: deployer,
      args: [dev],
      log: true,
      deterministicDeployment: false
    })
  }
  
  module.exports.tags = ["StoreID"]
  