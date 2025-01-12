"use client"
import React, { useState } from 'react'
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from '../ui/dialog'
import { Button } from '../ui/button'
import { Label } from '../ui/label'
import { Input } from '../ui/input'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '../ui/select'
import { useAccount } from 'wagmi'
import { marketplaceContract, switchChain } from '@/backend/web3'
import CustomBtn from '../cards/customBtn'

const CreateListing = () => {
   const account = useAccount()
   const [value, setValue] = useState({
      livestockId: "",
      pricePerShare: "",
      profitPerShare: "",
      lockPeriod: "",
      periodProfit: "",
      listingType: 0,
   })
   const handleChange = (e: any) => {
      setValue((value: any) => ({ ...value, [e.target.name]: e.target.value }))
   }
   console.log(value)
   const handleClick = async () => {
      try {
         switchChain(5115)
         let result = await marketplaceContract.methods.createListing(value.livestockId, value.pricePerShare, value.profitPerShare, value.lockPeriod, value.periodProfit, value.listingType).send({ from: account.address });
         result = {
            ...result,
            success: "Livestock Registration Successful"
         }
         return result
      } catch (error) {
         console.log(error)
         throw new Error("There was a problem with the request");
      }
   }
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
                  <Input name='livestockId' id="farmname" className="col-span-5" placeholder="00" onChange={(e) => handleChange(e)} />
               </div>
               <div className="grid grid-cols-4 items-center gap-2">
                  <Label htmlFor="username" className="text-left">
                     PricePerShare
                  </Label>
                  <Input name='pricePerShare' id="farmname" className="col-span-5" placeholder="$2" onChange={(e) => handleChange(e)} />
               </div>

               <div className="grid grid-cols-4 items-center gap-2">
                  <Label htmlFor="username" className="text-left">
                     ProfitPerShare
                  </Label>
                  <Input name='profitPerShare' id="farmname" className="col-span-5" placeholder="200$" onChange={(e) => handleChange(e)} />
               </div>

               <div className="grid grid-cols-4 items-center gap-2">
                  <Label htmlFor="username" className="text-left">
                     LockPeriod
                  </Label>
                  <Input name='lockPeriod' id="farmname" className="col-span-5" placeholder="Lock Period e.g 6 weeks" onChange={(e) => handleChange(e)} />
               </div>
               <div className="grid grid-cols-4 items-center gap-2">
                  <Label htmlFor="username" className="text-left">
                     PeriodProfit
                  </Label>
                  <Input name='periodProfit' id="farmname" className="col-span-5" placeholder="$200" onChange={(e) => handleChange(e)} />
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
               {/* <Button type="submit" className="w-full">Create</Button> */}
               <CustomBtn handleClick={handleClick} />
            </DialogFooter>
         </DialogContent>
      </Dialog>
   )
}

export default CreateListing