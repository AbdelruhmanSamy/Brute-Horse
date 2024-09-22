import {toast} from "react-toastify";
import "react-toastify/dist/ReactToastify.css";


const handleSubmit = async (data: any, setError: any) => {
    const headers = {"Content-Type": "application/json"};
    const path = '/api/formSubmit'; //TODO: change this
    const toastId = toast.loading("submitting form, please wait", {autoClose: false, isLoading: true});

    try {
        const response = await fetch(path, {
            headers: headers,
            method: "GET",
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
        toast.update(toastId, {
            render: error.message,
            type: 'error',
            autoClose: 3000,
            isLoading: false
        });
    }
};

export default handleSubmit;
