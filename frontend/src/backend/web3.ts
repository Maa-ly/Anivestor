import Web3 from "web3"


let web = null;
if (typeof window !== "undefined" && typeof window.ethereum !== "undefined") {
   //
   web = new Web3(window.ethereum);
} else {
   //
}
