import React from 'react'
import LivestockCard from '@/components/cards/livestock'

const page = () => {


   return (
      <main className='w-full h-full bg-black flex flex-col items-center'>
         {/* <FarmerRegistration /> */}

         <section className='w-full h-full gap-2 grid customgrid mt-10 px-4 xl:px-[10rem]'>
            <LivestockCard />
            <LivestockCard />
            <LivestockCard />
            <LivestockCard />
            <LivestockCard />
            <LivestockCard />

         </section>

      </main>
   )
}

export default page