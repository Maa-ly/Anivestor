/* eslint-disable @typescript-eslint/no-explicit-any */
import Web3 from "web3"
import farmerAbi from "./contract/FarmerRegistration.json"
import borrowAbi from "./contract/Borrow.json"
import marketplaceAbi from "./contract/Marketplace.json"
import whitelistAbi from "./contract/whitelist.json"

// == Return ==
// 0: contract FarmerRegistration 0x0199f6AA5e1eCd7E7cf73434208Bd1b0a5F0C79F
// 1: contract WhiteList 0xDE651963399Da05f5d1E8dE7EE1861E3876412B2
// 2: contract MarketPlace 0xf361c83bD1A7f219aC3b52AA03954cD21A263924
// 3: contract Borrow 0xA4518eaE529bd0E9bC97bdbF079B0f4e0a74814D
// 4: contract HelperConfig 0x5aAdFB43eF8dAF45DD80F4676345b7676f1D70e3
let web3 = null;
let farmerContract: any = null;
let borrowContract: any = null;
let marketplaceContract: any = null;
let whitelistContract: any = null;
const farmerContractAddress: any = "0x0199f6AA5e1eCd7E7cf73434208Bd1b0a5F0C79F";
const borrowContractAddress: any = "0xA4518eaE529bd0E9bC97bdbF079B0f4e0a74814D";
const marketplaceContractAddress: any = "0xf361c83bD1A7f219aC3b52AA03954cD21A263924";
const whitelistContractAddress: string = "0xDE651963399Da05f5d1E8dE7EE1861E3876412B2";
if (typeof window !== "undefined" && typeof window.ethereum !== "undefined") {
   //
   web3 = new Web3(window.ethereum);
   farmerContract = new web3.eth.Contract(farmerAbi, farmerContractAddress)
   borrowContract = new web3.eth.Contract(borrowAbi, borrowContractAddress)
   marketplaceContract = new web3.eth.Contract(marketplaceAbi, marketplaceContractAddress)
   whitelistContract = new web3.eth.Contract(whitelistAbi, whitelistContractAddress)
   // usdcContract = new web3.eth.Contract(usdcAbi, "0x036CbD53842c5426634e7929541eC2318f3dCF7e")
} else {
   //
   const provider = new Web3.providers.HttpProvider("http://rpc.testnet.citrea.xyz" as string);
   web3 = new Web3(provider);
   // web3 = new Web3(window.ethereum);
   farmerContract = new web3.eth.Contract(farmerAbi, farmerContractAddress)
   borrowContract = new web3.eth.Contract(borrowAbi, borrowContractAddress)
   marketplaceContract = new web3.eth.Contract(marketplaceAbi, marketplaceContractAddress)
   whitelistContract = new web3.eth.Contract(whitelistAbi, whitelistContractAddress)

}
const switchChain = async (chainId: number) => {
   try {
      // Convert chainId to hexadecimal
      const chainIdHex = `0x${Number(chainId).toString(16)}`

      // Request chain switch
      await window.ethereum.request({
         method: 'wallet_switchEthereumChain',
         params: [{ chainId: chainIdHex }],
      })

   } catch (error: any) {
      // Error code 4902 means the chain hasn't been added to MetaMask
      if (error.code === 4902) {
         try {
            await window.ethereum.request({
               method: 'wallet_addEthereumChain',
               params: [{
                  chainId: `0x${Number(5115).toString(16)}`,
                  // Example parameters for adding a new chain
                  chainName: 'Citrea Testnet',
                  nativeCurrency: {
                     name: 'cBTC',
                     symbol: 'cBTC',
                     decimals: 18
                  },
                  rpcUrls: ['https://rpc.testnet.citrea.xyz'],
                  blockExplorerUrls: ['https://explorer.testnet.citrea.xyz']
               }]
            })
         } catch (addError) {
            console.error('Error adding chain:', addError)
         }
      }
      console.error('Error switching chain:', error)
   }
}



export { farmerContract, borrowContract, marketplaceContract, whitelistContract, switchChain }
