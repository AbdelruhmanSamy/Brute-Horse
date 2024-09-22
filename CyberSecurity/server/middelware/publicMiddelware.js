const net = require("net")
const { v4: uuidv4 } = require('uuid');
// this check the ip is correct
function ipValidation(req, res, next) {
  const ip = req.body.ip;
  if (net.isIP(ip) !== 0) return next();
  return res.status(400).json({ message: 'Invalid IP provided' });
}
// this must call before execute the series of controllers
function startProcess(req,res,next)//each user has a uniuq Id to craete a folder
{
   req.body.uniqueId = uuidv4();
   return next()
}
module.exports = { ipValidation,startProcess }
