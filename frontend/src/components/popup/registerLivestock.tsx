"use client"
import React from 'react'
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from '../ui/dialog'
import { Button } from '../ui/button'
import { Label } from '../ui/label'
import { Input } from '../ui/input'

const RegisterLivestock = () => {
   return (

      <Dialog>
         <DialogTrigger asChild>
            <Button className="hover:bg-white/50 w-full bg-white rounded-md text-black/70 font-semibold ">Register Livestock</Button>
         </DialogTrigger>
         <DialogContent className="sm:max-w-[425px]">
            <DialogHeader>
               <DialogTitle className="text-black">Register Livestock</DialogTitle>
               <DialogDescription>
                  Make changes to your profile here. Click save when youre done.
               </DialogDescription>
            </DialogHeader>


            <div className="grid gap-4 py-4 text-black">
               <div className="grid grid-cols-4 items-center gap-4">
                  <Label htmlFor="name" className="text-left">
                     Animal Name
                  </Label>
                  <Input id="animalName" className="col-span-5" placeholder="Noble's Farm" />
               </div>
               <div className="grid grid-cols-4 items-center gap-2">
                  <Label htmlFor="username" className="text-left">
                     Breed
                  </Label>
                  <Input id="breed" className="col-span-5" placeholder="breed" />
               </div>
               <div className="grid grid-cols-4 items-center gap-2">
                  <Label htmlFor="username" className="text-left">
                     Mint
                  </Label>
                  <Input id="mintAmount" className="col-span-5" placeholder="2000" />
               </div>
            </div>
            <DialogFooter>
               <Button type="submit" className="w-full">Create</Button>
            </DialogFooter>
         </DialogContent>
      </Dialog>
   )
}

export default RegisterLivestock