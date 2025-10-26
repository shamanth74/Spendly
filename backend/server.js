const express = require('express')
require('dotenv').config();
const port = process.env.PORT || 3000;
const { PrismaClient } = require('@prisma/client');
const authRoutes = require('./routes/authRoutes.js');

const app = express();
const prisma = new PrismaClient();

app.use(express.json());
app.use('/api/auth', authRoutes);

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})
