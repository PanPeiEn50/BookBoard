import BookCard from './BookCard';

const SearchResults = ({ foundBooks }) => {
  return (
    <div className="grid grid-cols-2 xs:grid-cols-3 md:grid-cols-4 xl:grid-cols-5 max-w-max min-w-full place-items-center gap-5">
      {foundBooks &&
        foundBooks.map((book) => (
          <BookCard book={book} key={book.book_id} hover={true} />
        ))}
    </div>
  );
};

export default SearchResults;
