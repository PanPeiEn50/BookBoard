import { Link } from 'react-router-dom';
import BookCardFavoriteButton from './BookCardFavoriteButton';
import BookCardReadButton from './BookCardReadButton';
import { useState } from 'react';

const BookCard = ({ book, hover = false }) => {
  const [favorite, setFavorite] = useState(book.favorite);
  const [read, setRead] = useState(book.read);
  const [hasCover, setHasCover] = useState(true);

  const loggedIn = sessionStorage.getItem('isLogIn') === 'true';

  const imageLoaded = (event) => {
    const image = event.currentTarget;
    if (image.width === 1 && image.height === 1) {
      setHasCover(false);
      image.src =
        'https://islandpress.org/sites/default/files/default_book_cover_2015.jpg';
    }
  };

  return (
    <div className="relative flex flex-col bg-slate-900 border border-gray-700 shadow-sm rounded-xl shadow-slate-700/[.7] h-full w-full">
      <div className="flex flex-col relative justify-center items-center h-full w-full">
        {hover && (
          <Link
            className="group absolute w-full h-full z-10"
            to={`/book/${book.book_id}`}
          >
            <div
              className={`${
                hasCover && 'hidden'
              } grid gap-2 absolute w-full h-full bg-black/80 px-4 py-3 rounded-xl text-gray-100 group-hover:grid`}
            >
              <p className="font-bold">{book.title}</p>
              <p className="italic">{`${book.first_name} ${book.last_name}`}</p>
              <p className="overflow-hidden whitespace-normal">
                {book.description}
              </p>
            </div>
          </Link>
        )}
        <div className="flex z-10 bg-slate-900 text-slate-100 absolute bottom-0 right-0 my-2 mx-3.5 py-1 px-2 rounded-xl">
          <p>
            <i className="fi icon-fix fi-sr-star pr-1"></i>
            {book.average_rating}
          </p>
        </div>
        <img
          className="rounded-xl max-h-80"
          src={`https://covers.openlibrary.org/b/ISBN/${book.isbn}-M.jpg`}
          alt="Book cover."
          onLoad={imageLoaded}
        />
      </div>
      <div className="flex flex-wrap gap-1 p-1">
        <Link
          className="inline-flex min-w-max max-w-max items-center gap-1.5 py-1 px-2.5 rounded-full text-xs font-medium bg-blue-500 text-white"
          to={`/search?genre=${book.genre}`}
        >
          {book.genre}
        </Link>
      </div>
      {loggedIn && (
        <div className="mt-auto flex border-t border-gray-700 divide-x divide-gray-700">
          <BookCardFavoriteButton
            book={book}
            favorite={favorite}
            setFavorite={setFavorite}
            setRead={setRead}
          />
          {favorite && (
            <BookCardReadButton
              className="grow shrink basis-0"
              book={book}
              read={read}
              setRead={setRead}
            />
          )}
        </div>
      )}
    </div>
  );
};

export default BookCard;
