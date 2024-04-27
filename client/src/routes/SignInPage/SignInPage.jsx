import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import UserNameTextField from '../../components/UserNameTextField';
import UserPasswordTextField from '../../components/UserPasswordTextField';
import { API_BASE_URL } from '../../utils/constants';
import styles from './SignInPage.module.css';
import axios from 'axios';
import { useContext } from 'react';
import { AuthContext } from '../../AuthContext';

const SignInPage = () => {
  const [userName, setUserName] = useState('');
  const [userPassword, setUserPassword] = useState('');
  const [message, setMessage] = useState('');
  const { isLogIn, setIsLogIn } = useContext(AuthContext);

  useEffect(() => {
    const loginStatus = sessionStorage.getItem('isLogIn') === 'true';
    setIsLogIn(loginStatus);
  }, []);

  const verifyUser = async () => {
    try {
      await axios.post(`${API_BASE_URL}/api/user/login`, {
        user: {
          username: userName,
          password: userPassword,
        },
      });
      // If the login is successful, set the session status.
      sessionStorage.setItem('isLogIn', 'true');
      setIsLogIn(true);
      setMessage('Sign In Successfully!');
      document.location.href = '/search';
    } catch (error) {
      if (error.response && error.response.status === 400) {
        setMessage('Fail to Sign In');
        // If the login fails, set the session status accordingly.
        sessionStorage.setItem('isLogIn', 'false');
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
          <p className={styles.warning}>{message}</p>
        </div>

        <div className="self-center pt-10">
          <button
            type="button"
            onClick={verifyUser}
            className="py-[.688rem] px-4 inline-flex justify-center items-center gap-2 rounded-md border-2 border-gray-200 font-semibold text-blue-500 hover:text-white hover:bg-blue-500 hover:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all text-sm"
          >
            Sign In
          </button>
        </div>

        <div className="mt-6 self-center underline underline-offset-4 text-blue-600">
          <Link to="/signup">Don't have an account?</Link>
        </div>
      </div>
    </div>
  );
};

export default SignInPage;
