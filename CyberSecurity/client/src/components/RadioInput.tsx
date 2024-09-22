import { RadioInputInterface , RadioOptionInterface } from '../types/types'

interface Props {
    data:RadioInputInterface,
    register:any,
    errors:any,
    enable: boolean
}     

function RadioInput({data, enable,  register}:Props) {

    const {title , options} = data
    return (
        <div className='w-full flex flex-col gap-1'>
            <h1 className='font-semibold text-2xl'>{title}</h1>
            <div className='flex flex-col justify-around align-center gap-1'>
                {options.map((option:RadioOptionInterface)=>{
                    const {
                        id,
                        label,
                        value
                    } = option
                    
                    return(
                        <div className='flex flex-row gap-2' key={id}>
                            <input type="radio" id={id} name={title} value={value} {...register(data.id)} color='black' disabled={!enable}/>
                            <label id={id}>{label}</label>
                        </div>
                    )
                    })
                }
            </div>
        </div>
    )
}

export default RadioInput
