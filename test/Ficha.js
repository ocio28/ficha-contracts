const Ficha = artifacts.require('Ficha')

const Decimals = 10 ** 18
const TotalSupply = 10000 * Decimals

const R = (s, v) => s.replace('{}', v)
const S = (v) => web3.toAscii(v).replace(/\u0000/g, '')

contract("Ficha", accounts => {
  const owner = accounts[0]
  let contract = null

  it('should be a Ficha', async () => {
    contract = await Ficha.deployed()

    let name = await contract.name.call()
    let symbol = await contract.symbol.call()
    let decimals = await contract.decimals.call()

    assert.equal(name, 'Ficha')
    assert.equal(symbol, 'FHA')
    assert.equal(decimals, '18')
  })

  it(R('should have {} total supply', TotalSupply), async () => {
    let totalSupply = await contract.totalSupply.call()

    assert.equal(totalSupply, TotalSupply)
  })

  it(R('should be owner of all tokens {}', owner), async () => {
    let balance = await contract.balanceOf(owner)

    assert.equal(balance, TotalSupply)
  })

  it('should transfer 10 tokens from owner', async () => {
    let account = accounts[1]

    await contract.transfer(account, 10 * Decimals)

    let balance = await contract.balanceOf(account)
    assert.equal(balance, 10 * Decimals)
  })

  it('should change nickname', async () => {
    await contract.changeNickname('Develop')
    const nickname = await contract.ownerNickname.call(owner)

    assert.equal(S(nickname), 'Develop')
  })
})
