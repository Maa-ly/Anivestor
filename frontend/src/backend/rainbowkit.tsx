"use client"
import '@rainbow-me/rainbowkit/styles.css';
import {
   getDefaultConfig,
   RainbowKitProvider,
} from '@rainbow-me/rainbowkit';
import { WagmiProvider } from 'wagmi';
import {
   mainnet,
   polygon,
   optimism,
   arbitrum,
   base
} from 'wagmi/chains';
import {
   QueryClientProvider,
   QueryClient,
} from "@tanstack/react-query";

// import { getDefaultConfig } from '@rainbow-me/rainbowkit';
const config = getDefaultConfig({
   appName: 'Anivestor',
   projectId: '8cb5f3fe4d21366ebdb7819b637be12e',
   chains: [mainnet, polygon, optimism, arbitrum, base],
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