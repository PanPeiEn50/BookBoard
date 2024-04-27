import StarRating from './StarRating';

const Review = ({ stars, username, content, created_at }) => {
  const dateFormatted = new Date(created_at).toLocaleDateString('en-US');

  return (
    <div className="flex flex-col">
      <div className="pb-4">
        <div className="flex justify-between">
          <StarRating stars={stars} disabled={true} />
          <p className="italic">{username}</p>
        </div>
      </div>
      <p className="pb-4">{content}</p>
      <p className="self-end">{dateFormatted}</p>
    </div>
  );
};

export default Review;
