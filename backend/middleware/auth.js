const jwt = require('jsonwebtoken');
const { PrismaClient } = require('@prisma/client'); // your prisma client
const prisma = new PrismaClient();
// Middleware to protect routes
const authenticateToken = async (req, res, next) => {
  try {
    // Get token from Authorization header: "Bearer <token>"
    const authHeader = req.headers['authorization'];
    if (!authHeader) return res.status(401).json({ message: 'No token provided' });

    const token = authHeader.split(' ')[1];
    if (!token) return res.status(401).json({ message: 'Invalid token' });

    // Verify token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    if (!decoded) return res.status(401).json({ message: 'Token invalid or expired' });

    // Optionally, fetch the user from DB to attach to req
    const user = await prisma.user.findUnique({
      where: { id: decoded.userId },
      select: { id: true, email: true, name: true } // only expose needed fields
    });

    if (!user) return res.status(401).json({ message: 'User not found' });

    req.user = user; // attach user info to request
    next(); // continue to controller
  } catch (err) {
    console.error(err);
    return res.status(401).json({ message: 'Unauthorized' });
  }
};

module.exports = { authenticateToken };
