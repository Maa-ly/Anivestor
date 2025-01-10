"use client"
import React from 'react'
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from '../ui/dialog'
import { Button } from '../ui/button'
import { Label } from '../ui/label'
import { Input } from '../ui/input'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '../ui/select'

const CreateListing = () => {
   return (
      <Dialog>
         <DialogTrigger asChild>
            <Button className="hover:bg-white/50 w-full bg-white rounded-md text-black/70 font-semibold ">Create Listing</Button>
         </DialogTrigger>
         <DialogContent className="sm:max-w-[425px]">
            <DialogHeader>
               <DialogTitle className="text-black">Create Livestock Listing</DialogTitle>
               <DialogDescription>
                  Make changes to your profile here. Click save when youre done.
               </DialogDescription>
            </DialogHeader>


            <div className="grid gap-4 py-4 text-black">
               <div className="grid grid-cols-4 items-center gap-4">
                  <Label htmlFor="name" className="text-left">
                     LivestockId
                  </Label>
                  <Input id="farmname" className="col-span-5" placeholder="00" />
               </div>
               <div className="grid grid-cols-4 items-center gap-2">
                  <Label htmlFor="username" className="text-left">
                     PricePerShare
                  </Label>
                  <Input id="farmname" className="col-span-5" placeholder="$2" />
               </div>

               <div className="grid grid-cols-4 items-center gap-2">
                  <Label htmlFor="username" className="text-left">
                     ProfitPerShare
                  </Label>
                  <Input id="farmname" className="col-span-5" placeholder="200$" />
               </div>

               <div className="grid grid-cols-4 items-center gap-2">
                  <Label htmlFor="username" className="text-left">
                     LockPeriod
                  </Label>
                  <Input id="farmname" className="col-span-5" placeholder="Lock Period e.g 6 weeks" />
               </div>
               <div className="grid grid-cols-4 items-center gap-2">
                  <Label htmlFor="username" className="text-left">
                     PeriodProfit
                  </Label>
                  <Input id="farmname" className="col-span-5" placeholder="$200" />
               </div>
               <div className="items-center">
                  <Label htmlFor="username" className="text-left">
                     Listing Type
                  </Label> <br />
                  <Select>
                     <SelectTrigger className="w-[24rem] ">
                        <SelectValue placeholder="Listing Type" />
                     </SelectTrigger>
                     <SelectContent className='text-black'>
                        <SelectItem value="pb">Public</SelectItem>
                        <SelectItem value="pr">Private</SelectItem>
                     </SelectContent>
                  </Select>
               </div>
            </div>
            <DialogFooter>
               <Button type="submit" className="w-full">Create</Button>
            </DialogFooter>
         </DialogContent>
      </Dialog>
   )
}

export default CreateListing