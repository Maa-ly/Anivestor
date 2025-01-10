"use client"
import React from 'react'
import { useRouter } from 'next/navigation';
// import { ConnectButton } from '@rainbow-me/rainbowkit';
import { CustomButton } from './customButton';
const Navbar = () => {
   const router = useRouter();
   return (
      <div className="w-full h-[4rem] bg-[#000814] border-b-[#FFC300]/80 border-b-[0.5px] flex justify-between items-center px-5 text-white">
         <div onClick={() => router.push('/')} className='cursor-pointer'>Anivestor</div>
         <div className="flex gap-2">
            <div onClick={() => router.push('/market')} className='cursor-pointer'>Marketplace</div>
         </div>
         {/* <ConnectButton chainStatus={"none"} /> */}
         <CustomButton />
      </div>
   )
}

export default Navbar