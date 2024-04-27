import styles from './SearchPageNavigation.module.css';

const SearchPageNavigation = ({
  search,
  searchFields,
  setSearchFields,
  showNext,
}) => {
  const showPrevious = !!searchFields.page;

  const handlePreviousButtonClick = () => {
    const newPage = Math.max(parseInt(searchFields.page) - 1, 0);
    const newSearchFields = { ...searchFields, page: newPage };
    setSearchFields(newSearchFields);
    search(newSearchFields);
  };

  const handleNextButtonClick = () => {
    const newPage = parseInt(searchFields.page) + 1;
    const newSearchFields = { ...searchFields, page: newPage };
    setSearchFields(newSearchFields);
    search(newSearchFields);
  };

  return (
    <div className="flex min-w-full justify-between items-center">
      <button
        className={`flex justify-center py-3 text-2xl font-medium px-3 text-slate-100 hover:text-gray-500 ${
          styles['nav-button']
        } ${!showPrevious && 'invisible'}`}
        onClick={handlePreviousButtonClick}
        title={'Previous'}
      >
        <i className={`fi icon-fix fi-rr-caret-left`}></i>
      </button>
      <p>Page {parseInt(searchFields.page) + 1}</p>
      <button
        className={`flex justify-center py-3 text-2xl font-medium px-3 text-slate-100 hover:text-gray-500 ${
          styles['nav-button']
        } ${!showNext && 'invisible'}`}
        onClick={handleNextButtonClick}
        title={'Next'}
      >
        <i className={`fi icon-fix fi-rr-caret-right`}></i>
      </button>
    </div>
  );
};

export default SearchPageNavigation;
