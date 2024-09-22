import {toast} from "react-toastify";
import "react-toastify/dist/ReactToastify.css";

const handleSubmit = async (data: any, setError: any) => {
    const headers = { "Content-Type": "application/json" };
    const BASEURL = "http://localhost:3000/vulnerability/"; // TODO: checkThis 
    const path = BASEURL + 'scan';
    const toastId = toast.loading("Submitting form, please wait", { autoClose: false, isLoading: true });

    try {
        const response = await fetch(path, {
            headers: headers,
            method: "POST",
            body: JSON.stringify(data),
        });

        // Check if the response is a ZIP file (or any other file type)
        const contentType = response.headers.get("content-type");

        if (response.ok && contentType ) {
            const blob = await response.blob(); // Get the response as a blob
            const downloadUrl = window.URL.createObjectURL(blob); // Create a URL for the blob
            const link = document.createElement('a'); // Create a temporary anchor element
            link.href = downloadUrl;
            link.download = 'scan_results.zip'; // Set the download file name
            document.body.appendChild(link);
            link.click(); // Programmatically click the anchor to trigger download
            document.body.removeChild(link); // Clean up by removing the link

            toast.update(toastId, {
                render: "File downloaded successfully",
                type: 'success',
                autoClose: 3000,
                isLoading: false
            });
        } else {
            const result = await response.json(); // Handle JSON response if not a ZIP file

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
                            setError(error.id, { type: 'custom', message: error.message });
                    });
                }
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
