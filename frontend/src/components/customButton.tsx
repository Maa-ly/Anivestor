import { ConnectButton } from '@rainbow-me/rainbowkit';
import Dashboard from './dashboard';
export const CustomButton = () => {
   return (
      <ConnectButton.Custom>
         {({
            account,
            chain,
            // openAccountModal,
            openChainModal,
            openConnectModal,
            authenticationStatus,
            mounted,
         }) => {
            // Note: If your app doesn't use authentication, you
            // can remove all 'authenticationStatus' checks
            const ready = mounted && authenticationStatus !== 'loading';
            const connected =
               ready &&
               account &&
               chain &&
               (!authenticationStatus ||
                  authenticationStatus === 'authenticated');
            return (
               <div
                  {...(!ready && {
                     'aria-hidden': true,
                     'style': {
                        opacity: 0,
                        pointerEvents: 'none',
                        userSelect: 'none',
                     },
                  })}
                  className='bg-white rounded-xl  p-[4px] px-5 text-black'
               >
                  {(() => {
                     if (!connected) {
                        return (
                           <button onClick={openConnectModal} type="button">
                              Connect Wallet
                           </button>
                        );
                     }
                     if (chain.unsupported) {
                        return (
                           <button onClick={openChainModal} type="button">
                              Wrong network
                           </button>
                        );
                     }
                     return (
                        <div style={{ display: 'flex', gap: 12 }}>
                           <button
                              onClick={openChainModal}
                              style={{ display: 'flex', alignItems: 'center' }}
                              type="button"
                           >
                              {chain.hasIcon && (
                                 <div
                                    style={{
                                       background: chain.iconBackground,
                                       width: 12,
                                       height: 12,
                                       borderRadius: 999,
                                       overflow: 'hidden',
                                       marginRight: 4,
                                    }}
                                 >
                                    {chain.iconUrl && (
                                       // eslint-disable-next-line @next/next/no-img-element
                                       <img
                                          alt={chain.name ?? 'Chain icon'}
                                          src={chain.iconUrl}
                                          style={{ width: 12, height: 12 }}
                                       />
                                    )}
                                 </div>
                              )}
                              {/* {chain.name} */}
                           </button>
                           <Dashboard account={account} />
                           {/* <button onClick={openAccountModal} type="button">
                              {account.displayName}
                              {account.displayBalance
                                 ? ` (${account.displayBalance})`
                                 : ''}
                           </button> */}
                        </div>
                     );
                  })()}
               </div>
            );
         }}
      </ConnectButton.Custom>
   );
};