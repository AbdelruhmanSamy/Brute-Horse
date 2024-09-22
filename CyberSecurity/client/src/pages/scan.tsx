import FormContainer from '../components/FormContainer'
import { formData } from '../data/data'

function Scan() {

    return (    
        <div 
        className="
        w-full
        bg-gradient-to-r from-regular-blue from-60% via-light-blue via-80% to-regular-blue to-95%
        flex
        justify-center
        ">
            <FormContainer {...formData}/>
        </div>
    )
}

export default Scan
