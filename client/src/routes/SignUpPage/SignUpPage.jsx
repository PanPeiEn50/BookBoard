import { useState } from 'react';
import { Link } from 'react-router-dom';
import UserNameTextField from '../../components/UserNameTextField';
import UserPasswordTextField from '../../components/UserPasswordTextField';
import ConfirmPasswordTextField from '../../components/ConfirmPasswordTextField';
import styles from './SignUpPage.module.css';
import { API_BASE_URL } from '../../utils/constants';
import axios from 'axios';

const SignUpPage = () => {
  const [userName, setUserName] = useState('');
  const [userPassword, setUserPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [message, setMessage] = useState('');

  const validatePassword = async () => {
    if (userPassword !== confirmPassword) {
      setMessage('The passwords are not the same!');
      return;
    }

    try {
      await axios.post(`${API_BASE_URL}/api/user/signup`, {
        user: {
          username: userName,
          password: userPassword,
        },
      });
      setMessage('Register Successfully!');
      document.location.href = '/login';
    } catch (error) {
      if (error.response && error.response.status === 400) {
        setMessage('Fail to Sign Up');
      } else {
        console.log('An error occurred', error);
      }
    }
  };

  return (
    <div className="grid gap-y-10 place-items-center">
      <div className="mt-10 flex flex-col justify-center w-full max-w-2xl">
        <div className="relative">
          <UserNameTextField userName={userName} setUserName={setUserName} />
          <UserPasswordTextField
            label="Password:"
            userPassword={userPassword}
            setUserPassword={setUserPassword}
          />
          <ConfirmPasswordTextField
            confirmPassword={confirmPassword}
            setConfirmPassword={setConfirmPassword}
          />
          <p className={styles.warning}> {message}</p>
        </div>
        <div className="self-center pt-10">
          <button
            type="button"
            onClick={validatePassword}
            className="py-[.688rem] px-4 inline-flex justify-center items-center gap-2 rounded-md border-2 border-gray-200 font-semibold text-blue-500 hover:text-white hover:bg-blue-500 hover:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all text-sm"
          >
            Sign Up
          </button>
        </div>
        <div className="mt-6 self-center underline underline-offset-4 text-blue-600">
          <Link to="/signin">Already have an account?</Link>
        </div>
      </div>
    </div>
  );
};

export default SignUpPage;
