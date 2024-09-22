export enum InputTypes{
    text,
    radio,
    select,
    url,
    checkbox
}


export interface TextInputInterface{
    label:string,
    name:string,
    dependentOn?:{key:string , value:any}[]
}

export interface SelectOptionsInterface{
    value:string,
    label:string,
}

export interface SelectInputInterface{
    label:string,
    defaultValue:string,
    helperText:string,
    options:SelectOptionsInterface[],
    id:string,
}

export interface RadioOptionInterface{
    id:string,
    label:string,
    value:string

}

export interface RadioInputInterface{
    id:string,
    title:string,
    options:RadioOptionInterface[]
}


export interface CheckBoxInterface{
    id:string,
    label:string,
    isChecked:boolean
    isEnabled:boolean
}

export interface InputInterface{
    required: boolean,
    type: InputTypes,
    data: TextInputInterface | SelectInputInterface | RadioInputInterface | CheckBoxInterface
}

export interface SectionInterface{
    id:string,
    title:string,
    inputs:InputInterface[]
}

export interface FormInterface{
    title:string,
    subTitle:string,
    sections:SectionInterface[]
}

