import BookCard from './BookCard';
import BookFields from './BookFields';

const BookDetails = ({ book }) => {
  return (
    <div className="flex p-10 gap-10 items-start">
      <div className="min-w-max">
        <BookCard book={book} />
      </div>
      <BookFields book={book} />
    </div>
  );
};

export default BookDetails;
