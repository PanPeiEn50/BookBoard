import { useEffect, useState } from 'react';
import FilterBooksButton from './FilterBooksButton';
import { DEFAULT_SEARCH_FIELDS } from '../utils/constants';
import ClearFiltersButton from './ClearFiltersButton';

const SearchBar = ({ searchFields, setSearchFields, search, sortBy }) => {
  const [newSearchFields, setNewSearchFields] = useState(searchFields);

  useEffect(() => {
    setNewSearchFields(searchFields);
  }, [searchFields]);

  const handleTitleOrIsbnChanged = (event) => {
    setNewSearchFields({ ...newSearchFields, titleOrIsbn: event.target.value });
  };

  const handleTitleOrIsbnKeyDown = (event) => {
    if (event.key === 'Enter') {
      search({ ...newSearchFields, sortBy, page: 0 })
    }
  };

  return (
    <div className="mt-10 flex flex-col justify-center w-full max-w-2xl">
      <div className="relative">
        <label htmlFor="title-or-isbn-search" className="sr-only">
          Search
        </label>
        <input
          type="text"
          name="title-or-isbn-search"
          id="title-or-isbn-search"
          className="p-3 pr-12 block w-full border border-gray-200 rounded-md text-sm focus:border-blue-500 focus:ring-blue-500"
          placeholder="Enter title or ISBN"
          value={newSearchFields.titleOrIsbn}
          onChange={handleTitleOrIsbnChanged}
          onKeyDown={handleTitleOrIsbnKeyDown}
        />
        <button
          className="absolute inset-y-0 right-0 flex items-center px-3 text-gray-700"
          onClick={(event) => search({ ...newSearchFields, sortBy, page: 0 })}
        >
          <i className="fi fi-rr-search icon-fix"></i>
        </button>
      </div>
      <div className="flex gap-4 self-center pt-4">
        <FilterBooksButton
          searchFields={searchFields}
          setSearchFields={setSearchFields}
          newSearchFields={newSearchFields}
          setNewSearchFields={setNewSearchFields}
          search={search}
          sortBy={sortBy}
        />
        {JSON.stringify(searchFields) !==
          JSON.stringify(DEFAULT_SEARCH_FIELDS) && (
          <ClearFiltersButton
            setSearchFields={setSearchFields}
            setNewSearchFields={setNewSearchFields}
            search={search}
            sortBy={sortBy}
          />
        )}
      </div>
    </div>
  );
};

export default SearchBar;
