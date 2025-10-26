const { PrismaClient } = require('@prisma/client');
require('dotenv').config();
const prisma = new PrismaClient();

//Add Account 
const addAccount =async(req,res)=>{
    try{
        const userId=req.user.id;
        const {name,currency,initialAmount}=req.body;
        const existingAccount=await prisma.account.findFirst({
            where : {
                userId:userId,
                name:name
            }
        });
        if(existingAccount){
            return res.status(400).json({ message: 'Account already exists' })
        }
        const newAccount=await prisma.account.create({
            data:{
                userId,
                name,
                currency,
                initialAmount,
                balance:initialAmount
            }
        });
        return res.status(201).json({ message: 'Account created successfully' });
    }catch(e){
        console.error(e);
        return res.status(500).json({ message: 'Internal server error' });
    }
    
}

//Fetch all accounts of a user
const fetchAccount =async(req,res)=>{
    try{
        const userId=req.user.id;
        const accounts=await prisma.account.findMany({
            where:{userId}
        });
        if(!accounts){
            return res.status(404).json({"message":"No accounts found"});
    
        }
        return res.status(200).json(accounts);
    }catch(e){
        res.status(500).json({"message":"Internal Server Error"});
    }
}

//Delete an account
const deleteAccount =async(req,res)=>{
    try{
        const userId=req.user.id;
        const {id}=req.body;
        const deleteAccount=await prisma.account.delete({
            where:{id}
        });
        if(!deleteAccount){
            res.status(404).json({"message":"error while deletion"});
        }
        res.status(200).json({"message":"Account Deleted Successfully"});
    }catch(e){
        res.status(500).json({"message":"Internal Server Error"});
    }
}

//Modify Balance
const modifyAccount =async(req,res)=>{
    try{
        const {newBalance,id}=req.body;
        const updateAccount=await prisma.account.update({
            where:{
                id
            },
            data:{
                balance:newBalance
            }
        });
        res.status(200).json({"message":"Balance Updated Securely"});
    }catch(e){
        res.status(500).json({"message":"Internal Server Error"});
    }
}


module.exports={
    addAccount,
    fetchAccount,
    deleteAccount,
    modifyAccount
}