"use client"
import '@rainbow-me/rainbowkit/styles.css';
import {
   getDefaultConfig,
   RainbowKitProvider,
} from '@rainbow-me/rainbowkit';
import { WagmiProvider } from 'wagmi';
// import {
//    mainnet,
//    polygon,
//    optimism,
//    arbitrum,
//    base
// } from 'wagmi/chains';
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
            : ['https://rpc.testnet.citrea.xyx/']
      },
   },
   blockExplorers
      : {
      default
         : {
         name
            : 'explorer', url
            : 'https://explorer.testnet.citrea.xyz/'
      },
   },
   // contracts
   //    : {
   //       ensRegistry
   //          : {
   //          address
   //             : '0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e',
   //       },
   //       ensUniversalResolver
   //          : {
   //          address
   //             : '0xE4Acdd618deED4e6d2f03b9bf62dc6118FC9A4da',
   //          blockCreated
   //             : 16773775,
   //       },
   //       multicall3
   //          : {
   //          address
   //             : '0xca11bde05977b3631167028862be2a173976ca11',
   //          blockCreated
   //             : 14353601,
   //       },
   //    }
} as const satisfies Chain;

// import { getDefaultConfig } from '@rainbow-me/rainbowkit';
const config = getDefaultConfig({
   appName: 'Anivestor',
   projectId: '8cb5f3fe4d21366ebdb7819b637be12e',
   chains: [citreaTestnet],
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