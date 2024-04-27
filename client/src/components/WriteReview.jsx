import { useState } from 'react';
import StarRating from './StarRating';
import { API_BASE_URL } from '../utils/constants';
import axios from 'axios';

const WriteReview = ({ book_id }) => {
  const [stars, setStars] = useState(1);
  const [content, setContent] = useState('');

  const submitClicked = async () => {
    try {
      await axios.post(`${API_BASE_URL}/api/review`, {
        book_id: book_id,
        stars,
        content,
      });
      window.location.reload();
    } catch (error) {
      console.log(error);
    }
  };

  return (
    <div className="flex flex-col p-10 gap-5">
      <h1 className="text-3xl font-bold">Leave a Review</h1>
      <StarRating stars={stars} setStars={setStars} />
      <textarea
        className="py-3 px-4 block w-full border border-gray-200 rounded-md text-m focus:border-blue-500 focus:ring-blue-500 dark:bg-slate-900 dark:border-gray-700 dark:text-gray-400"
        rows="5"
        placeholder="Write your thoughts about the book."
        value={content}
        onChange={(e) => setContent(e.target.value)}
      ></textarea>
      <button
        type="button"
        className="self-end py-3 px-4 inline-flex justify-center items-center gap-2 rounded-md border border-transparent font-semibold bg-blue-500 text-white hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-all text-sm dark:focus:ring-offset-gray-800"
        onClick={submitClicked}
      >
        Post
      </button>
    </div>
  );
};

export default WriteReview;
