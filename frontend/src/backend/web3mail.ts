import { IExecWeb3mail } from '@iexec/web3mail';
import Web3 from 'web3';

let web3Provider
if (window == undefined) {
   web3Provider = new Web3.providers.HttpProvider('https://bellecour.iex.ec');
} else {
   web3Provider = window.ethereum;
}
// const web3 = new Web3(web3Provider);
// instantiate
const web3mail = new IExecWeb3mail(web3Provider);

export { web3mail }