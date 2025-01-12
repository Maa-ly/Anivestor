"use client"
import React, { useEffect, useState } from 'react'
import LivestockCard from '@/components/cards/livestock'
import { marketplaceContract } from '@/backend/web3'

const Marketplace = () => {
   const [listings, setListings] = useState([]);

   useEffect(() => {
      async function fetch() {
         const result = await marketplaceContract.methods.getListings().call();
         setListings(result);
      }
      fetch()
   })


   return (
      <main className='w-full h-full bg-black flex flex-col items-center'>
         {/* <FarmerRegistration /> */}

         <section className='w-full h-full gap-2 grid customgrid mt-10 px-4 xl:px-[10rem]'>
            {listings.map((element, index) => (
               <LivestockCard key={index} index={index} animal={element} />
            ))}

         </section>

      </main>
   )
}

export default Marketplace