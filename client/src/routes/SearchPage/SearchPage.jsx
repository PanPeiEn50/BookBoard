import { useEffect, useId, useState } from 'react';
import SearchBar from '../../components/SearchBar';
import SearchResults from '../../components/SearchResults';
import {
  API_BASE_URL,
  DEFAULT_SEARCH_FIELDS,
  ISBN_REGEX,
  RESULTS_PER_PAGE_OPTIONS,
  SORT_OPTIONS,
} from '../../utils/constants';
import { useLoaderData, useNavigate } from 'react-router-dom';
import axios from 'axios';
import SearchPageNavigation from './SearchPageNavigation';

const getSelectSortValue = (searchParams) => {
  const sortBy = searchParams.get('sortBy');
  if (!sortBy) {
    return DEFAULT_SEARCH_FIELDS.sortBy;
  }
  const order = searchParams.get('asc') === 'true' ? 'asc' : 'desc';
  return `${sortBy}-${order}`;
};

const parseSearchParams = (searchParams) => {
  const titleOrIsbn = searchParams.get('titleOrIsbn');
  const authors = searchParams.getAll('author');
  const genres = searchParams.getAll('genre');
  const fiction = searchParams.get('fiction');
  const avgRating = searchParams.get('avgRating');
  const sortBy = getSelectSortValue(searchParams);
  const resultsPerPage = searchParams.get('resultsPerPage');
  const page = searchParams.get('page');

  return {
    titleOrIsbn,
    authors,
    genres,
    fiction,
    avgRating,
    sortBy,
    resultsPerPage,
    page,
  };
};

const createSearchFields = (searchParams) => ({
  titleOrIsbn: searchParams.titleOrIsbn ?? DEFAULT_SEARCH_FIELDS.titleOrIsbn,
  authors: searchParams.authors ?? DEFAULT_SEARCH_FIELDS.authors,
  genres: searchParams.genres ?? DEFAULT_SEARCH_FIELDS.genres,
  fiction: searchParams.fiction ?? DEFAULT_SEARCH_FIELDS.fiction,
  avgRating: searchParams.avgRating ?? DEFAULT_SEARCH_FIELDS.avgRating,
  sortBy: searchParams.sortBy ?? DEFAULT_SEARCH_FIELDS.sortBy,
  resultsPerPage:
    searchParams.resultsPerPage ?? DEFAULT_SEARCH_FIELDS.resultsPerPage,
  page: searchParams.page ?? DEFAULT_SEARCH_FIELDS.page,
});

export async function loader({ request }) {
  const searchParams = new URL(request.url).searchParams;
  const parsedSearchParams = parseSearchParams(searchParams);
  const { titleOrIsbn, resultsPerPage, page } = parsedSearchParams;

  let favoriteBooks = [];
  try {
    const favoriteBooksResponse = await axios.get(
        `${API_BASE_URL}/api/user/shelf?pagesize=1000`
    );
    favoriteBooks = favoriteBooksResponse.data;
  } catch (error) {
    console.log(error);
  }
  const readBookIds = favoriteBooks
    .filter((book) => !!book.read)
    .map((book) => book.book_id);
  const favoriteBookIds = favoriteBooks.map((book) => book.book_id);

  const isIsbn = ISBN_REGEX.test(titleOrIsbn);
  if (isIsbn) {
    const isbn = titleOrIsbn;
    let book;
    try {
      const bookResponse = await axios.get(`${API_BASE_URL}/api/book/${isbn}`);
      book = bookResponse.data[0];
    } catch (error) {
      console.error(error);
    }
    let foundBooks = book ? [book] : [];
    foundBooks = foundBooks.map((book) => ({
      ...book,
      read: readBookIds.includes(book.book_id),
      favorite: favoriteBookIds.includes(book.book_id),
    }));
    return {
      foundBooks,
      nextFoundBooks: null,
      searchParams: parsedSearchParams,
    };
  }

  const title = titleOrIsbn;
  const requestSearchParams = new URLSearchParams(searchParams);
  if (requestSearchParams.has('titleOrIsbn')) {
    requestSearchParams.append('title', title);
    requestSearchParams.delete('titleOrIsbn');
  }
  if (requestSearchParams.has('page')) {
    requestSearchParams.append('pagenum', page);
    requestSearchParams.delete('page');
  }
  if (requestSearchParams.has('resultsPerPage')) {
    requestSearchParams.append('pagesize', resultsPerPage);
    requestSearchParams.delete('resultsPerPage');
  }

  let foundBooks;
  try {
    const response = await axios.get(
      `${API_BASE_URL}/api/book/books?${requestSearchParams}`
    );
    foundBooks = response.data;
    foundBooks = foundBooks.map((book) => ({
      ...book,
      read: readBookIds.includes(book.book_id),
      favorite: favoriteBookIds.includes(book.book_id),
    }));
  } catch (error) {
    console.error(error);
  }

  let nextFoundBooks;
  try {
    requestSearchParams.set('pagenum', page ? parseInt(page) + 1 : 1);
    const nextResponse = await axios.get(
      `${API_BASE_URL}/api/book/books?${requestSearchParams}`
    );
    nextFoundBooks = nextResponse.data;
  } catch (error) {
    console.error(error);
  }

  return { foundBooks, nextFoundBooks, searchParams: parsedSearchParams };
}

const SearchPage = () => {
  const { foundBooks, nextFoundBooks, searchParams } = useLoaderData();
  const [searchFields, setSearchFields] = useState(
    createSearchFields(searchParams)
  );
  const id = useId();
  const navigate = useNavigate();

  const search = (searchFields) => {
    const params = new URLSearchParams();
    if (searchFields.titleOrIsbn) {
      params.append('titleOrIsbn', searchFields.titleOrIsbn);
    }
    if (searchFields.authors?.length) {
      for (const author of searchFields.authors) {
        params.append('author', author);
      }
    }
    if (searchFields.genres?.length) {
      for (const genre of searchFields.genres) {
        params.append('genre', genre);
      }
    }
    if (searchFields.fiction && searchFields.fiction !== 'any') {
      params.append('fiction', searchFields.fiction);
    }
    if (searchFields.avgRating && searchFields.avgRating !== 'any') {
      params.append('avgRating', searchFields.avgRating);
    }

    const sortByFieldAndOrder = searchFields.sortBy.split('-');
    const sortByField = sortByFieldAndOrder[0];
    const sortByAsc = sortByFieldAndOrder[1] === 'asc';

    params.append('sortBy', sortByField);
    params.append('asc', sortByAsc);

    if (searchFields.resultsPerPage) {
      params.append('resultsPerPage', searchFields.resultsPerPage);
    }
    if (searchFields.page) {
      params.append('page', searchFields.page);
    }

    return navigate(`/search?${params.toString()}`, { replace: true });
  };

  const handleSortChange = (event) => {
    const newSortBy = event.target.value;
    const newSearchFields = { ...searchFields, sortBy: newSortBy, page: 0 };
    setSearchFields(newSearchFields);
    search(newSearchFields);
  };

  const handleResultsPerPageChange = (event) => {
    const newResultsPerPage = event.target.value;
    const newSearchFields = {
      ...searchFields,
      resultsPerPage: newResultsPerPage,
      page: 0,
    };
    setSearchFields(newSearchFields);
    search(newSearchFields);
  };

  useEffect(() => {
    setSearchFields(createSearchFields(searchParams));
  }, [searchParams]);

  return (
    <div className="grid gap-y-10 place-items-center">
      <SearchBar
        searchFields={searchFields}
        setSearchFields={setSearchFields}
        search={search}
        sortBy={searchFields.sortBy}
      />
      <h1 className="text-3xl font-bold">Search Results</h1>
      <div className="flex w-full justify-between items-center">
        <div className="flex flex-col items-start">
          <label
            htmlFor={id}
            className="block text-sm font-medium mb-2 dark:text-white"
          >
            Results per Page
          </label>
          <select
            id={id}
            className="py-3 px-4 pr-9 block w-full border-gray-200 rounded-md text-sm border focus:border-blue-500 focus:ring-blue-500"
            value={searchFields.resultsPerPage}
            onChange={handleResultsPerPageChange}
          >
            {RESULTS_PER_PAGE_OPTIONS.map((option) => (
              <option value={option.value} key={option.value}>
                {option.text}
              </option>
            ))}
          </select>
        </div>
        <div className="flex flex-col items-end">
          <label
            htmlFor={id}
            className="block text-sm font-medium mb-2 dark:text-white"
          >
            Sort
          </label>
          <select
            id={id}
            className="py-3 px-4 pr-9 block w-full border-gray-200 rounded-md text-sm border focus:border-blue-500 focus:ring-blue-500"
            value={searchFields.sortBy}
            onChange={handleSortChange}
          >
            {SORT_OPTIONS.map((option) => (
              <option value={option.value} key={option.value}>
                {option.text}
              </option>
            ))}
          </select>
        </div>
      </div>
      <SearchPageNavigation
        search={search}
        searchFields={searchFields}
        setSearchFields={setSearchFields}
        showNext={!!nextFoundBooks}
      />
      {foundBooks ? (
        <SearchResults foundBooks={foundBooks} />
      ) : (
        <p>No books found.</p>
      )}
      <SearchPageNavigation
        search={search}
        searchFields={searchFields}
        setSearchFields={setSearchFields}
        showNext={!!nextFoundBooks}
      />
    </div>
  );
};

export default SearchPage;
