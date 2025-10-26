const express=require('express');
const router = express.Router();
const {addAccount,fetchAccount,deleteAccount,modifyAccount} = require('../controllers/accountController');
const {authenticateToken}=require('../middleware/auth');

router.post('/add',authenticateToken,addAccount);
router.get('/fetch',authenticateToken,fetchAccount);
router.patch('/modify',authenticateToken,modifyAccount);
router.delete('/delete',authenticateToken,deleteAccount);

module.exports=router;
