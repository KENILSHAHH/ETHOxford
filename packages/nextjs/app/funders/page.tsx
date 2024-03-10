"use client";

import Image from "next/image";
import type { NextPage } from "next";
import { SkeletonLoader } from "~~/components/fundguys/SkeletonLoader";
import { useFetchNFTs } from "~~/hooks/fundguys/usefetchNFTs";
import { useDeployedContractInfo } from "~~/hooks/scaffold-eth/";
import mnk from './mnk.png'
import nft from './NFT.png'
const Funders: NextPage = () => {
  const { data: mycologuysContract } = useDeployedContractInfo("Monkey");

  const { nfts, url, isLoading, error} = useFetchNFTs(mycologuysContract?.address || "");
const urlofnft = "bafkreigiv3f6t7sw7kd5zae243q74tbkmjgnvqxhakgjxp4gipkne4gfmu.ipfs.nftstorage.link"
  if (error) {
    console.log("nftsError", error);
  }

  // console.log("data", data);
  return (
    <>
      <div className="px-5 sm:px-7 md:px-20 my-10">
        <h3 className="text-7xl text-center font-madimi">Funders</h3>

        <p className="text-center text-2xl mt-10 mb-14">
          Check out all the funders who have contributed to public goods campaigns on FundGuys
        </p>

        <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
         
            <>

                <Image
                 
                  width={1000}
                  height={1000}
                  src={mnk}
                 alt="image"
                  className="rounded-xl"
            />
             <Image
                 
                  width={1000}
                  height={1000}
                  src={nft}
                 alt="image"
                  className="rounded-xl"
                />

            </>
          
        </div>
      </div>
    </>
  );
};

export default Funders;
