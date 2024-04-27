import React from 'react';
import { Outlet, useLocation } from 'react-router-dom';
import Navbar from '../components/Navbar';
import { AuthProvider } from '../AuthContext'; 

const Root = () => {
  const current = useLocation().pathname.split('/').at(-1);

  return (
    <AuthProvider> {/* Wrap the returned components with AuthProvider */}
      <div>
        <Navbar current={current} />
        <div className="container mx-auto max-w-7xl px-10">
          <Outlet />
        </div>
      </div>
    </AuthProvider>
  );
};

export default Root;
