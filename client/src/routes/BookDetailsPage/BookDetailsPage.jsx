import BookDetails from '../../components/BookDetails';
import Reviews from '../../components/Reviews';
import WriteReview from '../../components/WriteReview';
import axios from 'axios';
import { API_BASE_URL } from '../../utils/constants';
import MoreByAuthor from '../../components/MoreByAuthor';
import { useLoaderData } from 'react-router-dom';

export async function loader({ params }) {
  const bookRes = await axios.get(`${API_BASE_URL}/api/book/${params.id}`);
  const book = bookRes.data[0];
  try {
    const favoritesResponse = await axios.get(
      `${API_BASE_URL}/api/user/shelf?book_id=${book.book_id}`
    );
    const favorites = favoritesResponse.data;
    const favorite = favorites.length ? true : false;
    const read = favorite ? favorites[0].read : false;
    book.favorite = favorite;
    book.read = read;
  } catch (error) {
    console.log(error);
  }

  const searchParams = new URLSearchParams();
  const authorName = `${book.first_name} ${book.last_name}`;
  searchParams.append('author', authorName);
  const booksByAuthorRes = await axios.get(
    `${API_BASE_URL}/api/book/books?${searchParams}`
  );
  const booksByAuthor = booksByAuthorRes.data.filter(
    (bookByAuthor) => bookByAuthor.book_id !== book.book_id
  );

  let reviews = [];
  try {
    const reviewsResponse = await axios.get(
      `${API_BASE_URL}/api/review/${params.id}`
    );
    reviews = reviewsResponse.data;
  } catch (error) {
    console.error(error);
  }

  return { book, booksByAuthor, reviews };
}

const BookDetailsPage = ({ search }) => {
  const { book, booksByAuthor, reviews } = useLoaderData();

  const loggedIn = sessionStorage.getItem('isLogIn') === 'true';

  return (
    <>
      {book && (
        <>
          <BookDetails book={book} />
          {booksByAuthor.length ? (
            <MoreByAuthor books={booksByAuthor} search={search} />
          ) : (
            <></>
          )}
          {loggedIn && <WriteReview book_id={book.book_id} />}
          <Reviews reviews={reviews} />
        </>
      )}
    </>
  );
};

export default BookDetailsPage;
