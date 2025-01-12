import Web3 from "web3"
import farmerAbi from "./contract/FarmerRegistration.json"
import borrowAbi from "./contract/Borrow.json"
import marketplaceAbi from "./contract/Marketplace.json"
import whitelistAbi from "./contract/whitelist.json"


let web3 = null;
let farmerContract: any = null;
let borrowContract: any = null;
let marketplaceContract: any = null;
let whitelistContract: any = null;
const farmerContractAddress: any = "0xF6548fD522dcb12d8AC126dD867A6859fCCe4507";
const borrowContractAddress: any = null;
const marketplaceContractAddress: any = "0x7FEC6e2A596b8227ABc04967B7D1F8D8EDD244f7";
if (typeof window !== "undefined" && typeof window.ethereum !== "undefined") {
   //
   web3 = new Web3(window.ethereum);
   farmerContract = new web3.eth.Contract(farmerAbi, farmerContractAddress)
   borrowContract = new web3.eth.Contract(borrowAbi, borrowContractAddress)
   marketplaceContract = new web3.eth.Contract(marketplaceAbi, marketplaceContractAddress)
   whitelistContract = new web3.eth.Contract(whitelistAbi, whitelistContract)
   // usdcContract = new web3.eth.Contract(usdcAbi, "0x036CbD53842c5426634e7929541eC2318f3dCF7e")
} else {
   //
   const provider = new Web3.providers.HttpProvider("http://rpc.testnet.citrea.xyz" as string);
   web3 = new Web3(provider);
   // web3 = new Web3(window.ethereum);
   farmerContract = new web3.eth.Contract(farmerAbi, farmerContractAddress)
   borrowContract = new web3.eth.Contract(borrowAbi, borrowContractAddress)
   marketplaceContract = new web3.eth.Contract(marketplaceAbi, marketplaceContractAddress)
   whitelistContract = new web3.eth.Contract(whitelistAbi, whitelistContract)

}

// const provider = new Web3.providers.HttpProvider("https://rpc.testnet.citrea.xyz" as string);
// web3 = new Web3(provider);
// // web3 = new Web3(window.ethereum);
// farmerContract = new web3.eth.Contract(farmerAbi, farmerContractAddress)
// borrowContract = new web3.eth.Contract(borrowAbi, borrowContractAddress)
// marketplaceContract = new web3.eth.Contract(marketplaceAbi, marketplaceContractAddress)
// whitelistContract = new web3.eth.Contract(whitelistAbi, whitelistContract)

const switchChain = async (chainId) => {
   try {
      // Convert chainId to hexadecimal
      const chainIdHex = `0x${Number(chainId).toString(16)}`

      // Request chain switch
      await window.ethereum.request({
         method: 'wallet_switchEthereumChain',
         params: [{ chainId: chainIdHex }],
      })

   } catch (error) {
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
