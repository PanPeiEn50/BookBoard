import { DEFAULT_SEARCH_FIELDS } from '../utils/constants';

const ClearFiltersButton = ({
  setSearchFields,
  setNewSearchFields,
  search,
  sortBy,
}) => {
  const handleButtonClicked = (event) => {
    setSearchFields(DEFAULT_SEARCH_FIELDS);
    setNewSearchFields(DEFAULT_SEARCH_FIELDS);
    search(DEFAULT_SEARCH_FIELDS);
  };

  return (
    <button
      type="button"
      className="py-3 px-4 inline-flex justify-center items-center gap-2 rounded-md border-2 border-red-200 font-semibold text-red-500 hover:text-white hover:bg-red-500 hover:border-red-500 focus:outline-none focus:ring-2 focus:ring-red-200 focus:ring-offset-2 transition-all text-sm dark:focus:ring-offset-gray-800"
      onClick={handleButtonClicked}
    >
      Clear Filters
    </button>
  );
};

export default ClearFiltersButton;
