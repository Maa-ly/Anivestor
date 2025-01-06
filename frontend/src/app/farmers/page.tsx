import React from 'react'
import { Input } from '@/components/ui/input'
import { Label } from "@/components/ui/label"
import { Button } from '@/components/ui/button'

const page = () => {
   return (
      <main className='w-full h-screen bg-black flex flex-col items-center'>
         <div className='w-[30rem] h-[30rem] flex flex-col items-center pt-20 bg-red-00 rounded-md border-solid border-[0.5px] border-white mt-[10rem]'>
            <h2 className='text-2xl mb-10'>Farmer Registration</h2>
           
            <div className="grid w-full max-w-sm items-center gap-1.5 mb-5">
               <Label htmlFor="email">Farm Name</Label>
               <Input type="text" id="farmName" placeholder="Farm name" className='text-black outline-none bg-transparent border-solid border-[0.5px]' />
            </div>
            <div className="grid w-full max-w-sm items-center gap-1.5">
               <Label htmlFor="email">Email</Label>
               <Input type="text" id="farmName" placeholder="Farm name" className='text-black outline-none bg-transparent border-solid border-[0.5px]' />
            </div>
            <Button className='bg-blue-400 hover:bg-blue-500 w-[24rem] my-5 '>Register</Button>
         </div>
      </main>
   )
}

export default page