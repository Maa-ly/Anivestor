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


const page = () => {

   const truncate = (text: string) => {
      return text.slice(0,5)  + "..." + text.slice(-3);
   }
   return (
      <main className='w-full h-screen bg-black flex flex-col items-center'>
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

         <div className='w-[15rem] h-[20rem] bg-slate-300 text-black rounded-xl overflow-hidden shadow-md'>
            <Image src={vercel} alt="image" width={200} height={200} className='w-full h-[8rem] bg-blue-300' />

            <div className='p-4'>
               <h3 className='font-semibold'>Big On Animal</h3>
               <div className='flex justify-between'>

                  <div>
                     <h3 className='text-[12px] text-gray-800'>Farm name</h3>
                     <p className='text-sm'>Kaleel {truncate("0x4990299049sifj3990")}</p>
                  </div>
                  <div>
                     <h3 className='text-[12px] text-gray-800'>Daily Profit</h3>
                     <p className='text-sm'>$490</p>
                  </div>
               </div>
               <div className='flex justify-between'>

                  <div>
                     <h3 className='text-[12px] text-gray-800'>Farm name</h3>
                     <p className='text-sm'>Kaleel {truncate("0x4990299049sifj3990")}</p>
                  </div>
                  <div>
                     <h3 className='text-[12px] text-gray-800'>Daily Profit</h3>
                     <p className='text-sm'>$490</p>
                  </div>
               </div>

               <Button className='w-full'>Invest</Button>
            </div>
         </div>

      </main>
   )
}

export default page