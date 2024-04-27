import { useState } from 'react';
import UserPasswordTextField from '../../components/UserPasswordTextField';
import { API_BASE_URL } from '../../utils/constants';
import axios from 'axios';
import styles from './SettingPage.module.css';

const SettingPage = () => {
  const [userPassword, setUserPassword] = useState('');
  const [message, setMessage] = useState('');

  const changePassword = async () => {
    try {
      await axios.patch(`${API_BASE_URL}/api/user/`, {
        password: userPassword,
      });
      setMessage('The Password Is Updated!');
    } catch (error) {
      // error handling
      if (error.response && error.response.status === 400) {
        setMessage('User Is not Logged In');
      } else {
        // Log or handle the error accordingly
        console.log('An error occurred', error);
      }
    }
  };

  return (
    <div className="grid gap-y-10 place-items-center">
      <div className="mt-10 flex flex-col justify-center w-full max-w-2xl">
        <div className="mt-10 self-center">
          <h1 className="text-4xl font-bold mb-2 mt-30">Settings</h1>
        </div>
        <div className="relative">
          <UserPasswordTextField
            label={'New Password:'}
            userPassword={userPassword}
            setUserPassword={setUserPassword}
          />
          <p className={styles.warning}>{message}</p>
        </div>
        <div className="self-center pt-10">
          <button
            type="button"
            onClick={changePassword}
            className="py-[.688rem] px-4 inline-flex justify-center items-center gap-2 rounded-md border-2 border-gray-200 font-semibold text-blue-500 hover:text-white hover:bg-blue-500 hover:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all text-sm"
          >
            Save
          </button>
        </div>
      </div>
    </div>
  );
};

export default SettingPage;
