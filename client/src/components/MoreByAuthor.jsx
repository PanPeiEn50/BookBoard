import BookCard from './BookCard';

const MoreByAuthor = ({ books }) => {
  return (
    <div className="flex flex-col p-10 gap-5">
      <h1 className="text-3xl font-bold">More by author</h1>
      <div className="flex gap-10 items-start overflow-auto">
        {books.map((book) => (
          <div className="min-w-max" key={book.book_id}>
            <BookCard book={book} hover={true} />
          </div>
        ))}
      </div>
    </div>
  );
};

export default MoreByAuthor;
