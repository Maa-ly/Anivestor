import Web3 from "web3"
import farmerAbi from "./contract/FarmerRegistration.json"
import borrowAbi from "./contract/Borrow.json"
import marketplaceAbi from "./contract/Marketplace.json"
import whitelistAbi from "./contract/whitelist.json"



// == Return ==
// 0: contract FarmerRegistration 0x797d3c182aA3d4d64959acAB8Ff7D7fbDDEa0fa4
// 1: contract WhiteListDeployer 0x9d260b53e841bC429FF806d6dcD1f541467BcF82
// 2: contract MarketPlace 0xa8Da6A7B3fD77d7DA0C131b139e37219e6C76A39
// 3: contract Borrow 0x053Fb8211C393100F8f5E900DD9662433ed3fD92
// 4: contract HelperConfig 0x5aAdFB43eF8dAF45DD80F4676345b7676f1D70e3

// contract FarmerRegistration 0xf5b9319fdaa178B24852D2A58697581278F2B14D
// 1: contract WhiteListDeployer 0xB3C3F492ED6BA8CD0079c537d3F10041382CDfe8
// 2: contract MarketPlace 0xdE97dF6E101E17ebbC901444AB8AA1e6fFE9F18B
// 3: contract Borrow 0x02AA0EAcb0Fab7d9864E1ddC2f3800d40DC646d6
// 4: contract HelperConfig 0x5aAdFB43eF8dAF45DD80F4676345b7676f1D70e3
// == Return ==
// 0: contract FarmerRegistration 0xa6dDCBE4ea5B8fD62A738595b4ba2D47Df824eFB
// 1: contract WhiteList 0x131235209d0948E4C9DC72d48A1E5d64eea43bb5
// 2: contract MarketPlace 0xd04b419f8b82C4d47a3b410FF242e89953f9Ac2a
// 3: contract Borrow 0xf453B5B73828B54Bf60E4FBFa87a99f0E799221E
// 4: contract HelperConfig 0x5aAdFB43eF8dAF45DD80F4676345b7676f1D70e3
let web3 = null;
let farmerContract: any = null;
let borrowContract: any = null;
let marketplaceContract: any = null;
let whitelistContract: any = null;
const farmerContractAddress: any = "0xa6dDCBE4ea5B8fD62A738595b4ba2D47Df824eFB";
const borrowContractAddress: any = "0xf453B5B73828B54Bf60E4FBFa87a99f0E799221E";
const marketplaceContractAddress: any = "0xd04b419f8b82C4d47a3b410FF242e89953f9Ac2a";
const whitelistContractAddress: string = "0x131235209d0948E4C9DC72d48A1E5d64eea43bb5";
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
