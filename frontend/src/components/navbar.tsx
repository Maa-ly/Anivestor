"use client"
import React from 'react'
import { useRouter } from 'next/navigation';
const Navbar = () => {
   const router = useRouter();
   return (
      <div className="w-full h-[4rem] bg-black border-b-gray-400 border-b-[1px] flex justify-between items-center px-5 text-white">
         <div>Anivestor</div>
         <div className="flex gap-2">
            <div onClick={() => router.push('/farmers')}>Farmers</div>
            <div onClick={() => router.push('/investor')}>Investors</div>
            <div onClick={() => router.push('/market')}>Marketplace</div>
         </div>
         <div>Connect</div>
      </div>
   )
}

export default Navbar