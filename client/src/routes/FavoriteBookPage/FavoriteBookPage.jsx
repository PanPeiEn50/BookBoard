import FavoriteList from '../../components/FavoriteList';
import { API_BASE_URL } from '../../utils/constants';
import { useLoaderData } from 'react-router-dom';
import axios from 'axios';

export async function loader() {
  const shelf = await axios.get(`${API_BASE_URL}/api/user/shelf`);
  let favoriteBooks = [];
  try {
    const favoriteBooksResponse = await axios.get(
      `${API_BASE_URL}/api/user/shelf?pagesize=1000`
    );
    favoriteBooks = favoriteBooksResponse.data;
  } catch (error) {
    console.log(error);
  }
  const readBookIds = favoriteBooks
    .filter((book) => !!book.read)
    .map((book) => book.book_id);
  const favoriteBookIds = favoriteBooks.map((book) => book.book_id);
  let books = shelf.data;
  books = books.map((book) => ({
    ...book,
    read: readBookIds.includes(book.book_id),
    favorite: favoriteBookIds.includes(book.book_id),
  }));
  return { books };
}

const FavoriteBookPage = () => {
  const { books } = useLoaderData();
  return (
    <div className="grid gap-y-10 place-items-center">
      <h1 className="mt-20 text-5xl font-bold justify-center mb-20">Shelf</h1>
      {books.length ? <FavoriteList books={books} /> : <p>Shelf is empty.</p>}
    </div>
  );
};

export default FavoriteBookPage;
