const bcrypt = require('bcryptjs');
const { PrismaClient } = require('@prisma/client');
const jwt = require('jsonwebtoken');
require('dotenv').config();
const prisma = new PrismaClient();

// Sign Up Controller
const signUp = async (req, res) => {
    const { name, email, password } = req.body;
    try {
        const existingUser = await prisma.user.findUnique({ where: { email } });
        if(existingUser){
            return res.status(400).json({ message: 'User already exists' });
        }
        const hashedPassword = await bcrypt.hash(password, 10);
        const newUser=await prisma.user.create({
            data: {
                name,
                email,
                password: hashedPassword
            }
        });
        return res.status(201).json({ message: 'User created successfully' });
    }catch(e){
        console.error(e);
        return res.status(500).json({ message: 'Internal server error' });
    }
}

// Log In Controller
const logIn = async (req, res) => {
    const { email, password } = req.body;
    try{
        const user =await prisma.user.findUnique({ where: { email } });
        if(!user){
            return res.status(400).json({ message: 'Invalid email or password' });
        }
        const isPasswordValid=await bcrypt.compare(password, user.password);
        if(!isPasswordValid){
            return res.status(400).json({ message: 'Invalid email or password' });
        }
        const token=jwt.sign({ userId: user.id }, process.env.JWT_SECRET);
        res.status(200).json({message:"Login Successful", token });
    }catch(e){
        console.error(e);
        return res.status(500).json({ message: 'Internal server error' });
    }
}
module.exports = { signUp, logIn };