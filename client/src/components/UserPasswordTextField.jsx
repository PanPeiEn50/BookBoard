// UserPasswordTextField.jsx
import React from 'react';

const UserPasswordTextField = ({ label, userPassword, setUserPassword }) => {

    let onChange = (event) => {
        setUserPassword(event.target.value);
    }

    return(
        <div className="mt-10">
            <label className="font-bold text-lg mt-4">{label}</label >
           <input 
               type="password" // Changed to type password for security
               placeholder="password" 
               onChange={onChange} 
               value={userPassword} // Controlled component
               className="p-3 pr-12 block w-full border border-gray-200 rounded-md text-sm shadow-md focus:border-blue-500 focus:ring-blue-500"
           />
        </div>  
    );
};

export default UserPasswordTextField;
