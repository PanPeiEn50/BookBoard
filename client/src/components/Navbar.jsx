import { Link } from 'react-router-dom';
import axios from 'axios';
import { API_BASE_URL } from '../utils/constants';
import { useEffect } from 'react';
import { useContext } from 'react';
import { AuthContext } from '../AuthContext';

const Navbar = ({ current }) => {
  const { isLogIn, setIsLogIn } = useContext(AuthContext);

  const logout = async () => {
    await axios.get(`${API_BASE_URL}/api/user/logout`);

    sessionStorage.setItem('isLogIn', 'false');
    setIsLogIn(false);
    document.location.href = '/';
  };

  useEffect(() => {
    const loginStatus = sessionStorage.getItem('isLogIn') === 'true';
    setIsLogIn(loginStatus);
  }, []);

  return (
    <header className="flex flex-wrap sm:justify-start sm:flex-nowrap z-50 w-full bg-gray-800 text-sm py-4">
      <nav
        className="max-w-[85rem] w-full mx-auto px-4 sm:flex sm:items-center sm:justify-between"
        aria-label="Global"
      >
        <div className="flex flex-row w-full items-center gap-5 mt-0 justify-between">
          <div className="flex grow shrink basis-0 justify-start gap-2">
            {isLogIn && (
              <Link
                className="text-2xl font-medium px-3 text-slate-100 hover:text-gray-400 hover:text-gray-500"
                to="/settings"
                {...(current === 'settings' && { 'aria-current': 'page' })}
              >
                <i
                  className={`fi icon-fix ${
                    current !== 'settings' ? 'fi-rr-settings' : 'fi-sr-settings'
                  }`}
                ></i>
              </Link>
            )}
            {isLogIn && (
              <Link
                className="text-2xl font-medium px-3 text-slate-100 hover:text-gray-500"
                to="/shelf"
                {...(current === 'shelf' && { 'aria-current': 'page' })}
              >
                <i
                  className={`fi icon-fix ${
                    current !== 'shelf' ? 'fi-rr-books' : 'fi-sr-books'
                  }`}
                ></i>
              </Link>
            )}
          </div>
          <div className="flex grow shrink basis-0 justify-center">
            <Link className="font-bold text-4xl text-slate-50 font-logo" to="/">
              BookBoard
            </Link>
          </div>
          <div className="flex grow shrink basis-0 justify-end gap-2">
            <Link
              className="flex text-2xl font-medium px-3 text-slate-100 hover:text-gray-500"
              to="/search"
              {...(current === 'search' && { 'aria-current': 'page' })}
            >
              <i
                className={`m-auto fi icon-fix ${
                  current !== 'search' ? 'fi-rr-search' : 'fi-sr-search'
                }`}
              ></i>
            </Link>
            {isLogIn ? (
              <button
                type="button"
                className="py-[.688rem] px-4 inline-flex justify-center items-center gap-2 rounded-md border-2 border-gray-700 font-semibold text-slate-100 hover:text-white hover:bg-blue-500 hover:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all text-sm"
                onClick={logout}
              >
                Logout
              </button>
            ) : (
              <Link
                type="button"
                className="py-[.688rem] px-4 inline-flex justify-center items-center gap-2 rounded-md border-2 border-gray-700 font-semibold text-slate-100 hover:text-white hover:bg-blue-500 hover:border-blue-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all text-sm"
                to="/login"
              >
                Login
              </Link>
            )}
          </div>
        </div>
      </nav>
    </header>
  );
};

export default Navbar;
