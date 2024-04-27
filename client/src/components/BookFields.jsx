import { Link } from 'react-router-dom';

const BookFields = ({ book }) => {
  const author = `${book.first_name} ${book.last_name}`;

  return (
    <div className="text-xl">
      <h1 className="text-3xl font-bold pb-3">{book.title}</h1>
      <div className="grid gap-3 pt-4 text-lg">
        <div className="flex">
          <i className="text-2xl fi fi-ss-user icon-fix"></i>
          <p className="pl-2">
            <Link className="text-blue-600" to={`/search?author=${author}`}>
              {author}
            </Link>
          </p>
        </div>
        <div className="flex">
          <i className="text-2xl fi fi-rr-barcode-read icon-fix"></i>
          <p className="pl-2">{book.isbn}</p>
        </div>
        <div className="flex">
          <i className="text-2xl fi fi-sr-theater-masks icon-fix"></i>
          <p className="pl-2">
            <Link className="text-blue-600" to={`/search?genre=${book.genre}`}>
              {book.genre}
            </Link>
          </p>
        </div>
        <div className="flex">
          <i className="text-2xl fi fi-sr-ufo icon-fix"></i>
          <p className="pl-2">{book.fiction ? 'Fiction' : 'Non-Fiction'}</p>
        </div>
        <div className="flex">
          <i className="text-2xl fi fi-sr-poll-h icon-fix"></i>
          <p className="pl-2">{book.description}</p>
        </div>
      </div>
    </div>
  );
};

export default BookFields;
