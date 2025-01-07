import { Button } from '../ui/button'
import { Input } from '../ui/input'
import { Label } from '../ui/label'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '../ui/select'
import React from 'react'

const FarmerRegistration = () => {
  return (
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
  )
}

export default FarmerRegistration