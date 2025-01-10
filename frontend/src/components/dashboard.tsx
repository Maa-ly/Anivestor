"use client"
import React from 'react'
import { Dialog, DialogContent, DialogTitle, DialogTrigger } from './ui/dialog'
import { Button } from './ui/button'
import Image from 'next/image'
import infantCattleImage from "../../public/images/infantCattle.png"
import CreateListing from './popup/createListing'
import RegisterLivestock from './popup/registerLivestock'

// eslint-disable-next-line @typescript-eslint/no-explicit-any
const Dashboard = ({ account }: { account: any }) => {
   return (

      <Dialog>

         <DialogTrigger>
            <button className='p-1 px-4 bg-gray-200 rounded-xl'>
               {account.displayName}
               {account.displayBalance
                  ? ` (${account.displayBalance})`
                  : ''}
            </button>
         </DialogTrigger>
         <DialogContent className="p-0 flex justify-center items-center gap-0 w-fit ">
            <DialogTitle>

            </DialogTitle>

            {/* <div className="w-screen h-screen bg-transparent flex justify-center items-center"> */}
            <div className="w-[24rem] bg-white/60 rounded-xl drop-shadow-md p-5 relative">
               <span className="w-[1.8rem] h-[1.8rem] absolute top-5 right-5 bg-gray-800 flex justify-center items-center rounded-full">close</span>
               <Image src={infantCattleImage} alt="avatar" className="w-[8rem] bg-gray-600 h-[8rem] aspect-square rounded-full shadow-md justify-self-center" />

               <h2 className="justify-self-center mt-4 text-black font-bold font-sans">0x0009...23432
               </h2>
               <p className="font-normal text-black/70 justify-self-center">
                  Farmer
               </p>
               <h2 className="justify-self-center mt-1 mb-5 text-black/70 font-semibold font-sans">0 Eth</h2>

               <div className="flex gap-2 mb-2">
                  <Button className="hover:bg-white/50 w-full bg-white rounded-md text-black/70 font-semibold ">Copy Address</Button>
                  <Button className="hover:bg-white/50 w-full bg-white rounded-md text-black/70 font-semibold ">Disconnect</Button>
               </div>
               <div className="flex gap-2 mb-2">

                  <CreateListing />
                  <RegisterLivestock />
               </div>
               <Button className="hover:bg-white/50 w-full bg-red-600 rounded-md text-white/70 font-semibold ">Delete Account</Button>
            </div>

            {/* </div> */}
         </DialogContent>
      </Dialog>

   )
}

export default Dashboard