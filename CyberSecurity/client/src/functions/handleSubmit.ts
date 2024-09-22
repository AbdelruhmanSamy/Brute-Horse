import {toast} from "react-toastify";
import "react-toastify/dist/ReactToastify.css";


const handleSubmit = async (data: any, setError: any) => {
    const headers = {"Content-Type": "application/json"};
    const BASEURL = "http://localhost:3000"  
    const path = BASEURL +'/vulnerability/scan';     
    const toastId = toast.loading("submitting form, please wait", {autoClose: false, isLoading: true});

    console.log(data)
    try {
        const response = await fetch(path, {
            method: "POST",
            headers: headers,
            body: JSON.stringify(data),
        })


        const result = await response.json();
        console.log(result, "result")   
        if (result.status === 200) {
            toast.update(toastId, {
                render: result.message,
                type: 'success',
                autoClose: 3000,
                isLoading: false
            });
        } else {
            toast.update(toastId, {
                render: result.message,
                type: 'error',
                autoClose: 3000,
                isLoading: false
            });

            if (result.errors) {
                result.errors.map((error: any) => {
                    if (error.id)
                        setError(error.id, {type: 'custom', message: error.message})
                })
            }
        }
    } catch (error: any) {
        console.log("error", error)

        toast.update(toastId, {
            render: error.message,
            type: 'error',
            autoClose: 3000,
            isLoading: false
        });
    }
};

export default handleSubmit;
