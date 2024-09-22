const express=require("express")
const app=express()
const cors = require('cors');
const vulnerabilityRouters=require("./router/vulnerabilityRouter")

app.use(cors());
app.use(express.json())
app.use("/vulnerability",vulnerabilityRouters)
app.listen(3000, () => {
    console.log('Server is running on port 3000');
});

//to run this program write 
//npm install
//npm run devStart