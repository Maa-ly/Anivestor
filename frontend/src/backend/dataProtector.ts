import { IExecDataProtector } from '@iexec/dataprotector';
import Web3 from 'web3';


let web3Provider;
if (typeof window !== "undefined" && typeof window.ethereum !== "undefined") {
   web3Provider = window.ethereum;
} else {
   web3Provider = new Web3.providers.HttpProvider('https://bellecour.iex.ec');
}
const dataProtector = new IExecDataProtector(web3Provider);
const dataProtectorCore = dataProtector.core;
const dataProtectorSharing = dataProtector.sharing;

export { dataProtectorCore, dataProtectorSharing }
// For Web3.js usage
// import { ethers, providers } from 'ethers';
// For IExecDataProtector
// const ethersProvider = new ethers.JsonRpcProvider('https://bellecour.iex.ec');