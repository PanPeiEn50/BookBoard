import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import ErrorPage from './ErrorPage';
import reportWebVitals from './reportWebVitals';
import { createBrowserRouter, RouterProvider } from 'react-router-dom';
import BookDetailsPage, {
  loader as bookDetailsLoader,
} from './routes/BookDetailsPage/BookDetailsPage';
import Root from './routes/Root';
import LoginPage from './routes/LoginPage/LoginPage';
import SearchPage, {
  loader as foundBooksLoader,
} from './routes/SearchPage/SearchPage';
import HomePage from './routes/HomePage/HomePage'
import FavoriteBookPage, { loader } from './routes/FavoriteBookPage/FavoriteBookPage'
import SignInPage from './routes/SignInPage/SignInPage';
import SignUpPage from './routes/SignUpPage/SignUpPage';
import SettingPage from './routes/SettingPage/SettingPage';

import('preline');

const router = createBrowserRouter([
  {
    path: '/',
    element: <Root />,
    errorElement: <ErrorPage />,
    children: [
      {
        path: '/login',
        element: <SignInPage />,
      },
      {
        path: '/book/:id',
        element: <BookDetailsPage />,
        loader: bookDetailsLoader,
      },
      {
        path: '/search',
        element: <SearchPage />,
        loader: foundBooksLoader,
      },
      {
        path: '/shelf',
        element: <FavoriteBookPage />,
        loader: loader,
      },
      {
        path: '/signin',
        element: <SignInPage />,
      },
      {
        path: '/signup',
        element: <SignUpPage />,
      },
      {
        path: '/settings',
        element: <SettingPage />,
      },
      {
        path: '/',
        element: <HomePage />,
      },
    ],
  },
]);

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <RouterProvider router={router} />
  </React.StrictMode>
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
