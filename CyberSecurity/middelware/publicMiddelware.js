const net = require("net")
function ipValidation(req, res, next) {
  const ip = req.body.ip;
  if (net.isIP(ip) !== 0) return next();
  return res.status(400).json({ error: 'Invalid IP provided' });
}
module.exports = { ipValidation }