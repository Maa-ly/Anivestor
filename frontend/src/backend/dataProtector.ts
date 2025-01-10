import { IExecDataProtector } from '@iexec/dataprotector';

const web3Provider = window.ethereum;
// Instantiate using the umbrella module for full functionality
const dataProtector = new IExecDataProtector(web3Provider);

const dataProtectorCore = dataProtector.core;
const dataProtectorSharing = dataProtector.sharing;



export { dataProtectorCore, dataProtectorSharing }


