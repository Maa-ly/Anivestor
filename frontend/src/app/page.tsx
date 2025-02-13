"use client"
import Image from "next/image";
import infantCattleImage from "../../public/images/infantCattle.png"
import RegisterFarmer from "@/components/popup/registerFarmer";
import { useEffect } from "react";
import { web3mail } from "@/backend/web3mail";

export default function Home() {
   useEffect(() => {
      async function protectData() {
         const res = await web3mail.fetchMyContacts()
         console.log("heloo")
         console.log(res)
      }
      protectData()
   })
   return (
      <main className="bg-[#000814] text-white">


         {/* hero section */}
         <section className="w-full h-[90vh] lg:h-[80vh] bg-[#000814] flex gap-0 p-10 flex-col lg:flex-row">
            <Image src={infantCattleImage} alt="animal" className="w-[60vw] xl:w-[40vw] xl:h-[40vh] h-[60vh] right-5 bottom-[10rem] absolute opacity-70 z-0" />
            <div className="w-full lg:w-1/2 h-1/2 lg:h-full bg-red-00 flex flex-col shrink-0 justify-center xl:pl-[10rem] z-10">
               <h2 className="text-4xl lg:text-[2.5rem] w-[80%] font-extrabold font-[neco] tracking-tight leading-[2.6rem] ">Empowering Farmers <br /> Connecting Investors <br /> Unlocking Value in Livestock</h2>
               <p className="text-[15px] py-5 font-[switzer] leading-6 tracking-wider">Join a decentralized platform where farmers create livestock investment opportunities, and buyers earn profits through fractional ownership of farm assets. Invest, trade, and grow—securely and transparently with blockchain technology.</p>
               <div className="flex gap-2">
                  <RegisterFarmer />
                  {/* <button className="p-1 px-5 bg-blue-00 rounded-xl border-blue-400 border-solid border-[1px]">Call Us</button> */}
               </div>
            </div>
            <div className="w-full lg:w-1/2 h-1/2 lg:h-full bg-red-00 flex flex-row items-end justify-center gap-10 p-5 lg:flex-row">
               <div className="w-[15rem] lg:w-[15rem] lg:h-[12rem] h-[12rem] bg-blue-200/40 rounded-xl drop-shadow-md backdrop:blur-sm shrink-0 p-5">

                  <div className="w-full flex justify-start gap-2 rounded-xl">
                     <span className="w-6 h-6 rounded-full bg-red-300 flex justify-center items-center">h</span>
                     <p className="font-semibold">Sales</p>
                  </div>
               </div>
               <div className="w-[40vw] lg:w-[20vw] h-[95%] lg:h-[50vh] bg-white/30 rounded-xl drop-shadow-md backdrop:blur-sm shrink-0 p-5">
                  <div className="w-full flex flex-col justify-start gap-2 rounded-xl">
                     {/* <span className="w-6 h-6 rounded-full bg-red-300 flex justify-center items-center">h</span> */}

                     <p className="font-semibold">Total Value</p>
                     <h3 className="text-3xl font-serif">$ 31,3434,090</h3>
                  </div>

                  <div className="w-full h-[3rem] bg-white/5 backdrop:blur-md shadow-md rounded-md flex justify-between items-center px-2 mt-2">
                     <div className="flex items-center gap-1">
                        <span className="w-2 h-2 rounded-full bg-red-500"></span>
                        <p>New</p>
                     </div>
                     <p>60.47%</p>
                  </div>
               </div>
            </div>
         </section>


         {/* statistics */}
         <section className="w-full flex justify-center items-center gap-4 py-20">

            <div className="lg:w-[15rem] lg:h-[10rem] w-[10rem] h-[8rem] bg-white/40 shadow-sm backdrop-blur-md rounded-xl flex flex-col justify-center items-center ">
               <h1 className="font-bold text-4xl">12M +</h1>
               <p>Projects Sold</p>
            </div>
            <div className="lg:w-[15rem] lg:h-[10rem] w-[10rem] h-[8rem] bg-white/40 shadow-sm backdrop-blur-md rounded-xl flex flex-col justify-center items-center ">
               <h1 className="font-bold text-4xl">12M +</h1>
               <p>Projects Sold</p>
            </div>
            <div className="lg:w-[15rem] lg:h-[10rem] w-[10rem] h-[8rem] bg-white/40 shadow-sm backdrop-blur-md rounded-xl flex flex-col justify-center items-center ">
               <h1 className="font-bold text-4xl">12M +</h1>
               <p>Projects Sold</p>
            </div>
            <div className="lg:w-[15rem] lg:h-[10rem] w-[10rem] h-[8rem] bg-white/40 shadow-sm backdrop-blur-md rounded-xl flex flex-col justify-center items-center ">
               <h1 className="font-bold text-4xl">12M +</h1>
               <p>Projects Sold</p>
            </div>
         </section>


         {/* About Anivestor */}
         <section className="w-full h-[50vh] flex flex-col items-center p-10 py-[8rem]">
            <h2 className="text-3xl text-center w-[80%]">With Anivestor, you are not just investing but you are building trust</h2>
            <p className="text-center my-5 w-[50%]">Lorem ipsum dolor sit amet consectetur adipisicing elit. Quidem quod iste tempore nemo corrupti facere repudiandae ducimus minima esse assumenda veniam, magni a. Voluptatum placeat iste commodi aut repudiandae nulla.</p>

            <div className="flex mt-5">
               <div className="w-[10rem] flex flex-col items-center">
                  <span className="m-2 w-[4rem] h-[4rem] flex rounded-full bg-white"></span>
                  <p id="name" className="font-semibold text-center">Howard Edward</p>
                  <p id="title" className="text-[12px] text-center">Founder of Ed</p>
               </div>
               <div className="w-[10rem] flex flex-col items-center">
                  <span className="m-2 w-[4rem] h-[4rem] flex rounded-full bg-white"></span>
                  <p id="name" className="font-semibold text-center">Howard Edward</p>
                  <p id="title" className="text-[12px] text-center">Founder of Ed</p>
               </div>
               <div className="w-[10rem] flex flex-col items-center">
                  <span className="m-2 w-[4rem] h-[4rem] flex rounded-full bg-white"></span>
                  <p id="name" className="font-semibold text-center">Howard Edward</p>
                  <p id="title" className="text-[12px] text-center">Founder of Ed</p>
               </div>
               <div className="w-[10rem] flex flex-col items-center">
                  <span className="m-2 w-[4rem] h-[4rem] flex rounded-full bg-white"></span>
                  <p id="name" className="font-semibold text-center">Howard Edward</p>
                  <p id="title" className="text-[12px] text-center">Founder of Ed</p>
               </div>
            </div>
         </section>

         {/* Benefits */}
         <section className="w-full py-[8rem] px-10 xl:pl-[10rem] flex justify-center">
            <div className="">

               <p className="text-blue-400 py-2">Benefits</p>
               <h2 className="font-bold text-3xl break-words w-[30%] py-3">Your Benefit working with us</h2>
               <p className="mb-10 w-[30rem]">Lorem ipsum dolor sit amet consectetur adipisicing elit. Expedita hic, repellat sint maiores vitae ipsa fuga atque nostrum soluta est officiis. Suscipit laborum, illo corporis eius voluptas modi neque alias?</p>

               <div className="flex gap-4 max-w-[50rem]  overflow-x-scroll flex-nowrap">
                  <div className="w-[20rem] h-[25rem] bg-white/20 backdrop:blur-md rounded-xl p-5 px-3 border-solid border-[0.5px] border-current/5 flex flex-col justify-end relative ">
                     <span className="absolute top-4">icon</span>

                     <span className="font-mono font-thin">01</span>
                     <h2 className="font-semibold text-xl border-b-[0.5px] border-b-solid py-1 mb-4">Take Care of the world with us</h2>
                     <p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Nobis nam ratione enim aliquam corrupti earum placeat, quo nemo, id sequi in alias aliquid debitis quas, sapiente doloremque ullam deserunt quod.</p>
                  </div>
                  <div className="w-[20rem] h-[25rem] bg-white/20 backdrop:blur-md rounded-xl p-5 px-3 border-solid border-[0.5px] border-current/5 flex flex-col justify-end relative">
                     <span className="absolute top-4">icon</span>

                     <span className="font-mono font-thin">01</span>
                     <h2 className="font-semibold text-xl border-b-[0.5px] border-b-solid py-1 mb-4">Take Care of the world with us</h2>
                     <p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Nobis nam ratione enim aliquam corrupti earum placeat, quo nemo, id sequi in alias aliquid debitis quas, sapiente doloremque ullam deserunt quod.</p>
                  </div>
                  <div className="w-[20rem] h-[25rem] bg-white/20 backdrop:blur-md rounded-xl p-5 px-3 border-solid border-[0.5px] border-current/5 flex flex-col justify-end relative">
                     <span className="absolute top-4">icon</span>

                     <span className="font-mono font-thin">01</span>
                     <h2 className="font-semibold text-xl border-b-[0.5px] border-b-solid py-1 mb-4">Take Care of the world with us</h2>
                     <p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Nobis nam ratione enim aliquam corrupti earum placeat, quo nemo, id sequi in alias aliquid debitis quas, sapiente doloremque ullam deserunt quod.</p>
                  </div>
               </div>
            </div>
         </section>


         {/* Our clients */}
         <section className="w-full h-[60vh] flex flex-col items-center px-10">
            <h2 className="text-center text-4xl w-[50%]">Our Clients are worlds Best and Well Known Companies</h2>
            <div className="grid grid-cols-4 col-auto row-auto mt-20 text-black">
               <div className="w-[12rem] h-[10rem] bg-white flex justify-center items-center">Solana</div>
               <div className="w-[12rem] h-[10rem] bg-white flex justify-center items-center">Solana</div>
               <div className="w-[12rem] h-[10rem] bg-white flex justify-center items-center">Solana</div>
               <div className="w-[12rem] h-[10rem] bg-white flex justify-center items-center">Solana</div>
               <div className="w-[12rem] h-[10rem] bg-white flex justify-center items-center">Solana</div>
               <div className="w-[12rem] h-[10rem] bg-white flex justify-center items-center">Solana</div>
               <div className="w-[12rem] h-[10rem] bg-white flex justify-center items-center">Solana</div>
               <div className="w-[12rem] h-[10rem] bg-white flex justify-center items-center">Solana</div>
            </div>
         </section>

      </main>

   );
}