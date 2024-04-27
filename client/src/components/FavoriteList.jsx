import BookCard from './BookCard';

const FavoriteList = ( {books} ) => {

  return (
    <div className="grid grid-cols-2 xs:grid-cols-3 md:grid-cols-4 xl:grid-cols-5 max-w-max min-w-full place-items-center gap-5">
      {books.map((book) => (
        <BookCard book={book} hover={true} key={book.book_id} />
      ))}
    </div>
  );
};

export default FavoriteList;
