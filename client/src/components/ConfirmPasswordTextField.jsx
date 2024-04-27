const ConfirmPassowrdTextField = ({ confirmPassword, setConfirmPassword }) => {
    let onChange = (event) => {
        setConfirmPassword(event.target.value);
    }

    return(
        <div className="mt-10">
            <label className="font-bold text-lg mt-4">
            Confirm Password:
            </label >
            <input type="password" placeholder="confirm password" onChange={onChange} value={confirmPassword} className="p-3 pr-12 block w-full border border-gray-200 rounded-md text-sm shadow-md focus:border-blue-500 focus:ring-blue-500"/>
        </div> 
    );
};

export default ConfirmPassowrdTextField;