"use client"
import '@rainbow-me/rainbowkit/styles.css';
import {
   getDefaultConfig,
   RainbowKitProvider,
} from '@rainbow-me/rainbowkit';
import { WagmiProvider } from 'wagmi';
import {
   QueryClientProvider,
   QueryClient,
} from "@tanstack/react-query";
import { type Chain } from 'wagmi/chains';

const citreaTestnet = {
   id
      : 5115,
   name
      : 'Citrea Testnet',
   nativeCurrency
      : {
      name
         : 'cBTC', symbol
         : 'cBTC', decimals
         : 18
   },
   rpcUrls
      : {
      default
         : {
         http
            : ['http://rpc.testnet.citrea.xyx/']
      },
   },
   blockExplorers
      : {
      default
         : {
         name
            : 'explorer', url
            : 'http://explorer.testnet.citrea.xyz/'
      },
   },
} as const satisfies Chain;
const iExecSideChain = {
   id
      : 134,
   name
      : 'iExec Sidechain',
   nativeCurrency
      : {
      name
         : 'xRLC', symbol
         : 'xRLC', decimals
         : 18
   },
   rpcUrls
      : {
      default
         : {
         http
            : ['https://bellecour.iex.ec/']
      },
   },
   blockExplorers
      : {
      default
         : {
         name
            : 'explorer', url
            : 'https://blockscout.bellecour.iex.ec/'
      },
   },
} as const satisfies Chain;

// import { getDefaultConfig } from '@rainbow-me/rainbowkit';
const config = getDefaultConfig({
   appName: 'Anivestor',
   projectId: '8cb5f3fe4d21366ebdb7819b637be12e',
   chains: [
      citreaTestnet,
      iExecSideChain
   ],
   ssr: true, // If your dApp uses server side rendering (SSR)
});

const queryClient = new QueryClient();
const RainbowProvider = ({ children }: { children: React.ReactNode }) => {
   return (
      <WagmiProvider config={config}>
         <QueryClientProvider client={queryClient}>
            <RainbowKitProvider>
               {children}
            </RainbowKitProvider>
         </QueryClientProvider>
      </WagmiProvider>
   );
};

export default RainbowProvider;
export { citreaTestnet }