// UserNameTextField.jsx
const UserNameTextField = ({ userName, setUserName }) => {
    
    let onChange = (event) => {
        setUserName(event.target.value);
    }

    return (
        <div className="mt-10 justify-center">
            <label className="font-bold text-lg">
                Username:
            </label>
            <input 
                type="text" 
                placeholder="username" 
                onChange={onChange} 
                value={userName}
                className="p-3 pr-12 block w-full border border-gray-200 rounded-md text-sm shadow-md focus:border-blue-500 focus:ring-blue-500"
            />
        </div>
    );
};

export default UserNameTextField;
