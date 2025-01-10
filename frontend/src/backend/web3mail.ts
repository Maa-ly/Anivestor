import { IExecWeb3mail } from '@iexec/web3mail';

const web3Provider = window.ethereum;
// instantiate
const web3mail = new IExecWeb3mail(web3Provider);

export { web3mail }