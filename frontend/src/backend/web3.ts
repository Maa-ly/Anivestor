import Web3 from "web3"
import farmerAbi from "./contract/FarmerRegistration.json"
import borrowAbi from "./contract/Borrow.json"
import marketplaceAbi from "./contract/Marketplace.json"
import whitelistAbi from "./contract/whitelist.json"


// Return ==
// 0: contract FarmerRegistration 0xBFDC5fBd312b42FE3D1D738d4493E1C45b3cC4F8
// 1: contract WhiteListDeployer 0x99A24893033B99fA29eF575F2236351ba31863c8
// 2: contract MarketPlace 0xA32C3b7Bc0D56815c330e770294dDDE11E821C52
// 3: contract Borrow 0xfb0be8721F277746D853CC95e9b66F074C756756
// 4: contract HelperConfig 0x5aAdFB43eF8dAF45DD80F4676345b7676f1D70e3
let web3 = null;
let farmerContract: any = null;
let borrowContract: any = null;
let marketplaceContract: any = null;
let whitelistContract: any = null;
const farmerContractAddress: any = "0xBFDC5fBd312b42FE3D1D738d4493E1C45b3cC4F8";
const borrowContractAddress: any = "0xfb0be8721F277746D853CC95e9b66F074C756756";
const marketplaceContractAddress: any = "0xA32C3b7Bc0D56815c330e770294dDDE11E821C52";
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
