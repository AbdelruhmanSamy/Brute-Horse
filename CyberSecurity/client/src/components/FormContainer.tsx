import MinimalForm from './MinimalForm'
import { FormInterface } from '../types/types'

function FormContainer(props: FormInterface) {
    const {
        title,
        subTitle,
        sections
    } = props

    return (
        <div className='mb-20 h-fit p-4 py-6 flex flex-col items-center border border-neutral-2 rounded-2xl shadow-xl w-[90%] max-w-md md:max-w-lg lg:max-w-3xl font-body text-regular-grey gap-2'>
            <h1 className='text-4xl text-center font-bold'>{title}</h1>
            <hr className={'w-1/2 border-t-2 border-2xl border-primary border-call-to-action'}/>
            <p className='text-xl'>{subTitle}</p>
            <MinimalForm sections={sections}/>
        </div>
    )
}

export default FormContainer
