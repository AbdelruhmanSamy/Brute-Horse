const net = require("net")
// this check the ip is correct
function ipValidation(req, res, next) {
  const ip = req.body.ip;
  if (net.isIP(ip) !== 0) return next();
  return res.status(400).json({ message: 'Invalid IP provided' });
}
// this must call before execute the series of controllers

module.exports = { ipValidation }
