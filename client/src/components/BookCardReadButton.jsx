import axios from 'axios';
import { API_BASE_URL } from '../utils/constants';

const BookCardReadButton = ({ book, read, setRead }) => {
  const handleButtonClick = async () => {
    const bookId = book.book_id;
    if (!read) {
      await axios.put(`${API_BASE_URL}/api/user/shelf/${bookId}`);
      setRead(true);
    } else {
      await axios.delete(`${API_BASE_URL}/api/user/shelf/${bookId}`);
      await axios.post(`${API_BASE_URL}/api/user/shelf/${bookId}`);
      setRead(false);
    }
  };

  return (
    <button
      className="flex grow shrink basis-0 justify-center py-3 text-2xl font-medium px-3 text-slate-100 hover:text-gray-500"
      onClick={handleButtonClick}
      title={read ? 'Mark book as unread' : 'Mark book as read'}
    >
      <i
        className={`fi icon-fix ${read ? 'fi-sr-book-alt' : 'fi-rr-book-alt'}`}
      ></i>
    </button>
  );
};

export default BookCardReadButton;
