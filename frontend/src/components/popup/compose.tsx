/* eslint-disable @typescript-eslint/no-explicit-any */
"use client"
import React, { useState } from 'react'
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from '../ui/dialog'
import { Button } from '../ui/button'
import { Label } from '../ui/label'
import { Input } from '../ui/input'
import { useAccount } from 'wagmi'
import { borrowContract, switchChain } from '@/backend/web3'
import CustomBtn from '../cards/customBtn'

const Compose = () => {
   const account = useAccount()
   const [value, setValue] = useState({
      name: "",
      value: ""
   })
   const handleChange = (e: any) => {
      setValue((value: any) => ({ ...value, [e.target.name]: e.target.value }))
   }
   console.log(value)

   const handleClick = async () => {
      try {
         switchChain(5115)
         // let re = await marketplaceContract.methods.livestockId.call()
         let result = await borrowContract.methods.depositCollateral(value.value).send({ from: account.address });
         result = {
            ...result,
            success: "Livestock Registration Successful"
         }
         return result
         // console.log(result)
      } catch (error) {
         console.log(error)
         throw new Error("There was a problem with the request");
      }
   }
   return (

      <Dialog>
         <DialogTrigger asChild>
            <Button className="hover:bg-white/50 w-full bg-white rounded-md text-black/70 font-semibold ">Deposit Collateral</Button>
         </DialogTrigger>
         <DialogContent className="sm:max-w-[425px]">
            <DialogHeader>
               <DialogTitle className="text-black">Deposit Collateral</DialogTitle>
               <DialogDescription>
                  Make changes to your profile here. Click save when youre done.
               </DialogDescription>
            </DialogHeader>


            <div className="grid gap-4 py-4 text-black">
               <div className="grid grid-cols-4 items-center gap-4">
                  <Label htmlFor="name" className="text-left">
                     Collateral Name
                  </Label>
                  <Input name='name' id="name" className="col-span-5" placeholder="3 plots of land" onChange={(e) => handleChange(e)} />
               </div>
               <div className="grid grid-cols-4 items-center gap-2">
                  <Label htmlFor="username" className="text-left">
                     Value
                  </Label>
                  <Input name='value' id="value" className="col-span-5" placeholder="breed" onChange={(e) => handleChange(e)} />
               </div>
               {/* <div className="grid grid-cols-4 items-center gap-2">
                  <Label htmlFor="username" className="text-left">
                     Mint
                  </Label>
                  <Input name='mintAmount' id="mintAmount" className="col-span-5" placeholder="2000" onChange={(e) => handleChange(e)} />
               </div> */}
            </div>
            <DialogFooter>
               <CustomBtn handleClick={handleClick} />
               {/* <Button type="submit" className="w-full">Create</Button> */}
            </DialogFooter>
         </DialogContent>
      </Dialog>
   )
}

export default Compose;