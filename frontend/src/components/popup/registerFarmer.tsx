"use client"
import React, { useState } from 'react'
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from '../ui/dialog'
import { Button } from '../ui/button'
import { Label } from '../ui/label'
import { Input } from '../ui/input'
import CustomBtn from '../cards/customBtn'
import { useAccount } from 'wagmi'
import { farmerContract, switchChain } from '@/backend/web3'
import { dataProtectorCore } from '@/backend/dataProtector'
import { createArrayBufferFromFile } from '@iexec/dataprotector';
import { web3mail } from '@/backend/web3mail'

const RegisterFarmer = () => {
   const account = useAccount()

   const [value, setValue] = useState({
      name: "",
      owner: account.address,
      email: "",
      documentHash: "",
   })

   const [selectedFile, setSelectedFile] = useState<File | null>(null)
   // const [isProcessing, setIsProcessing] = useState(false)

   const handleFileChange = async (e: React.ChangeEvent<HTMLInputElement>) => {
      const file = e.target.files?.[0]
      if (file) {
         setSelectedFile(file)
         console.log(file)
         // Update the form state with the file name or other relevant info
         setValue(prev => ({
            ...prev,
            documentHash: file.name // or any other relevant file info you want to store
         }))
      }
   }


   async function protectData() {
      const fileAsArrayBuffer = await createArrayBufferFromFile(selectedFile as File);
      const protectedData = await dataProtectorCore.protectData({
         name: "Anivestor Farmer Document",
         data: {
            email: value.email,
            file: fileAsArrayBuffer,
         }
      })
      return protectedData;
   }
   // protectData()
   const handleChange = (e: any) => {
      setValue((value: any) => ({ ...value, [e.target.name]: e.target.value }))
   }
   console.log(value)

   const handleClick = async () => {
      try {
         await switchChain(134)
         const sendEmail = await web3mail.sendEmail({
            protectedData: "0xD8395a9Bb94Cb3cc9Df01eFC6C462DfB19Bf62ac",
            emailSubject: 'Farmer Registration',
            emailContent: `Farmer Documents sent for approval`,
            workerpoolAddressOrEns: 'prod-v8-bellecour.main.pools.iexec.eth',
            workerpoolMaxPrice: 4200000,
         });
         console.log(sendEmail)
         const res = await protectData()
         console.log(res.address)
         const grantedAccess = await dataProtectorCore.grantAccess({
            protectedData: res.address,
            authorizedApp: "0x781482C39CcE25546583EaC4957Fb7Bf04C277D2",
            authorizedUser: '0xf0830060f836B8d54bF02049E5905F619487989e',
         });

         console.log(grantedAccess)
         await switchChain(5115)
         let result = await farmerContract.methods.registerFarmer(value.name, res?.address).send({ from: account.address });
         result = {
            ...result,
            success: "Farmer Registration"
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
            {/* <button className="p-1 px-5 bg-blue-900 rounded-full ">Register as farmer</button> */}
            <Button>Register As Farmer</Button>
            {/* <Button variant="outline" className="text-black">Edit Profile</Button> */}
         </DialogTrigger>
         <DialogContent className="sm:max-w-[425px]">
            <DialogHeader>
               <DialogTitle className="text-black">Register Farmer</DialogTitle>
               <DialogDescription>
                  Make changes to your profile here. Click save when youre done.
               </DialogDescription>
            </DialogHeader>
            <div className="grid gap-4 py-4 text-black">
               <div className="grid grid-cols-4 items-center gap-4">
                  <Label htmlFor="name" className="text-left">
                     Farm name
                  </Label>
                  <Input name='name' id="name" className="col-span-5" placeholder="Noble's Farm" onChange={(e) => handleChange(e)} />
               </div>
               <div className="grid grid-cols-4 items-center gap-4">
                  <Label htmlFor="email" className="text-left">
                     Email
                  </Label>
                  <Input name='email' id="email" className="col-span-5" placeholder="kal@nyuiela" onChange={(e) => handleChange(e)} />
               </div>
               <div className="grid grid-cols-4 items-center gap-2">
                  <Label htmlFor="username" className="text-left">
                     Wallet
                  </Label>
                  <Input name='owner' id="owner" value={account.address || ""} onChange={() => { }} placeholder="0x3990sfee...234d" className="col-span-5" />
               </div>
               <div className="grid grid-cols-4 items-center gap-2">
                  <Label htmlFor="username" className="text-left">
                     DocumentHash
                  </Label> <br />
                  <Input name='documentHash' id="documentHash" className="col-span-5 h-[6rem] flex justify-center items-center text-center" type="file" onChange={(e) => handleFileChange(e)} />

               </div>


            </div>
            <DialogFooter>
               <CustomBtn handleClick={handleClick} />
               {/* <Button type="submit" className="w-full" >Submit</Button> */}
            </DialogFooter>
         </DialogContent>
      </Dialog>
   )
}

export default RegisterFarmer