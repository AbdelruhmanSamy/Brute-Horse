import { FormInterface, InputTypes , TextInputInterface , RadioInputInterface, CheckBoxInterface } from "../types/types";


const ftpSection = {
    id: "ftpSection",
    title: "FTP Login",
    inputs:[
    {
        required:true,
        type:InputTypes.radio,
        data:{
            id:"ftpChoice",
            title: "Exploitation Type",
            options:[
                {
                    id:"1",
                    label:"Anonymous login",
                    value:"Anonymous login"
                },
                {
                    id:"2",
                    label:"Password breaking only",
                    value:"Password breaking only"
                },  
                {
                    id:"3",
                    label:"Username & password breaking",
                    value:"Username & password breaking"
                },
            ]
        } as RadioInputInterface
    },
    {
        required: true,
        type:InputTypes.text,
        data:{
            label:"Username",
            name:"ftpUsername",
            dependentOn:[{key:"ftpChoice", value:"Username & password breaking"}]
        } as TextInputInterface
    },
]
}
const smbSection = {
    id: "smbSection",
    title: "SMB Login",
    inputs:[
    {
        required:true,
        type:InputTypes.radio,
        data:{
            id:"smbChoice",
            title: "Exploitation Type",
            options:[
                {
                    id:"1",
                    label:"Anonymous login",
                    value:"Anonymous login"
                },
                {
                    id:"2",
                    label:"Password breaking only",
                    value:"Password breaking only"
                },  
                {
                    id:"3",
                    label:"Username & password breaking",
                    value:"Username & password breaking"
                },
            ]
        } as RadioInputInterface
    },
    {
        required: true,
        type:InputTypes.text,
        data:{
            label:"Username",
            name:"smbUsername",
            dependentOn:[{key:"smbChoice" , value:"Username & password breaking"}]
        } as TextInputInterface
    },
]
}

const portScanningSection = {
    id: "portScanning",
    title: "Port Scan",
    inputs:[
    {
        required:true,
        type:InputTypes.radio,
        data:{
            id:"portScanType",
            title: "Scan Type",
            options:[
                {
                    id:"nse",
                    label:"nse",
                    value:"nse"
                },
                {
                    id:"wapiti",
                    label:"wapiti",
                    value:"wapiti"
                },
                {
                    id:"both",
                    label:"Both",
                    value:"Both"
                } 
            ]
        }as RadioInputInterface
    },
]
}

const nmapSection = {
    id:"nmapSection",
    title:"nmap Scan",
    inputs:[
        {
            required:true,
            type:InputTypes.radio,
            data:{
                id:"nmapScanType",
                title:"Scan Type",
                options:[
                    {
                        id:"1",
                        label:"SYN Scan",
                        value:"-sS"
                    },
                    {
                        id:"2",
                        label:"TCP Scan",
                        value:"-sT"
                    },
                    {
                        id:"3",
                        label:"NULL Scan",
                        value:"-sN"
                    },
                    {
                        id:"4",
                        label:"UDP Scan",
                        value:"-sU"
                    },
                    {
                        id:"5",
                        label:"Xmas Scan",
                        value:"-sX"
                    },
                ]
            }as RadioInputInterface
    },

    {
        required:true,
        type: InputTypes.radio,
        data:{
            id:"scanSpeed",
            title: "Scan Speed",
            options:[
                {
                    id:"1",
                    label:"1",
                    value:"1"
                },
                {
                    id:"2",
                    label:"2",
                    value:"2"
                },
                {
                    id:"3",
                    label:"3",
                    value:"3"
                },
                {
                    id:"4",
                    label:"4",
                    value:"4"
                },
                {
                    id:"5",
                    label:"5",
                    value:"5"
                },
                
                ]
            }as RadioInputInterface
        },
        
        {
            required:false,
            type: InputTypes.checkbox,
            data:{
                id:"rangeScan",
                label:"range Scan",
                isChecked: false,
                isEnabled: true
            } as CheckBoxInterface
        },

        {
                required:true,
                type:InputTypes.text,
                data:{
                    label:"Start port",
                    name:"startPort",
                    dependentOn:[{key: "rangeScan" , value:true}]
                }as TextInputInterface
        },

        {
                required:true,
                type:InputTypes.text,
                data:{
                    label:"End Port",
                    name:"endPort",
                    dependentOn:[{key: "rangeScan" , value:true}]
                }as TextInputInterface
            },

        {
                required:true,
                type: InputTypes.checkbox,
                data:{
                    id:"verbosity",
                    label:"Verbosity",
                    isChecked: true,
                    isEnabled: true
                } as CheckBoxInterface
        }
    ]
}


const sqliSection = {
    id: "sqli",
    title: "SQL Injection",
    inputs:[
    {
        required:true,
        type:InputTypes.text,
        data:{
            label:"URL",
            required: true,
            name:"url"
        } as TextInputInterface
    },
    {
        required:false,
        type:InputTypes.text,
        data:{
            label:"Params",
            required: false,
            name:"param"
        } as TextInputInterface
    },
    {
        required:false,
        type:InputTypes.text,
        data:{
            label:"Database",
            required: false,
            name:"database"
        } as TextInputInterface
    },

    {
        required:false,
        type:InputTypes.text,
        data:{
            label:"Table",
            required: false,
            name:"table"
        } as TextInputInterface
    },

    {
        required:false,
        type:InputTypes.text,
        data:{
            label:"Column",
            required: false,
            name:"column"
        } as TextInputInterface
    },      
]
}
export const ipInputData = {
    required:true,
    type:InputTypes.text,
    data:{
        label:"IP Address",
        required: true,
        name:"ip"
        //TODO: add dependentOn
    } as TextInputInterface
}

export const formData: FormInterface = {
    title:"Scan & Exploit Vulnerabilities",
    subTitle:"your easy way to hacking",
    sections:[
        nmapSection,
        ftpSection,
        smbSection,
        portScanningSection,
        sqliSection
    ]
}