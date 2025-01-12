import { IExecDataProtector } from '@iexec/dataprotector';
import Web3 from 'web3';


let web3Provider;
if (window == undefined) {
   web3Provider = new Web3.providers.HttpProvider('https://bellecour.iex.ec');
} else {
   web3Provider = window.ethereum;
}
// const web3Provider = new Web3.providers.HttpProvider('https://bellecour.iex.ec');
// const web3 = new Web3(web3Provider);
// const provider = web3Provider.asEIP1193Provider()

const dataProtector = new IExecDataProtector(web3Provider);
const dataProtectorCore = dataProtector.core;
const dataProtectorSharing = dataProtector.sharing;

export { dataProtectorCore, dataProtectorSharing }
// For Web3.js usage
// import { ethers, providers } from 'ethers';
// For IExecDataProtector
// const ethersProvider = new ethers.JsonRpcProvider('https://bellecour.iex.ec');