import React from 'react'
import { Input } from '@/components/ui/input'
import { Label } from "@/components/ui/label"
import { Button } from '@/components/ui/button'
import Image from 'next/image'
import {
   Select,
   SelectContent,
   SelectItem,
   SelectTrigger,
   SelectValue,
} from "@/components/ui/select"
import vercel from "../../../public/vercel.svg"
import {
   Popover,
   PopoverContent,
   PopoverTrigger,
} from "@/components/ui/popover"



const page = () => {

   const truncate = (text: string) => {
      return text.slice(0, 5) + "..." + text.slice(-3);
   }
   return (
      <main className='w-full h-full bg-black flex flex-col items-center'>
         <div className='w-[30rem] flex flex-col items-center pt-20 bg-red-00 rounded-md border-solid border-[0.5px] border-white mt-[10rem] pb-5'>
            <h2 className='text-2xl mb-10'>Farmer Registration</h2>

            <div className="grid w-full max-w-sm items-center gap-1.5 mb-5">
               <Label htmlFor="email">Legal Firstname</Label>
               <Input type="text" id="farmName" placeholder="firstname" className='text-black outline-none bg-transparent border-solid border-[0.5px]' />
            </div>
            <div className="grid w-full max-w-sm items-center gap-1.5 mb-5">
               <Label htmlFor="email">Legal Lastname</Label>
               <Input type="text" id="farmName" placeholder="lastname" className='text-black outline-none bg-transparent border-solid border-[0.5px]' />
            </div>
            <div className="grid w-full max-w-sm items-center gap-1.5 mb-5">
               <Label htmlFor="email">Farm Name</Label>
               <Input type="text" id="farmName" placeholder="Farm name" className='text-black outline-none bg-transparent border-solid border-[0.5px]' />
            </div>
            <div className="grid w-full max-w-sm items-center gap-1.5 mb-5">

               <Label htmlFor="email">Country</Label>
               <Select>
                  <SelectTrigger className="w-[24rem] bg-black ">
                     <SelectValue placeholder="Country" />
                  </SelectTrigger>
                  <SelectContent className='bg-black text-white'>
                     <SelectItem value="gh">Ghana</SelectItem>
                     <SelectItem value="us">USA</SelectItem>
                  </SelectContent>
               </Select>
            </div>
            <Button className=' w-[24rem] my-5 '>Register</Button>
         </div>

         <div className='w-[18rem] flex flex-col bg-slate-300 text-black rounded-xl overflow-hidden shadow-md'>
            <Image src={vercel} alt="image" width={200} height={200} className='w-full h-[8rem] bg-blue-300' />

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
                           Buy a share in Noble's Farm
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

      </main>
   )
}

export default page