import { useState, createContext } from 'react';


export const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [isLogIn, setIsLogIn] = useState(false);

  return (
    <AuthContext.Provider value={{ isLogIn, setIsLogIn }}>
      {children}
    </AuthContext.Provider>
  );
};