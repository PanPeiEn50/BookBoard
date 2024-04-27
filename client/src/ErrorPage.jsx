import { useRouteError } from 'react-router-dom';

const ErrorPage = () => {
  const error = useRouteError;
  console.error(error);

  return (
    <div id="error-page">
      <h1>Whoaaa</h1>
      <p>How'd you end up here?</p>
      <p>
        <i>{error.statusText || error.message}</i>
      </p>
    </div>
  );
};

export default ErrorPage;
