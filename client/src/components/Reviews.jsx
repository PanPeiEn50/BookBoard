import Review from './Review';

const Reviews = ({ reviews }) => {
  return (
    <div className="grid p-10 gap-10">
      <h1 className="text-3xl font-bold">Reviews ({reviews.length})</h1>
      {reviews.length ? (
        reviews.map(({ username, stars, content, created_at }, index) => (
          <Review
            stars={stars}
            username={username}
            content={content}
            created_at={created_at}
            key={index}
          />
        ))
      ) : (
        <p>There are no reviews for this book yet.</p>
      )}
    </div>
  );
};

export default Reviews;
