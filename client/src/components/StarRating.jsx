import { useState } from 'react';
import ReviewStarButton from './ReviewStarButton';

const StarRating = ({ stars, setStars, disabled }) => {
  const [filledStars, setFilledStars] = useState(stars ?? 1);

  return (
    <div>
      {[...Array(5).keys()].map((i) => (
        <ReviewStarButton
          disabled={disabled ?? false}
          stars={stars}
          setStars={setStars}
          filledStars={filledStars}
          setFilledStars={setFilledStars}
          number={i + 1}
          key={i}
        />
      ))}
    </div>
  );
};

export default StarRating;
