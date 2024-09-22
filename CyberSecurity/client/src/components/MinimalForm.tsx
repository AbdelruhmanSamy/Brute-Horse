'use client'
import { useForm } from "react-hook-form"
import { CheckBoxInterface, InputInterface , InputTypes, SectionInterface} from "../types/types"
import Input from "./Input"
import handleSubmit from "../functions/handleSubmit"
import { ToastContainer } from "react-toastify"
import { ipInputData } from "../data/data"

interface MinimalFormProps {
    sections: SectionInterface[]
}

interface SectionProps{
    section:SectionInterface,
    register:any,
    errors:any, 
    control:any,
    watch:any   
}

function Section({section, watch, register, errors, control}:SectionProps){

    const {id , title , inputs} = section

    const checkboxInput:InputInterface = {
        required: false,
        type: InputTypes.checkbox,
        data:{
            id: id,
            label: title,
            isChecked: false,
            isEnabled: true
        }as CheckBoxInterface
    }

    const formValues = watch()

   return(
    <div className="w-full flex flex-col gap-1">
        <h1 className="text-3xl font-bold">{title}</h1>
        <hr className={'w-full border-t-2 border-2xl border-primary border-call-to-action'}/>
        <Input watch={watch} enable={true} input={checkboxInput} register={register} errors={errors} control={control}/>
        <div className="w-full flex flex-col gap-4">
            {
                inputs.map((input , index)=>{
                    return(
                        <Input watch={watch} input={input} enable={formValues[id]} key={index} register={register} errors={errors} control={control} />
                        )           
                    })  
            }
        </div>
    </div>
    )
}

function MinimalForm({sections}: MinimalFormProps) {

    const {watch, control,register, handleSubmit: handleUseFormRequest, formState: {errors}, setError} = useForm();

    const submit = async (data: any) => {
        console.log(data)
        await handleSubmit({...data}, setError);
    }


    

    return (
        <>
            <form className="w-full max-w-sm flex flex-col gap-10 mt-5 items-start text-xl" onSubmit={handleUseFormRequest(submit)}>
                <Input watch={watch} enable={true} input={ipInputData} register={register} errors={errors} control={control}  />
                
                {
                    sections.map((section , index)=>{ 
                        return(
                            <Section watch={watch} section={section} key={index} register={register} errors={errors} control={control} />
                        )           
                    })  
                }

                <button type="submit" className='bg-call-to-action w-[250px] h-[50px] rounded-2xl text-black self-center '>Start scanning</button>
            </form>
            <ToastContainer
            position={'top-center'}
            autoClose={5000}
            style={{
                width: "400px"
            }}
            hideProgressBar={false}
            newestOnTop={false}
            closeOnClick
            rtl={false}
            pauseOnFocusLoss
            draggable
            pauseOnHover
            />
        </>
    )
}

export default MinimalForm
