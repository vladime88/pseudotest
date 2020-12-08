const Web3 = require('web3');
// const Provider = require('@truffle/hdwallet-provider');
const PseudoStorage = require('./build/contracts/PseudoStorage.json');
const address = '0x614dac7B79FdA3527879DD444DEe5d53E4D604e6';
const privateKey = '2e7d9509f28846413cff90e4d9309c28be0120bad0910cf5e6a999ca66324b9f';
const infuraUrl = 'https://rinkeby.infura.io/v3/a0e1e5620b164b1a9665f0604ba3137b';

const init2 = async () => {
  const web3 = new Web3(infuraUrl);
  const networkId = await web3.eth.net.getId();
  const pseudoStorage = new web3.eth.Contract(PseudoStorage.abi, PseudoStorage.networks[networkId].address);
  web3.eth.accounts.wallet.add(privateKey);

  const tx = pseudoStorage.methods.store(1);
  const gas = await tx.estimateGas({ from: address });
  const gasPrice = await web3.eth.getGasPrice();
  const data = tx.encodeABI();
  const nonce = await web3.eth.getTransactionCount(address);
  const txData = {
    from: address,
    to: pseudoStorage.options.address,
    data: data,
    // value: 100 * 10 ** 18,
    gas,
    gasPrice,
    nonce,
    chain: 'rinkeby',
    hardfork: 'istanbul',
  };

  console.log(`Old pseudo value: ${await pseudoStorage.methods.pseudo().call()}`);
  const receipt = await web3.eth.sendTransaction(txData);
  console.log(`Transaction hash: ${receipt.transactionHash}`);
  console.log(`New pseudo value: ${await pseudoStorage.methods.pseudo().call()}`);
  console.log(`New nonce number: ${await web3.eth.getTransactionCount(address)}`);
};

init2();
