import { IExecWeb3mail } from '@iexec/web3mail';
import Web3 from 'web3';

let web3Provider
if (typeof window !== "undefined" && typeof window.ethereum !== "undefined") {
   web3Provider = window.ethereum;
} else {
   web3Provider = new Web3.providers.HttpProvider('https://bellecour.iex.ec');
}
// instantiate
const web3mail = new IExecWeb3mail(web3Provider);

export { web3mail }