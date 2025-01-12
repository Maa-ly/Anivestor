"use client"
import React, { useEffect } from 'react'
import { Dialog, DialogContent, DialogTitle, DialogTrigger } from './ui/dialog'
import { Button } from './ui/button'
import Image from 'next/image'
import infantCattleImage from "../../public/images/infantCattle.png"
import CreateListing from './popup/createListing'
import RegisterLivestock from './popup/registerLivestock'
import DepositCollateral from './popup/depositCollateral'
import { borrowContract } from '@/backend/web3'

// eslint-disable-next-line @typescript-eslint/no-explicit-any
const Dashboard = ({ account }: { account: any }) => {
   const truncate = (address: string) => {
      return address.slice(0, 6) + "..." + address.slice(-6)
   }
   useEffect(() => {
      async function fetch() {
         const collateralValue = await borrowContract.methods.getFarmerBorrowedAmount(0);
         console.log(collateralValue)
      }
      fetch()
   })
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
            <div className="w-[26rem] bg-white/60 rounded-xl drop-shadow-md p-5 relative">
               <span className="w-[1.8rem] h-[1.8rem] absolute top-5 right-5 bg-gray-800 flex justify-center items-center rounded-full">close</span>
               <Image src={infantCattleImage} alt="avatar" className="w-[7rem] bg-gray-600 h-[7rem] aspect-square rounded-full shadow-md justify-self-center" />

               <h2 className="justify-self-center mt-4 text-black font-bold font-sans">{truncate(account.address)}
               </h2>
               <p className="font-normal text-black/70 justify-self-center">
                  Farmer
               </p>
               {/* <h2 className="justify-self-center mt-1 mb-5 text-black/70 font-semibold font-sans">0 Eth</h2> */}
               <div className='flex gap-2 text-[11px] justify-center'>
                  <h2 className="justify-self-center mt-1 mb-5 text-black/70 font-normal font-sans">Borrowed &#20;
                     <i className='not-italic font-semibold'>
                        200 USD
                     </i></h2>
                  <h2 className="justify-self-center mt-1 mb-5 text-black/70 font-normal font-sans">Collateral Value &#20;
                     <i className='not-italic font-semibold'>
                        500 USD
                     </i></h2>
                  {/* <h2 className="justify-self-center mt-1 mb-5 text-black/70 font-semibold font-sans">Colateral Value: 5000 USD</h2> */}

               </div>

               <div className="flex gap-2 mb-2">
                  <Button className="hover:bg-white/50 w-full bg-white rounded-md text-black/70 font-semibold ">Copy Address</Button>
                  <Button className="hover:bg-white/50 w-full bg-white rounded-md text-black/70 font-semibold ">Disconnect</Button>
               </div>
               <div className="flex gap-2 mb-2">
                  <CreateListing />
                  <RegisterLivestock />
               </div>
               <div className="flex gap-2 mb-2">
                  {/* <CreateListing /> */}
                  <DepositCollateral />
               </div>
               <Button className="w-full bg-red-600 rounded-md text-white/70 font-semibold hover:bg-red-600/70">Delete Account</Button>
               <div className='w-full h-[10.3rem] bg-gray-300 mt-2 rounded-xl flex flex-col gap-1 p-2 overflow-y-scroll'>
                  <div className='w-full h-[3rem] bg-gray-400 rounded-xl shrink-0 flex items-center px-2'>
                     <Image src={infantCattleImage} alt='senderprofile' className='h-[2.1rem] w-[2.1rem] bg-white rounded-full my-auto' />
                     <div className='bg-red-00 h-full w-full px-2 py-1'>
                        <p className='text-[12px] font-semibold'>Message header</p>
                        <p className='text-[12px] line-clamp-1 text-ellipsis'>Message body Lorem ipsum dolor sit amet consectetur adipisicing elit. Deserunt ducimus atque, commodi at iusto amet praesentium incidunt aut ab? Inventore laboriosam esse suscipit voluptas nobis odio repudiandae est repellendus eaque.</p>
                     </div>
                  </div>
                  <div className='w-full h-[3rem] bg-gray-400 rounded-xl shrink-0 flex items-center px-2'>
                     <Image src={infantCattleImage} alt='senderprofile' className='h-[2.1rem] w-[2.1rem] bg-white rounded-full my-auto' />
                     <div className='bg-red-00 h-full w-full px-2 py-1'>
                        <p className='text-[12px] font-semibold'>Message header</p>
                        <p className='text-[12px] line-clamp-1 text-ellipsis'>Message body Lorem ipsum dolor sit amet consectetur adipisicing elit. Deserunt ducimus atque, commodi at iusto amet praesentium incidunt aut ab? Inventore laboriosam esse suscipit voluptas nobis odio repudiandae est repellendus eaque.</p>
                     </div>
                  </div>
                  <div className='w-full h-[3rem] bg-gray-400 rounded-xl shrink-0 flex items-center px-2'>
                     <Image src={infantCattleImage} alt='senderprofile' className='h-[2.1rem] w-[2.1rem] bg-white rounded-full my-auto' />
                     <div className='bg-red-00 h-full w-full px-2 py-1'>
                        <p className='text-[12px] font-semibold'>Message header</p>
                        <p className='text-[12px] line-clamp-1 text-ellipsis'>Message body Lorem ipsum dolor sit amet consectetur adipisicing elit. Deserunt ducimus atque, commodi at iusto amet praesentium incidunt aut ab? Inventore laboriosam esse suscipit voluptas nobis odio repudiandae est repellendus eaque.</p>
                     </div>
                  </div>
                  <div className='w-full h-[3rem] bg-gray-400 rounded-xl shrink-0 flex items-center px-2'>
                     <Image src={infantCattleImage} alt='senderprofile' className='h-[2.1rem] w-[2.1rem] bg-white rounded-full my-auto' />
                     <div className='bg-red-00 h-full w-full px-2 py-1'>
                        <p className='text-[12px] font-semibold'>Message header</p>
                        <p className='text-[12px] line-clamp-1 text-ellipsis'>Message body Lorem ipsum dolor sit amet consectetur adipisicing elit. Deserunt ducimus atque, commodi at iusto amet praesentium incidunt aut ab? Inventore laboriosam esse suscipit voluptas nobis odio repudiandae est repellendus eaque.</p>
                     </div>
                  </div>
                  <div className='w-full h-[3rem] bg-gray-400 rounded-xl shrink-0 flex items-center px-2'>
                     <Image src={infantCattleImage} alt='senderprofile' className='h-[2.1rem] w-[2.1rem] bg-white rounded-full my-auto' />
                     <div className='bg-red-00 h-full w-full px-2 py-1'>
                        <p className='text-[12px] font-semibold'>Message header</p>
                        <p className='text-[12px] line-clamp-1 text-ellipsis'>Message body Lorem ipsum dolor sit amet consectetur adipisicing elit. Deserunt ducimus atque, commodi at iusto amet praesentium incidunt aut ab? Inventore laboriosam esse suscipit voluptas nobis odio repudiandae est repellendus eaque.</p>
                     </div>
                  </div>
                  <div className='w-full h-[3rem] bg-gray-400 rounded-xl shrink-0 flex items-center px-2'>
                     <Image src={infantCattleImage} alt='senderprofile' className='h-[2.1rem] w-[2.1rem] bg-white rounded-full my-auto' />
                     <div className='bg-red-00 h-full w-full px-2 py-1'>
                        <p className='text-[12px] font-semibold'>Message header</p>
                        <p className='text-[12px] line-clamp-1 text-ellipsis'>Message body Lorem ipsum dolor sit amet consectetur adipisicing elit. Deserunt ducimus atque, commodi at iusto amet praesentium incidunt aut ab? Inventore laboriosam esse suscipit voluptas nobis odio repudiandae est repellendus eaque.</p>
                     </div>
                  </div>

               </div>
               <button className='px-2 py-1 bg-transparent text-gray-700 text-sm '>Compose</button>
            </div>

            {/* </div> */}
         </DialogContent>
      </Dialog>

   )
}

export default Dashboard