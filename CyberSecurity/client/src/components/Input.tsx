import RadioInput from "./RadioInput";
import {
  TextField,
  MenuItem,
  FormControlLabel,
  Checkbox,
  colors,
} from "@mui/material";
import {
  InputInterface,
  RadioInputInterface,
  TextInputInterface,
  SelectInputInterface,
  InputTypes,
  CheckBoxInterface,
} from "../types/types";
import { Controller } from "react-hook-form";
import { act } from "react";

interface Props {
  input: InputInterface;
  enable: boolean;
  register: any;
  errors: any;
  control: any;
  watch: any; 
}

// Type guard functions
function isTextInputInterface(data: any): data is TextInputInterface {
  return (data as TextInputInterface).name !== undefined;
}

function isSelectInputInterface(data: any): data is SelectInputInterface {
  return (data as SelectInputInterface).defaultValue !== undefined;
}

function isRadioInputInterface(data: any): data is RadioInputInterface {
  return (data as RadioInputInterface).title !== undefined;
}

function isCheckBoxInputInterface(data: any): data is CheckBoxInterface {
  return (data as CheckBoxInterface).isChecked !== undefined;
}

function Input({
  input,
  watch,
  enable,
  register,
  errors,
  control,
}: Props) {
  const { required, type, data } = input;

  const registerOptions = {
    required: required ? "this field is required" : false,
  };

  const regularGrey = "#CCC5C5";

  switch (true) {
    case isRadioInputInterface(data) && type == InputTypes.radio:
      return (
        <RadioInput
          enable={enable}
          data={data}
          register={register}
          errors={errors}
        />
      );

    case isSelectInputInterface(data) && type == InputTypes.select:
      return (
        <TextField
          color="warning"
          id="standard-select-currency"
          fullWidth
          select
          label={data.label}
          defaultValue={data.defaultValue}
          helperText={data.helperText ? data.helperText : ""}
          variant="standard"
          disabled={!enable}
          {...register(data.id, registerOptions)}
        >
          {data.options.map((option) => (
            <MenuItem key={option.value} value={option.value}>
              {option.label}
            </MenuItem>
          ))}
        </TextField>
      );
    case isTextInputInterface(data) &&
      (type == InputTypes.text || type == InputTypes.url):

      const activate = data.dependentOn? data.dependentOn.reduce((accumulator, currentValue) => {
        return accumulator &&  watch(currentValue.key)=== currentValue.value;
      }, true):enable 
      return (
        <TextField
          {...register(data.name, registerOptions)}
          id="standard-basic"
          fullWidth
          variant="standard"
          label={data.label}
          required={required && enable && activate}  
          aria-placeholder={data.name}
          disabled={!(enable && activate)}
          sx={{
            input: {
              color: regularGrey, // Change input text color
            },
            "& label": {
              color: regularGrey, // Default label color (when not focused)
            },
            "& label.Mui-focused": {
              color: regularGrey, // Change label color when focused
            },
            "& .MuiInput-underline:before": {
              borderBottomColor: regularGrey, // Default underline color
            },
            "& .MuiInput-underline:hover:before": {
              borderBottomColor: regularGrey, // Underline color on hover
            },
            "& .MuiInput-underline:after": {
              borderBottomColor: regularGrey, // Underline color when focused
            },
          }}
        />
      );
    case isCheckBoxInputInterface(data) && type === InputTypes.checkbox:
      return (
        <Controller
          name={data.id}
          control={control}
          defaultValue={data.isChecked}
          rules={{ required: "You must agree to the terms" }}
          render={({ field }) => (
            <FormControlLabel
              control={
                <Checkbox
                  {...field}
                  checked={field.value}
                  sx={{
                    color: regularGrey, // Default checkbox color (unchecked)
                    "&.Mui-checked": {
                      color: regularGrey, // Checkbox color when checked
                    },
                    "&.MuiCheckbox-indeterminate": {
                      color: regularGrey, // Color when indeterminate
                    },
                    "&:hover": {
                      color: regularGrey, // Checkbox color on hover (unchecked)
                    },
                    "&.Mui-checked:hover": {
                      color: regularGrey, // Checkbox color on hover (checked)
                    },
                  }}
                />
              }
              label={data.label}
            />
          )}
        />
      );
    default:
      throw Error("Undefined input type");
  }
}

export default Input;
