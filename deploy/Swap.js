 module.exports = async function ({ getNamedAccounts, deployments }) {
  const { deploy } = deployments
  const { deployer } = await getNamedAccounts()
  tokenA = '0xf2b4f7adb0bc8fa6aa8e8efa52101a341b810212'
  tokenB = '0xebec0fb5bedcd75800d40b07cca7978dba14bf5a'
  payTo = '0xD2aa195D683cb782685EBdaC2B76788349eF6579'

  await deploy("TokenineSwap", {
    from: deployer,
    args: [tokenA, tokenB, payTo],
    log: true,
    deterministicDeployment: false
  })
}

module.exports.tags = ["TokenineSwap"]
