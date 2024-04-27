import axios from 'axios';
import { API_BASE_URL } from '../utils/constants';

const BookCardFavoriteButton = ({ book, favorite, setFavorite, setRead }) => {
  const handleButtonClick = async () => {
    const bookId = book.book_id;
    if (!favorite) {
      await axios.post(`${API_BASE_URL}/api/user/shelf/${bookId}`);
      setFavorite(true);
    } else {
      await axios.delete(`${API_BASE_URL}/api/user/shelf/${bookId}`);
      setRead(false);
      setFavorite(false);
    }
  };

  return (
    <button
      className="flex grow shrink basis-0 justify-center py-3 text-2xl font-medium px-3 text-slate-100 hover:text-gray-500"
      onClick={handleButtonClick}
      title={favorite ? 'Remove from favorites' : 'Add to favorites'}
    >
      <i
        className={`fi icon-fix ${favorite ? 'fi-sr-star' : 'fi-rr-star'}`}
      ></i>
    </button>
  );
};

export default BookCardFavoriteButton;
