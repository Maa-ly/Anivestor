import { Popover, PopoverContent, PopoverTrigger } from '../ui/popover'
import React from 'react'
import { Button } from '../ui/button'
import { Input } from '../ui/input'
import { Label } from '../ui/label'
import Image from 'next/image'
import vercel from "../../../public/vercel.svg"
import {
   Menubar,
   MenubarContent,
   MenubarItem,
   MenubarMenu,
   MenubarSeparator,
   MenubarShortcut,
   MenubarSub,
   MenubarSubContent,
   MenubarSubTrigger,
   MenubarTrigger,
} from "../ui/menubar"

const LivestockCard = () => {
   const truncate = (text: string) => {
      return text.slice(0, 5) + "..." + text.slice(-3);
   }
   return (
      <div className='flex relative flex-col bg-slate-300 text-black rounded-xl overflow-hidden shadow-md shrink-0'>
         <Image src={vercel} alt="image" width={200} height={200} className='w-full h-[8rem] bg-blue-300' />
         <div className='absolute top-2 right-2 flex flex-col'>
            {/* <div className='w-[8rem] h-[3rem] bg-white absolute top-8 right-1'></div> */}
            <Menubar className='bg-transparent p-1'>
               <MenubarMenu>
                  <MenubarTrigger >
                     <span className='cursor-pointer'>menu</span>
                  </MenubarTrigger>
                  <MenubarContent className=''>
                     <MenubarItem>
                        New Tab <MenubarShortcut>⌘T</MenubarShortcut>
                     </MenubarItem>
                     <MenubarItem>
                        New Window <MenubarShortcut>⌘N</MenubarShortcut>
                     </MenubarItem>
                     <MenubarItem disabled>New Incognito Window</MenubarItem>
                     <MenubarSeparator />
                     <MenubarSub>
                        <MenubarSubTrigger>Farmer</MenubarSubTrigger>
                        <MenubarSubContent>
                           <MenubarItem>Delist</MenubarItem>
                           <MenubarItem>Add to Private Whitelist</MenubarItem>
                           <MenubarItem>Remove from Private Whitelist</MenubarItem>
                           <MenubarItem>Remove from Public Whitelist</MenubarItem>
                           <MenubarItem>Notes</MenubarItem>
                        </MenubarSubContent>
                     </MenubarSub>
                     <MenubarSub>
                        <MenubarSubTrigger>Investor</MenubarSubTrigger>
                        <MenubarSubContent>
                           <MenubarItem>Purchae Shares</MenubarItem>
                           <MenubarItem></MenubarItem>
                           <MenubarItem>Notes</MenubarItem>
                        </MenubarSubContent>
                     </MenubarSub>
                     <MenubarSeparator />
                     <MenubarItem>
                        Print... <MenubarShortcut>⌘P</MenubarShortcut>
                     </MenubarItem>
                  </MenubarContent>
               </MenubarMenu>
            </Menubar>
         </div>
         <div className='p-2 px-4'>
            <h3 className='font-semibold'>Big On Animal <span className='text-[12px] text-green-500'>in-stock</span></h3>
            <div className='flex justify-between pb-1'>
               <div className='w-1/2'>
                  <h3 className='text-[12px] text-gray-800'>Farm name</h3>
                  <p className='text-sm'>Kaleel {truncate("0x4990299049sifj3990")}</p>
               </div>
               <div className='w-1/2 text-right'>
                  <h3 className='text-[12px] text-gray-800'>Breed</h3>
                  <p className='text-sm'>Cat</p>
               </div>
            </div>
            <div className='flex justify-between pb-1'>
               <div className='w-1/2'>
                  <h3 className='text-[12px] text-gray-800'>Total Minted</h3>
                  <p className='text-sm'>4000 Tk</p>
               </div>
               <div className='w-1/2 text-right'>
                  <h3 className='text-[12px] text-gray-800'>Available Shares</h3>
                  <p className='text-sm'>2000</p>
               </div>
            </div>
            <div className='flex justify-between pb-1'>
               <div className='w-1/2'>
                  <h3 className='text-[12px] text-gray-800'>Price per Share</h3>
                  <p className='text-sm'>$20</p>
               </div>
               <div className='w-1/2 text-right'>
                  <h3 className='text-[12px] text-gray-800'>Listing Time</h3>
                  <p className='text-sm'>3 Days</p>
               </div>
            </div>

         </div>
         {/* <Button className='mx-auto w-[90%] my-2'>Invest</Button> */}
         <Popover>
            <PopoverTrigger asChild>
               <Button className='mx-auto w-[90%] my-2'>Invest</Button>
            </PopoverTrigger>
            <PopoverContent className="w-80">
               <div className="grid gap-4">
                  <div className="space-y-2">
                     <h4 className="font-medium leading-none">Purchase Shares</h4>
                     <p className="text-sm text-muted-foreground">
                        Buy a share in Nobles Farm
                     </p>
                  </div>
                  <div className="grid gap-2">
                     <div className="grid grid-cols-3 items-center gap-4">
                        <Label htmlFor="share">Shares</Label>
                        <Input
                           id="share"
                           defaultValue="1"
                           className="col-span-2 h-8"
                        />
                     </div>
                     <div className="grid grid-cols-3 items-center gap-4">
                        <Label htmlFor="pay">Pay $</Label>
                        <Input
                           id="amountToPay"
                           defaultValue="none"
                           className="col-span-2 h-8"
                           disabled
                        />
                     </div>

                  </div>

               </div>
               <Button className='mx-auto w-full my-2'>Purchase</Button>
            </PopoverContent>
         </Popover>

      </div>
   )
}

export default LivestockCard