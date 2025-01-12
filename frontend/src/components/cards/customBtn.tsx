"use client"
import React, { useState } from 'react'
import { Button } from '../ui/button'
import { useToast } from "../../hooks/use-toast"
import { ToastAction } from "../ui/toast"
import { useAccount } from 'wagmi'
const CustomBtn = ({ btn, handleClick }: { btn?: string, handleClick?: Function }) => {
   const [loading, setLoading] = useState(false)
   const { toast } = useToast()
   const account = useAccount();
   const click = async () => {
      if (account.isDisconnected) return toast({
         variant: "destructive",
         title: "Wallet not connected",
         description: "Please connect your wallet and try again",
         // action: <ToastAction altText="Try again">Try again</ToastAction>,
      });
      // switchChain(5115)
      setLoading(true)

      if (handleClick) {
         try {
            const result = await handleClick();
            toast({
               title: "Success",
               description: result.success,
            })
         } catch (error) {
            console.log(error);
            toast({
               variant: "destructive",
               title: "Uh oh! Something went wrong.",
               description: `There was a problem with your request`,
               // action: <ToastAction altText="Try again">Try again</ToastAction>,
            })
         }
      }
      setLoading(false)
   }
   return (
      // <button className='btn w-full bg-blue-900/90 border-0 hover:bg-blue-900 mt-4 text-white disabled:bg-blue-900/80 disabled:text-white' onClick={click} disabled={loading}>
      <Button type="submit" className="w-full" onClick={click} disabled={loading} >
         {loading ?
            <span className="loading loading-dots loading-md"></span> :
            btn || "Submit"
         }
      </Button>
   )
}
export default CustomBtn
