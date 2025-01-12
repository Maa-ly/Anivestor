"use client"
import React, { useCallback, useState } from 'react'
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from '../ui/dialog'
import { Button } from '../ui/button'
import { Label } from '../ui/label'
import { Input } from '../ui/input'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '../ui/select'
import { useAccount, useCall } from 'wagmi'
import { marketplaceContract, switchChain } from '@/backend/web3'
import CustomBtn from '../cards/customBtn'
import { Popover, PopoverContent, PopoverTrigger } from '../ui/popover'
import { addDays, format } from "date-fns"
import { CalendarIcon } from "lucide-react"
import { DateRange } from "react-day-picker"

import { cn } from "@/lib/utils"
import { Calendar } from "../ui/calendar"
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
   const today = new Date();
   const formattedDate = today.toISOString().split('T')[0]; // YYYY-MM-DD format
   const [date, setDate] = React.useState<DateRange | undefined>({
      from: new Date(formattedDate),
      to: addDays(new Date(formattedDate), 3),
   })
   console.log(date)

   // useCallback(() => {
   const from = new Date(date?.from);
   const to = new Date(date?.to);
   const diffInMs = to.getTime() - from.getTime();

   // Convert milliseconds to seconds
   const diffInSeconds = Math.floor(diffInMs / 1000);
   console.log(diffInSeconds)
   //    setValue((all: any) => ({ ...all, "lockPeriod": diffInSeconds }));
   // }, [date])

   const handleChange = (e: any) => {
      setValue((value: any) => ({ ...value, [e.target.name]: e.target.value }))
   }
   console.log(value)
   console.log(value)
   const handleClick = async () => {
      try {
         switchChain(5115)
         let result = await marketplaceContract.methods.createListing(value.livestockId, value.pricePerShare, value.profitPerShare, 172800, value.periodProfit, value.listingType).send({ from: account.address });
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

               {/* <div className="grid grid-cols-4 items-center gap-2">
                  <Label htmlFor="username" className="text-left">
                     LockPeriod
                  </Label>
                  <Input name='lockPeriod' id="farmname" className="col-span-5" placeholder="Lock Period e.g 6 weeks" onChange={(e) => handleChange(e)} />
               </div> */}

               <div className={cn("grid gap-2")}>
                  <Popover>
                     <PopoverTrigger asChild>
                        <Button
                           id="date"
                           variant={"outline"}
                           className={cn(
                              "w-[300px] justify-start text-left font-normal",
                              !date && "text-muted-foreground"
                           )}
                        >
                           <CalendarIcon />
                           {date?.from ? (
                              date.to ? (
                                 <>
                                    {format(date.from, "LLL dd, y")} -{" "}
                                    {format(date.to, "LLL dd, y")}
                                 </>
                              ) : (
                                 format(date.from, "LLL dd, y")
                              )
                           ) : (
                              <span>Pick a date</span>
                           )}
                        </Button>
                     </PopoverTrigger>
                     <PopoverContent className="w-auto p-0" align="start">
                        <Calendar
                           initialFocus
                           mode="range"
                           defaultMonth={date?.from}
                           selected={date}
                           onSelect={setDate}
                           numberOfMonths={1}
                        />
                     </PopoverContent>
                  </Popover>
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
                  <Select onValueChange={(e) => { setValue((value: any) => ({ ...value, "listingType": e })) }}>
                     <SelectTrigger className="w-[24rem] ">
                        <SelectValue placeholder="Listing Type" />
                     </SelectTrigger>
                     <SelectContent className='text-black'>
                        <SelectItem value="0">Public</SelectItem>
                        <SelectItem value="1">Private</SelectItem>
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