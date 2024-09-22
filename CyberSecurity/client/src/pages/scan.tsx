import FormContainer from "../components/FormContainer";
import { formData } from "../data/data";
import logo from "../assets/logo.png";

function Scan() {
  return (
    <div
      className="
        w-full
        bg-regular-blue 
        flex
        flex-col
        items-center
        justify-center
        pt-10
        "
    >
        <div className="flex justify-center items-center">
            <h1 className="font-header text-8xl text-regular-grey">BruteHorse</h1>
            <img src={logo} className="w-60" />
        </div>
      <FormContainer {...formData} />
    </div>
  );
}

export default Scan;
