import { createBrowserRouter, RouterProvider } from "react-router-dom"
import Home from "./pages/Home"
import Scan from "./pages/scan"

const router = createBrowserRouter(
  [
    {
      path:"/",
      element:<Home/>
    },
    {
      path:"/scan",
      element:<Scan/>
    }
  ]
)

function App() {
  return (      
    <RouterProvider router={router}/>
  )
}

export default App
