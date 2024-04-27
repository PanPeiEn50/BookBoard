const ReviewStarButton = ({
  disabled,
  stars,
  setStars,
  filledStars,
  setFilledStars,
  number,
}) => {
  return (
    <button disabled={disabled}>
      <i
        className={`fi p-1 ${
          filledStars >= number ? 'fi-sr-star' : 'fi-rr-star'
        } ${disabled ? '' : 'text-yellow-600'}`}
        onClick={disabled ? undefined : () => setStars(number)}
        onMouseEnter={disabled ? undefined : () => setFilledStars(number)}
        onMouseLeave={disabled ? undefined : () => setFilledStars(stars)}
      ></i>
    </button>
  );
};

export default ReviewStarButton;
