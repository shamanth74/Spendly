const express = require('express')
require('dotenv').config();
const port = process.env.PORT || 3000;
const { PrismaClient } = require('@prisma/client');

const app = express();
const prisma = new PrismaClient();

app.get('/', async (req, res) => {
  try {
    res.send("Hello World!");
  } catch (err) {
    console.error(err);
    res.status(500).send('Error connecting to database');
  }
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})
