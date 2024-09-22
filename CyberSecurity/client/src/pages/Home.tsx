import logo from "../assets/logo.png"
import { Link } from 'react-router-dom'

interface Props {}

function Home(props: Props) {
    const {} = props


    return (
        <div 
        className="
        h-screen w-full
        bg-gradient-to-r from-regular-blue from-60% via-light-blue via-80% to-regular-blue to-95%
        relative
        ">
             <img src={logo} className="w-85 absolute top-1/4 left-2/3" />

            <div className='pl-[5%] pt-[10%] text-regular-grey text-4xl font-body w-[50%] flex flex-col'>
                <h1 className='font-header text-8xl'>BruteHorse</h1>
                <p className=' mt-10'>Your way for smarter pentesting: 
                automate network scans, find SQL injections, detect open ports and more features!!</p>

                <Link to={"/scan"}>
                    <button className='bg-call-to-action w-[350px] h-[75px] mt-20 rounded-2xl text-black text-center align-bottom' >
                        Start scanning
                    </button>
                </Link>
            </div>
        </div>
    )
}

export default Home
